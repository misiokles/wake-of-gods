#include "StdInc.h"
#include <iostream>
#include <memory>
#include <stdexcept>
#include <algorithm>

#include "../lib/VCMIDirs.h"
#include "../lib/spells/CSpell.h"
#include "../lib/spells/ISpellMechanics.h"
#include "../lib/GameLibrary.h"
#include "../lib/modding/CModHandler.h"
#include "../lib/modding/ModDescription.h"
#include "../lib/CConfigHandler.h"
#include "../lib/StartInfo.h"
#include "../lib/CCreatureHandler.h"
#include "../lib/CStack.h"
#include "../lib/IGameSettings.h"
#include "../lib/GameConstants.h"
#include "../lib/filesystem/ResourcePath.h"
#include "../lib/gameState/CGameState.h"
#include "../lib/mapObjects/CGHeroInstance.h"
#include "../lib/mapObjects/army/CStackInstance.h"
#include "../lib/mapping/CMap.h"
#include "../lib/mapping/CMapHeader.h"
#include "../lib/battle/BattleInfo.h"
#include "../lib/battle/BattleLayout.h"
#include "../lib/constants/EntityIdentifiers.h"
#include "../lib/battle/BattleAction.h"
#include "../lib/bonuses/Bonus.h"
#include "../lib/callback/GameRandomizer.h"
#include "../lib/modding/IdentifierStorage.h"
#include "../lib/modding/ModScope.h"
#include "../lib/networkPacks/PacksForClient.h"
#include "../lib/networkPacks/PacksForClientBattle.h"
#include "../lib/logging/CBasicLogConfigurator.h"
#include "../lib/CConsoleHandler.h"
#include "../server/CGameHandler.h"
#include "../server/battles/BattleProcessor.h"
#include "../server/activities/ActivityProcessor.h"
#include "../server/activities/BattleActivities.h"
#include "../server/IGameServer.h"
#include "../test/mock/TinyH3MBuilder.h"
#include "../test/mock/mock_MapServiceTinyH3M.h"

static void require(bool value, const std::string & message){ if(!value) throw std::runtime_error(message); }

class SimpleServer : public IGameServer {
public:
 std::shared_ptr<CGameState> gs;
 EServerState state=EServerState::GAMEPLAY;
 size_t injuredPackets=0;
 std::vector<int64_t> injuries;
 std::vector<std::string> battleLogs;
 void setState(EServerState x) override {state=x;}
 EServerState getState() const override {return state;}
 bool isPlayerHost(const PlayerColor &) const override {return true;}
 bool hasPlayerAt(PlayerColor,GameConnectionID) const override {return true;}
 bool hasBothPlayersAtSameConnection(PlayerColor,PlayerColor) const override {return true;}
 void sendPack(CPackForClient &,GameConnectionID) override {}
 void applyPack(CPackForClient &pack) override {
  if(auto *d=dynamic_cast<StacksInjured*>(&pack)){
   injuredPackets++;
   for(auto &x:d->stacks) injuries.push_back(x.damageAmount);
  }
  if(auto *l=dynamic_cast<BattleLogMessage*>(&pack))
   for(auto &line:l->lines) battleLogs.push_back(line.toString(LIBRARY->staticTexts()));
  gs->apply(pack);
 }
};

class Scenario : public MapListener {
public:
 std::shared_ptr<CGameState> gs;
 std::unique_ptr<MapServiceTinyH3M> mapLoader;
 CMap *currentMap=nullptr;
 std::shared_ptr<CGameHandler> handler;
 SimpleServer server;
 CGHeroInstance *h1=nullptr,*h2=nullptr;
 BattleInfo *battle=nullptr;

 void mapLoaded(CMap *map) override {
  currentMap=map;
  JsonNode enable;enable.Bool()=true;
  currentMap->overrideGameSetting(EGameSettings::MODULE_STACK_EXPERIENCE,enable);
 }
 void init(int defenderCreature, int attackerCount, int defenderCount, int rank) {
  gs=std::make_shared<CGameState>(); gs->preInit(LIBRARY);
  TinyH3M::TinyH3MBuilder builder(EMapFormat::SOD);
  builder.size(36,false).name("Deflect scenario")
   .playerActive(PlayerColor(0)).playerActive(PlayerColor(1))
   .hero({5,5,0},HeroTypeID(0),PlayerColor(0)).heroGarrison({{CreatureID(0),attackerCount}})
   .hero({7,7,0},HeroTypeID(1),PlayerColor(1)).heroGarrison({{CreatureID(110),defenderCount}});
  auto bytes=builder.buildAndDump("Deflect_Battle_Rank10");
  mapLoader=std::make_unique<MapServiceTinyH3M>(std::move(bytes),this,builder.script());
  StartInfo info;info.mapname="tiny";info.difficulty=static_cast<ui8>(EMapDifficulty::EASY);info.mode=EStartMode::NEW_GAME;
  auto header=mapLoader->loadMapHeader(ResourcePath(info.mapname));
  require(header!=nullptr,"map header unavailable");
  for(int i=0;i<(int)header->players.size();i++) {
   auto &pi=header->players[i];if(!pi.canHumanPlay && !pi.canComputerPlay) continue;
   auto &ps=info.playerInfos[PlayerColor(i)]; ps.color=PlayerColor(i);
   ps.connectedPlayerIDs.insert(static_cast<PlayerConnectionID>(i));
   ps.name="Tester";ps.castle=pi.defaultCastle();ps.hero=pi.defaultHero();ps.bonus=PlayerStartingBonus::GOLD;
  }
  GameRandomizer randomizer(*gs); Load::ProgressAccumulator progress;
  gs->init(mapLoader.get(), &info,randomizer,progress,false);
  require(currentMap!=nullptr,"game map not constructed");
  for(const auto &o:currentMap->objects){
   auto *h=dynamic_cast<CGHeroInstance*>(o.get());if(!h)continue;
   if(h->getOwner()==PlayerColor(0))h1=h;
   if(h->getOwner()==PlayerColor(1))h2=h;
  }
  require(h1 && h2,"two heroes not present");
  auto &stk=const_cast<CStackInstance&>(h2->getStack(SlotID(0)));
  stk.setType(CreatureID(defenderCreature));
  std::cout<<"ACTUAL_DEFENDER_CREATURE_ID="<<stk.getCreatureID().getNum()<<" NAME="<<stk.getName()<<" LEVEL="<<stk.getLevel()<<"\n";
  require(stk.canGainExperience(),"stack experience module disabled");
  auto target=stk.getExperienceForRank(rank);
  stk.giveTotalStackExperience(target*stk.getCount());
  std::cout<<"DEFENDER_RANK="<<stk.getExpRank()<<" XP_PER_UNIT="<<stk.getAverageExperience()<<"\n";
  require(stk.getExpRank()==rank,"defender rank not reached");
  server.gs=gs;
  handler=std::make_shared<CGameHandler>(server,gs);
  handler->randomizer->setSeed(1337);
  BattleSideArray<const CGHeroInstance*> heroes={h1,h2};
  BattleSideArray<const CArmedInstance*> armies={h1,h2};
  BattleLayout layout=BattleLayout::createDefaultLayout(*gs,armies[BattleSide::ATTACKER],armies[BattleSide::DEFENDER]);
  auto id=LIBRARY->identifiers()->getIdentifier(ModScope::scopeGame(),"battlefield",std::string("core:sand_shore"));
  require(id.has_value(),"battlefield ID unavailable");
  BattleField field(*id);
  BattleStart start;start.info=BattleInfo::setupBattle(gs.get(),int3(4,4,0),ETerrainId::SAND,field,armies,heroes,layout,nullptr);start.battleID=BattleID(0);
  handler->sendAndApply(start);
  require(gs->currentBattles.size()==1,"battle not created");
  battle=gs->currentBattles.front().get();battle->tacticDistance=0;battle->obstacles.clear();
  // No lobby activity is needed for a native automatic attack scenario.
 }
 CStack *find(BattleSide side) {
  for(auto &s:battle->stacks) if(s->unitSide()==side && s->unitSlot()==SlotID(0)) return s.get();
  return nullptr;
 }
 void begin() {
  for(const auto &u:battle->stacks)handler->battles->processBattleEventTriggers(*battle,CombatEventType::BATTLE_SETUP,u.get(),nullptr);
  battle->tacticDistance=1;battle->tacticsSide=BattleSide::ATTACKER;
  require(handler->battles->makePlayerBattleAction(BattleID(0),battle->sideToPlayer(BattleSide::ATTACKER),BattleAction::makeEndOFTacticPhase(BattleSide::ATTACKER)),"cannot begin battle");
 }
 bool strike(CStack *a,CStack *d){battle->activeStack=a->unitId();return handler->battles->makeAutomaticBattleAction(*battle,BattleAction::makeMeleeAttack(a,d->getPosition(),a->getPosition()));}
 void close(){handler.reset();gs.reset();mapLoader.reset();}
};



int main(){try{
 CConsoleHandler console; CBasicLogConfigurator lc(VCMIDirs::get().userLogsPath()/"aging.log",&console);lc.configureDefault();initializeBaseFilesystem(false);auto lib=std::make_unique<GameLibrary>();lib->initializeFilesystem();lc.configure();lib->initializeLibrary();setGameLibrary(std::move(lib));
 auto age=LIBRARY->identifiers()->getIdentifier(ModScope::scopeGame(),"spell",std::string("core:age"));require(age.has_value(),"age ID missing");auto ageSel=Selector::source(BonusSource::SPELL_EFFECT,BonusSourceID(SpellID(*age)));
 int scenarios=0,total=0,procs=0;
 for(auto name:{"ghostDragon","bloodDragon"}){
 auto id=LIBRARY->identifiers()->getIdentifier(ModScope::scopeGame(),"creature",(std::string(name)=="bloodDragon"?"wake-of-gods.level8units:":"core:")+std::string(name));require(id.has_value(),"no ID");int base=std::string(name)=="ghostDragon"?20:50;
 for(int r=0;r<=10;r+=5) {Scenario sc;sc.init(*id,100000,1,r);auto *u=sc.find(BattleSide::DEFENDER),*a=sc.find(BattleSide::ATTACKER);require(u&&a,"missing stack");sc.battle->moveUnit(a->unitId(),BattleHex(7,5));sc.battle->moveUnit(u->unitId(),BattleHex(8,5));auto nr=std::make_shared<Bonus>();nr->type=BonusType::NO_RETALIATION;nr->duration=BonusDuration::ONE_BATTLE;a->addNewBonus(nr);sc.begin();sc.handler->randomizer->setSeed(1234+r+*id*100);int raw=u->valOfBonuses(Selector::typeSubtype(BonusType::SPELL_AFTER_ATTACK,BonusSubtypeID(SpellID(*age))));require(raw==base,"wrong base chance");int expected=100-(100-base)*(100-8*r)/100;int actual=0;int maxHP=a->getMaxHealth();
 for(int hit=0;hit<100;hit++){require(sc.strike(u,a),"strike failed");require(a->alive()&&u->alive(),"stack died");auto bs=a->getBonuses(ageSel);if(!bs->empty()){actual++;require(a->getMaxHealth()==(maxHP+1)/2,"incorrect aged max HP");a->removeBonuses(ageSel);require(a->getMaxHealth()==maxHP,"age removal HP mismatch");}else require(a->getMaxHealth()==maxHP,"HP changed without Aging");}
 require(expected==100?actual==100:std::abs(actual-expected)<=20,"unexpected proc rate");std::cout<<"AGE_OK "<<name<<" rank="<<r<<" raw="<<raw<<" expected="<<expected<<" actual="<<actual<<"/100 maxHP="<<maxHP<<std::endl;scenarios++;total+=100;procs+=actual;sc.close();}}
 std::cout<<"ALL_AGING_PASS scenarios="<<scenarios<<" attacks="<<total<<" procs="<<procs<<std::endl;setGameLibrary(nullptr);lc.deconfigure();return 0;}catch(const std::exception&e){std::cerr<<"SCENARIO_FAILED: "<<e.what()<<std::endl;return 2;}}

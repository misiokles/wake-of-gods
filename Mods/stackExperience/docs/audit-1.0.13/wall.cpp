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
#include "../lib/battle/CObstacleInstance.h"
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
 std::vector<int> events;
 std::vector<int64_t> injuries;
 std::vector<std::string> battleLogs;
 void setState(EServerState x) override {state=x;}
 EServerState getState() const override {return state;}
 bool isPlayerHost(const PlayerColor &) const override {return true;}
 bool hasPlayerAt(PlayerColor,GameConnectionID) const override {return true;}
 bool hasBothPlayersAtSameConnection(PlayerColor,PlayerColor) const override {return true;}
 void sendPack(CPackForClient &,GameConnectionID) override {}
 void applyPack(CPackForClient &pack) override {
  if(auto *cast=dynamic_cast<BattleSpellCast*>(&pack); cast && cast->spellID.getNum()==50) events.push_back(1);
  if(dynamic_cast<BattleAttack*>(&pack)) events.push_back(2);
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
   .hero({5,5,0},HeroTypeID(0),PlayerColor(0)).heroGarrison({{CreatureID(0),attackerCount},{CreatureID(2),attackerCount},{CreatureID(56),attackerCount}})
   .hero({7,7,0},HeroTypeID(1),PlayerColor(1)).heroGarrison({{CreatureID(110),defenderCount},{CreatureID(4),100}});
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
 CConsoleHandler console; CBasicLogConfigurator lc(VCMIDirs::get().userLogsPath()/"firewall.log",&console);lc.configureDefault();initializeBaseFilesystem(false);auto lib=std::make_unique<GameLibrary>();lib->initializeFilesystem();lc.configure();lib->initializeLibrary();setGameLibrary(std::move(lib));
 auto id=LIBRARY->identifiers()->getIdentifier(ModScope::scopeGame(),"creature",std::string("wake-of-gods.messengersandemissaries:fireMessenger"));require(id.has_value(),"no Arch Devil");auto wall=LIBRARY->identifiers()->getIdentifier(ModScope::scopeGame(),"spell",std::string("core:fireWall")); auto trigger=LIBRARY->identifiers()->getIdentifier(ModScope::scopeGame(),"spell",std::string("core:fireWallTrigger"));require(wall&&trigger,"spell ids missing"); int total=0,procs=0,damageChecks=0;
 for(int rank=0;rank<=10;rank+=5){Scenario sc;sc.init(*id,60000,1,rank);auto *u=sc.find(BattleSide::DEFENDER);auto *a=sc.find(BattleSide::ATTACKER);require(u&&a,"stacks missing");sc.battle->moveUnit(a->unitId(),BattleHex(7,5));sc.battle->moveUnit(u->unitId(),BattleHex(8,5));auto nr=std::make_shared<Bonus>();nr->type=BonusType::NO_RETALIATION;nr->duration=BonusDuration::ONE_BATTLE;a->addNewBonus(nr);sc.begin();sc.handler->randomizer->setSeed(1337+rank);int hits=0;
 for(int n=0;n<100;n++){sc.battle->obstacles.clear();sc.server.battleLogs.clear();require(sc.strike(u,a),"attack failed");require(u->alive()&&a->alive(),"stack died");if(!sc.battle->obstacles.empty()){require(sc.battle->obstacles.size()==2,"expected 1 obstacle");auto *o=dynamic_cast<const SpellCreatedObstacle*>(sc.battle->obstacles.begin()->get());require(o!=nullptr,"not spell obstacle");require(o->ID==*wall&&o->trigger==SpellID(*trigger),"wrong spell/trigger");require(o->casterSpellPower==3&&o->spellLevel==1&&o->turnsRemaining==2&&o->casterSide==u->unitSide()&&o->passable,"incorrect obstacle descriptor");require(std::any_of(sc.server.battleLogs.begin(),sc.server.battleLogs.end(),[](const auto &l){return l.find("casts Fire Wall!")!=std::string::npos;}),"missing log");if(hits==0){auto hp=a->getAvailableHealth(); require(sc.battle->handleObstacleTriggersForUnit(*sc.handler->spellEnv,*a),"Fire Wall stops movement"); auto loss=hp-a->getAvailableHealth(); require(loss==40,"Fire Wall damage expected 40, actual "+std::to_string(loss)); std::cout<<"FIREWALL_DAMAGE rank="<<rank<<" loss="<<loss<<std::endl; damageChecks++;}hits++;}std::vector<uint32_t> rem;for(auto &st:sc.battle->stacks)if(st->isSummoned()&&st->alive())rem.push_back(st->unitId());for(auto id:rem)sc.battle->removeUnit(id);}
 require(rank==0?hits==0:std::abs(hits-rank*5)<=20,"unexpected proc rate");std::cout<<"FIREWALL_OK rank="<<rank<<" expected="<<rank*5<<" actual="<<hits<<"/100"<<std::endl;total+=100;procs+=hits;sc.close();}
 std::cout<<"ALL_FIREWALL_PASS attacks="<<total<<" procs="<<procs<<" damageChecks="<<damageChecks<<std::endl;setGameLibrary(nullptr);lc.deconfigure();return 0;}catch(const std::exception&e){std::cerr<<"SCENARIO_FAILED: "<<e.what()<<std::endl;return 2;}}

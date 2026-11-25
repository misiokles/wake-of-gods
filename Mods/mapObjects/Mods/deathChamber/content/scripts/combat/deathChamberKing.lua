local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index=Base})
Script.__index = Script

-- Original WoG source: s/8 wog - death chamber.erm (Script 70).
-- 17 columns, index = x + 17*y. 30 placements, four distinct graphics.
-- VCMI bank guard's first stack (Undead King) occupies hex 15. In the exact
-- WoG layout, the gravemarker anchored at 30 also blocks hex 31, barring
-- the only accessible approach for double-wide ATTACKER stacks (head 32,
-- tail 31). Shift that ONE marker from 30 to 29. All other anchors match WoG.
-- Tested with native BattleHex + Unit::getHexes (VCMI 1.8).
local OBSTACLES = {
    { graphic="ObHGs04.def", offsets={0,1,2,3}, anchors={59,127,89,97} },
    { graphic="ObSwS01.def", offsets={0}, anchors={3,5,7,9,11,13,173,175,177,179,181,183} },
    { graphic="ObHGs01.def", offsets={0,1}, anchors={21,24,26,27,29,157,160,162,163,166} },
    { graphic="ObHGs00.def", offsets={0}, anchors={75,79,109,113} }
}
local CRYPTS = {59,127,89,97}
local DREADS = {41,47,143,149}
local WRAITHS = {6,8,10,176,178,180}
local LICHES_ROUND2 = {60,128,90,98}
local GHOSTS_ROUND3 = {4,12,174,182}
local PHASE_2="DEATH_CHAMBER_PHASE_2"
local PHASE_3="DEATH_CHAMBER_PHASE_3"

-- WoG growth option is always enabled in this port. Calendar days are 1-based.
local function growth()
  local day=GAME:getCalendar():getCurrentDay()
  return math.max(0,math.floor((day-1)/7)-1),day>=22
end

local function hexAt(battle, index)
  local x,y=index%17,math.floor(index/17)
  local hexes=battle:getAllPossibleHexes()
  for i=1,hexes:size() do
    local hex=hexes:at(i)
    if hex:getX()==x and hex:getY()==y then return hex end
  end
  return nil
end

local function obstacleAt(battle, anchor)
  for _, obstacle in ipairs(battle:getAllObstacles()) do
    local pos=obstacle:getPosition()
    if pos and pos:getX()+17*pos:getY()==anchor then return obstacle end
  end
  return nil
end

local function log(server,battle,key,strings,numbers)
  local msg={append={key}}
  if strings then msg.replaceStrings=strings end
  if numbers then msg.replaceNumbers=numbers end
  server:appendLog(battle,msg)
end

local function nameOf(unit)
  return unit:getCreature():getNameTextID(unit:getCount())
end

local function logMagic(server,battle,key,king,spell,target)
  if not spell then return end
  local strings={nameOf(king),spell:getNameTextID()}
  if target then strings[#strings+1]=nameOf(target) end
  log(server,battle,key,strings)
end

local function placeObstacles(server,battle,unit)
  local placed=0
  for _, category in ipairs(OBSTACLES) do
    for _, pos in ipairs(category.anchors) do
      if not obstacleAt(battle,pos) then
        local root=hexAt(battle,pos)
        if root then
          local footprint={}
          for _,offset in ipairs(category.offsets) do
            local hex=hexAt(battle,pos+offset)
            if hex then footprint[#footprint+1]=hex end
          end
          server:addObstacle(battle,{
            pos=root,obstacleType=ENUM.ObstacleType.spellCreated,
            turnsRemaining=-1,casterSpellPower=0,spellLevel=0,
            casterSide=unit:getSide(),minimalDamage=0,hidden=false,
            passable=false,trap=false,removeOnTrigger=false,nativeVisible=true,
            appearAnimation=category.graphic,animation=category.graphic,
            customSize=footprint
          })
          placed=placed+1
        end
      end
    end
  end
  return placed
end

local function spawn(server,battle,side,creatureKey,count,index)
  if count<1 then return false end
  local creature=LIBRARY:getCreatureByName(creatureKey)
  local at=hexAt(battle,index)
  if creature and at and battle:isAccessibleForNewUnit(at,creature,side) then
    server:addUnit(battle,{
      count=count,type=creature,side=side,position=at,summoned=true
    })
    return true
  end
  return false
end

local function mark(server,battle,king,typ)
  server:addUnitBonus(battle,king,{
    type=typ,val=1,duration=ENUM.BonusDuration.oneBattle,
    sourceType=ENUM.BonusSource.creatureAbility,
    sourceID=king:getCreature():getJsonKey(), hidden=true
  },false)
end

local function addCurses(server,battle,king,difficulty)
  for _,other in ipairs(battle:getUnitsIf(function(one)
    return one:isAlive() and one:getSide()~=king:getSide()
  end)) do
    server:addUnitBonus(battle,other,{
      type="COMBAT_EVENT_TRIGGER",subtype="deathChamberCurseAction", val=difficulty,
      duration=ENUM.BonusDuration.oneBattle,stacking="deathChamberCurses",
      sourceType=ENUM.BonusSource.creatureAbility,
      sourceID=king:getCreature():getJsonKey()
    },false)
  end
end

local function helpAllies(server,battle,king)
  local friends=battle:getUnitsIf(function(one)
    return one:isAlive() and one:getSide()==king:getSide() and one:unitID()~=king:unitID()
  end)
  if #friends==0 then return end
  -- Original WoG refreshes buffs before allies act. v0.9.2 grants them
  -- at battle start; preserve the tested mechanics, add one log per SPELL
  -- (not one log per unit) to avoid a 20+ line log burst.
  for _,key in ipairs({"fireShield","counterstrike"}) do
    local spell=LIBRARY:getSpellByName(key)
    if spell then
      for _,friend in ipairs(friends) do
        server:applySpellEffects(battle,king,spell,{friend},1,3,false)
      end
      log(server,battle,"deathChamberWog.log.buff",{nameOf(king),spell:getNameTextID()},{#friends})
    end
  end
end

function Script:onBattleStart(server,battle,unit,other,payload)
  if not unit:isAlive() then return end
  -- Handle duplicate callback without creating 30 more obstacles or troops.
  if obstacleAt(battle,CRYPTS[1]) then return end
  local difficulty=math.max(1,math.min(5,self.val or 1))
  local weeks,late=growth()
  if late and self.creaturesCompatibility and not self.dracolichKing then
    local creature=LIBRARY:getCreatureByName("wake-of-gods.mapobjects.deathchamber.creaturescompatibility:deathChamberDracolichKing"..difficulty)
    if creature then
      local position=battle:getAvailableHex(creature,unit:getSide(),unit:getPosition())
      if position and position:isValid() then
        local replacement=server:addUnit(battle,{count=1,type=creature,side=unit:getSide(),position=position,summoned=false})
        if replacement then
          server:damageUnit(battle,unit,unit:getMaxHealth()*unit:getCount())
          unit=replacement
          self.dracolichKing=true
          log(server,battle,"deathChamberWog.log.transform")
        end
      end
    end
  end
  -- Bonuses are battle-local. Health growth is healed immediately to fill the new maximum.
  if weeks>0 then
    local hp=weeks*(self.dracolichKing and 5 or 2)
    for _,b in ipairs({{type="STACK_HEALTH",val=hp},{type="CREATURE_DAMAGE",subtype="creatureDamageMin",val=weeks},{type="CREATURE_DAMAGE",subtype="creatureDamageMax",val=weeks}}) do
      b.duration=ENUM.BonusDuration.oneBattle
      b.sourceType=ENUM.BonusSource.creatureAbility
      b.sourceID=unit:getCreature():getJsonKey()
      server:addUnitBonus(battle,unit,b,false)
    end
    server:healUnit(battle,unit,hp,ENUM.HealLevel.heal,ENUM.HealPower.permanent)
  end
  local total=placeObstacles(server,battle,unit)
  local side=unit:getSide()
  -- Script070: eleven Power Lich companies (ten for Dracolich).
  local guards=2*difficulty+weeks
  for _,at in ipairs(DREADS) do spawn(server,battle,side,"core:powerLich",guards,at) end
  for _,at in ipairs(WRAITHS) do spawn(server,battle,side,"core:powerLich",guards,at) end
  if not self.dracolichKing then spawn(server,battle,side,"core:powerLich",guards,94) end
  server:refreshBattleUnits(battle)
  addCurses(server,battle,unit,difficulty)
  helpAllies(server,battle,unit)
  log(server,battle,total==30 and "deathChamberWog.log.open" or "deathChamberWog.log.incomplete")
end

function Script:onRoundStart(server,battle,unit,other,payload)
  if not unit:isAlive() then return end
  local difficulty=math.max(1,math.min(5,self.val or 1))
  local side=unit:getSide()
  local armageddon=LIBRARY:getSpellByName("armageddon")
  if armageddon then
    -- The original King uses Anti-Magic to protect allies; preserve them in this adaptation.
    local targets=battle:getUnitsIf(function(one) return one:isAlive() and one:getSide()~=side end)
    if #targets>0 then
      server:applySpellEffects(battle,unit,armageddon,targets,1,1,false)
      logMagic(server,battle,"deathChamberWog.log.cast",unit,armageddon)
    end
    if not unit:isAlive() then return end
  end
  if not unit:hasBonuses({type=PHASE_2}) then
    -- WoG round 2: remove the four huge crypts before spawning new Liches.
    for _,p in ipairs(CRYPTS) do
      local obstacle=obstacleAt(battle,p)
      if obstacle then server:removeObstacle(battle,obstacle) end
    end
    for _,at in ipairs(LICHES_ROUND2) do
      spawn(server,battle,side,"lich",difficulty+growth()+server:rngInt(1,10),at)
    end
    mark(server,battle,unit,PHASE_2)
    server:refreshBattleUnits(battle)
    log(server,battle,"deathChamberWog.log.second")
    return
  end
  if not unit:hasBonuses({type=PHASE_3}) then
    -- Script070: m starts at zero, then m += v1176 and m *= 2.
    local ghostsPerStack = 2*(2*difficulty+growth())
    local ghostKey = self.creaturesCompatibility and "wake-of-gods.creatures:ghost" or "core:wraith"
    for _,at in ipairs(GHOSTS_ROUND3) do
      spawn(server,battle,side,ghostKey,ghostsPerStack,at)
    end
    mark(server,battle,unit,PHASE_3)
    server:refreshBattleUnits(battle)
    log(server,battle,self.creaturesCompatibility and "deathChamberWog.log.third" or "deathChamberWog.log.thirdFallback")
  end
  -- The original repeatedly inflicts Age from round 3 onward.
  local age=LIBRARY:getSpellByName("age")
  if age then
    local enemies=battle:getUnitsIf(function(one)
      return one:isAlive() and one:getSide()~=side
    end)
    for _,enemy in ipairs(enemies) do
      server:applySpellEffects(battle,unit,age,{enemy},3,2,false)
    end
    if #enemies>0 then
      -- applySpellEffects never writes an automatic cast log (VCMI API).
      log(server,battle,"deathChamberWog.log.age",{nameOf(unit),age:getNameTextID()})
    end
  end
end

function Script:onBeforeAttack(server,battle,unit,other,payload)
  if not unit:isAlive() then return end
  -- WoG casts before the King's ACTION, not once for each hit or retaliation.
  -- In VCMI a double attack/counterattack would otherwise cast Ripple 2-3x.
  if payload and (payload.isCounter or (payload.attackIndex or 0)>0) then return end
  local deathRipple=LIBRARY:getSpellByName("deathRipple")
  if not deathRipple then return end
  local targets=battle:getUnitsIf(function(one)
    return one:isAlive() and one:getSide()~=unit:getSide()
  end)
  if #targets>0 then
    server:castSpell(battle,unit,deathRipple,targets,math.max(1,self.val or 1))
    logMagic(server,battle,"deathChamberWog.log.cast",unit,deathRipple)
  end
end

return Script

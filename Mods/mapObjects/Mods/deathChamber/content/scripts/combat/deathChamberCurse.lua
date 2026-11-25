local Base=require("combat/combatScript")
local Script=setmetatable({},{__index=Base})
Script.__index=Script

-- The original WoG triggers the curse only for WALK, DEFEND,
-- WALK_AND_ATTACK and SHOOT. VCMI's onActionFinished also fires after
-- waits, active spells, etc., so mark eligible actions with battle bonuses.
-- The marker is consumed by onActionFinished; this prevents double casts
-- after two strikes or a walk-and-attack combined action.
local MARK="DEATH_CHAMBER_CURSE_ACTION_MARK"

local function nameOf(unit)
  return unit:getCreature():getNameTextID(unit:getCount())
end

local function markAction(server,battle,unit)
  if not unit:isAlive() or unit:hasBonuses({type=MARK}) then return end
  server:addUnitBonus(battle,unit,{
    type=MARK,val=1,duration=ENUM.BonusDuration.oneBattle,
    sourceType=ENUM.BonusSource.creatureAbility,
    sourceID=unit:getCreature():getJsonKey(),hidden=true
  },false)
end

function Script:onAfterMove(server,battle,unit,other,payload)
  markAction(server,battle,unit)
end

function Script:onDefend(server,battle,unit,other,payload)
  markAction(server,battle,unit)
end

function Script:onAfterAttack(server,battle,unit,other,payload)
  if payload and (payload.isCounter or (payload.attackIndex or 0)>0) then return end
  markAction(server,battle,unit)
end

function Script:onActionFinished(server,battle,unit,other,payload)
  -- Only the actor's own action qualifies; no hero spell or collateral hit.
  if not unit:isAlive() or not other or other:unitID()~=unit:unitID() then return end
  if not unit:hasBonuses({type=MARK}) then return end
  server:removeUnitBonuses(battle,unit,unit:getBonuses({type=MARK}))
  local difficulty=math.max(1,math.min(4,self.val or 1))
  local king=nil
  for _,candidate in ipairs(battle:getUnitsIf(function(one)
    return one:isAlive() and one:getSide()~=unit:getSide()
  end)) do
    local key=candidate:getCreature():getJsonKey()
    if string.find(key,"deathChamberKing",1,true) or string.find(key,"deathChamberDracolichKing",1,true) then king=candidate break end
  end
  if not king then return end
  local spells={"misfortune","disruptingRay","weakness","sorrow"}
  local spell=LIBRARY:getSpellByName(spells[difficulty])
  if not spell then return end
  server:castSpell(battle,king,spell,{unit},0)
  server:appendLog(battle,{
    append={"deathChamberWog.log.castOn"},
    replaceStrings={nameOf(king),spell:getNameTextID(),nameOf(unit)}
  })
end
return Script

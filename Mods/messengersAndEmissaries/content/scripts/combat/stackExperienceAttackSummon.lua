local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script
-- WoG p #66-69: chance before an attack action. Fixed spell power 3 x Expert multiplier 4 (WoG 3.59).
function Script:onBeforeAttack(server, battle, unit, other, payload)
    if not other or not other:isAlive() or not unit:isAlive() or not payload then return end
    if payload.isCounter or payload.attackIndex ~= 0 then return end
    if unit:isClone() or unit:isSummoned() then return end
    if battle:getUnitController(unit) ~= unit:getOwner() then return end
    local chance = math.min(100, math.max(0, self.val or 0))
    local count = math.floor(self.fixedCount or 12)
    if chance <= 0 or count < 1 then return end
    local creature = LIBRARY:getCreatureByName(self.creature)
    if not creature then error("Stack Experience Attack Summon: missing creature " .. tostring(self.creature)) end
    local side = unit:getSide()
    local hex = battle:getAvailableHex(creature, side, unit:getPosition())
    if not hex:isValid() or not battle:isAccessibleForNewUnit(hex, creature, side) then return end
    if not server:rollCombatAbility(battle, unit, chance) then return end
    local added = server:addUnit(battle, {count = count, type = creature, side = side, position = hex, summoned = true})
    if not added then return end
    server:appendLog(battle, {
        append = {unit:getCount() == 1 and self.messageSingular or self.messagePlural},
        replaceStrings = {unit:getCreature():getNameTextID(unit:getCount()), creature:getNameTextID(count)},
        replaceNumbers = {count}
    })
    server:refreshBattleUnits(battle)
end
return Script

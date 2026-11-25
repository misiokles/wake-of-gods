local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

-- Roll once per round, including round 1. Let the native turn-start
-- regeneration restore health, so damage later in the round is covered.
function Script:rollRegeneration(server, battle, unit)
    if not unit:isAlive() or unit:isClone() then return end
    local amount = math.max(0, self.val or 0)
    local chance = math.min(100, math.max(0, self.chance or 0))
    if amount == 0 or chance == 0 then return end
    if chance < 100 and server:rngBinomial(1, chance / 100) == 0 then return end
    server:addUnitBonus(battle, unit, {
        type = "HP_REGENERATION",
        val = amount,
        duration = ENUM.BonusDuration.nTurns,
        turns = 1,
        sourceType = ENUM.BonusSource.creatureAbility,
        sourceID = unit:getCreature():getJsonKey(),
        stacking = "stackExperienceRegenerationRound",
        hidden = true
    }, true)
end

function Script:onBattleStart(server, battle, unit, other)
    self:rollRegeneration(server, battle, unit)
end

function Script:onRoundStart(server, battle, unit, other)
    self:rollRegeneration(server, battle, unit)
end

return Script

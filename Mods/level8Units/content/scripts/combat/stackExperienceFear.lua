local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

-- Rank is evaluated on the source; the native FEARFUL bonus is put on enemies.
function Script:refresh(server, battle, unit)
    local key = "stackExperienceFear:" .. tostring(unit:unitID())
    local active = unit:isAlive() and not unit:isClone()
    for _, target in ipairs(battle:getUnitsIf(function(other) return true end)) do
        local matching = target:getBonuses({type = "FEARFUL"}):filter(function(b) return b:getStacking() == key end)
        local eligible = active and target:isAlive() and battle:isHostile(unit, target) and target:hasBonuses({type = "LIVING"})
        if eligible and matching:size() == 0 then
            server:addUnitBonus(battle, target, {
                type = "FEARFUL", val = self.val, valueType = "AT_LEAST",
                duration = ENUM.BonusDuration.oneBattle, sourceType = ENUM.BonusSource.creatureAbility,
                sourceID = unit:getCreature():getJsonKey(), stacking = key
            }, true)
        elseif not eligible and matching:size() > 0 then
            server:removeUnitBonuses(battle, target, matching)
        end
    end
end
function Script:onBattleStart(server, battle, unit, other) self:refresh(server, battle, unit) end
function Script:onRoundStart(server, battle, unit, other) self:refresh(server, battle, unit) end
function Script:onActionFinished(server, battle, unit, other) self:refresh(server, battle, unit) end
function Script:onDeath(server, battle, unit, other) self:refresh(server, battle, unit) end
return Script

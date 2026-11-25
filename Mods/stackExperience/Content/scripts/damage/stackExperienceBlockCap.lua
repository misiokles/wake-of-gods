-- WoG Block: exact 0 physical damage for one deflected strike.
-- This is an append-only patch of core:damageCalculator, NOT a second calculator.
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

local BLOCK_STACKING = "stackExperienceBlockTemporary"

function Script:getDamageCap(info)
    -- Preserve the limit from earlier patches (e.g. damageReceivedCap).
    local regularCap = Base.getDamageCap(self, info)
    if not self:hasBonusOfType(info.defenderBonuses, "DAMAGE_RECEIVED_CAP") then
        return regularCap
    end
    local markers = info.defender:getBonuses({type = "DAMAGE_RECEIVED_CAP"}):filter(function(bonus)
        return bonus:getStacking() == BLOCK_STACKING
    end)
    if markers:size() > 0 then
        return 0
    end
    return regularCap
end

Script:declareBonus("DAMAGE_RECEIVED_CAP")
return Script

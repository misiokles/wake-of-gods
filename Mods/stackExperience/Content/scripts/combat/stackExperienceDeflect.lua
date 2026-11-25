-- Universal WoG Stack Experience Deflect - VCMI 1.8.0
-- Based on wake-of-gods.creatures:combat/dracolichPhysicalDodge.lua
-- The ability is attached using COMBAT_EVENT_TRIGGER and triggered per physical hit.
-- val is taken from stackExperience.values at the current rank.
-- mode="chance": val = trigger chance, fixed = damage reduction.
-- mode="reduction": val = damage reduction, fixed = trigger chance.
-- Damage caused by spells is not covered by GENERAL_DAMAGE_REDUCTION.
-- Native VCMI 1.8.0 source review: UNTIL_ATTACK expires on attacker, not defender.
-- UNTIL_BEING_ATTACKED expires on defender when damage is applied.
-- An onAfterAttacked fallback removes it even if damage is zero.

local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

local TEMPORARY_STACKING = "stackExperienceDeflectTemporary"
local BLOCK_STACKING = "stackExperienceBlockTemporary"

local function clamp(value)
    local number = tonumber(value) or 0
    return math.max(0, math.min(100, number))
end

function Script:onBeforeAttacked(server, battle, unit, other, payload)
    -- The defender must be taking a direct attack from an enemy unit.
    -- This also covers ranged attacks, retaliations and secondary targets.
    if not other or not unit or not unit:isAlive() then
        return
    end

    local value = clamp(self.val)
    local fixed = clamp(self.fixed)
    local chance, reduction

    if self.mode == "chance" then
        chance = value
        reduction = fixed
    elseif self.mode == "reduction" then
        chance = fixed
        reduction = value
    else
        return
    end

    if chance <= 0 or reduction <= 0 then
        return
    end
    if chance < 100 and server:rngInt(1, 100) > chance then
        return
    end

    -- Bonus belongs to defender, so UNTIL_BEING_ATTACKED is the correct
    -- built-in expiration when this attack actually inflicts damage.
    server:addUnitBonus(battle, unit, {
        type = "GENERAL_DAMAGE_REDUCTION",
        subtype = "damageTypeAll",
        val = reduction,
        duration = "UNTIL_BEING_ATTACKED",
        stacking = TEMPORARY_STACKING,
        hidden = true
    }, false)

    -- True WoG Block must deal exactly ZERO damage. The standard damage
    -- calculator has a hard minimum of 1, even when reduction is 100%.
    -- A narrowly scoped patch to core:damageCalculator checks this marker
    -- and temporarily sets its damage cap to 0 for this *one* hit only.
    if self.blockFully == true then
        server:addUnitBonus(battle, unit, {
            type = "DAMAGE_RECEIVED_CAP",
            val = 1,
            duration = "UNTIL_BEING_ATTACKED",
            stacking = BLOCK_STACKING,
            hidden = true
        }, false)
    end

    local count = unit:getCount()
    if count <= 0 then
        return
    end
    local message = count == 1 and self.messageSingular or self.messagePlural
    if message then
        server:appendLog(battle, {
            append = { message },
            replaceStrings = { unit:getCreature():getNameTextID(count) }
        })
    end
end

-- Fallback for zero-damage attacks: damage-dependent expiry above may not run.
-- This is also a safe extra guard against leaking Deflect into the next hit.
function Script:onAfterAttacked(server, battle, unit, other, payload)
    if not unit then return end
    local temporary = unit:getBonuses({
        type = "GENERAL_DAMAGE_REDUCTION",
        subtype = "damageTypeAll"
    }):filter(function(bonus)
        return bonus:getStacking() == TEMPORARY_STACKING
    end)
    if temporary:size() > 0 then
        server:removeUnitBonuses(battle, unit, temporary)
    end
    local blockMarker = unit:getBonuses({type = "DAMAGE_RECEIVED_CAP"}):filter(function(bonus)
        return bonus:getStacking() == BLOCK_STACKING
    end)
    if blockMarker:size() > 0 then
        server:removeUnitBonuses(battle, unit, blockMarker)
    end
end

return Script

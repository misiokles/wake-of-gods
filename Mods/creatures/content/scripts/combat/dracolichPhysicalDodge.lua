-- Dracolich physical dodge for VCMI 1.8
-- Attach this script through a COMBAT_EVENT_TRIGGER bonus.
--
-- The bonus value (self.val) is the dodge chance in percent.
-- Example: val = 20 gives a 20% chance to completely avoid each
-- incoming melee or ranged creature attack.
--
-- The temporary 100% damage-reduction bonus expires after the attack sequence,
-- so it does not protect the unit from later attacks. GENERAL_DAMAGE_REDUCTION does not protect from spells.

local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

function Script:onBeforeAttacked(server, battle, unit, other, payload)
    -- No attacker means there is no ordinary creature attack to dodge. This should never occur, probably unnecessary guard.
    if not other then
        return
    end

    -- Ignore invalid chances - should be validated by the schema instead, but probably fine to clamp anyway.
    local chance = self.val or 20
    if chance <= 0 then
        return
    end
    if chance > 100 then
        chance = 100
    end

    -- Use rngInt(low, high) because this is not a per-unit roll, but once per stack.
    if chance < 100 and server:rngInt(1,100) > chance then
        return
    end

    
    function Script:emitBattleLog(server, battle, unit)
    local count = unit:getCount()
    if count <= 0 then return end

    local textID = count == 1 and self.messageSingular or self.messagePlural
    server:appendLog(battle, {
        append         = { textID },
        replaceStrings = { unit:getCreature():getNameTextID(count) }
    })
    end

    -- Reduce the current attack to 1 damage.
    -- UNTIL_AFTER_ATTACK_SEQUENCE removes this temporary protection after this attack.
    server:addUnitBonus(battle, unit, {
        type = "GENERAL_DAMAGE_REDUCTION",
        subtype = "damageTypeAll",
        val = 100,
        duration = "UNTIL_AFTER_ATTACK_SEQUENCE",
        stacking = "dracolichPhysicalDodge",
        hidden = true
    }, false)
end

return Script
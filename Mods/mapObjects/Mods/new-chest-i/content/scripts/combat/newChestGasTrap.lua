local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

function Script:onBattleStart(server, battle, unit, other)
    if not unit:isAlive() or unit:hasBonuses({ type = "SIEGE_WEAPON" }) then return end
    local spell = LIBRARY:getSpellByName(self.spell)
    if not spell then error("Unknown chest gas spell: " .. tostring(self.spell)) end
    server:applySpellEffects(battle, unit, spell, { unit }, 1, 255, true)
end

return Script

local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script
function Script:onAfterAttack(server, battle, unit, other, payload)
    if not other or not other:isAlive() or not unit:isAlive() then return end
    local chance = math.min(100, math.max(0, self.val or 0))
    if chance <= 0 or server:rngInt(1, 100) > chance then return end
    local spell = LIBRARY:getSpellByName("core:age")
    server:applySpellEffects(battle, unit, spell, {other}, 0, 3, false)
end
return Script

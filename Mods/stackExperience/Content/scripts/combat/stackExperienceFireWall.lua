local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

-- WoG 3.59: Basic, fixed power 3, two hexes.
function Script:onAfterAttack(server, battle, unit, other, payload)
    if not other or not unit:isAlive() or not other:isAlive() or not payload or payload.ranged then return end
    local chance = math.min(100, math.max(0, self.val or 0))
    if chance == 0 or server:rngInt(1, 100) > chance then return end
    local spell = LIBRARY:getSpellByName("core:fireWall")
    local center = other:getPosition()
    local upper = unit:getSide() == ENUM.BattleSide.attacker and center:copyToNorthEast() or center:copyToNorthWest()
    local placed = false
    for _, hex in ipairs({center, upper}) do
        -- Avoid overlapping hazards on a hex already containing an obstacle.
        if hex:isValid() and #battle:getObstaclesOnPos(hex, false) == 0 then
            server:addObstacle(battle, {
                pos = hex, obstacleType = ENUM.ObstacleType.spellCreated,
                spell = spell, turnsRemaining = 2,
                casterSpellPower = 3, spellLevel = 1,
                casterSide = unit:getSide(), minimalDamage = 0,
                hidden = false, passable = true, trap = false,
                removeOnTrigger = false, nativeVisible = true,
                trigger = "core:fireWallTrigger", appearSound = "FIREWALL",
                appearAnimation = "C07SPF60", animation = "C07SPF61",
                removalAnimation = "C07SPF62", customSize = {hex}
            })
            placed = true
        end
    end
    if placed then
        server:appendLog(battle, {
            append = {unit:getCount() == 1 and self.messageSingular or self.messagePlural},
            replaceStrings = {unit:getCreature():getNameTextID(unit:getCount())}
        })
    end
end
return Script

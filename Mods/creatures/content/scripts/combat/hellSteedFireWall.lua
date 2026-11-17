
local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

local FIRE_WALL_SPELL = "core:fireWall"
local FIRE_WALL_TRIGGER = "core:fireWallTrigger"

function Script:getFirewallHexes(target)
    local hexes = target:getHexes()
    local result = {}

    for i = 1, hexes:size() do
        result[i] = hexes:at(i)
    end

    return result
end

function Script:makeFirewall(server, battle, hex, spell, side, power)
    local descriptor = {
        pos              = hex,
        obstacleType     = ENUM.ObstacleType.spellCreated,
        spell            = spell,
        casterSpellPower = power,
        spellLevel       = 0,
        casterSide       = side,
        turnsRemaining   = 2,
        hidden           = false,
        passable         = true,
        nativeVisible    = true,
        trap             = false,
        removeOnTrigger  = false,
        trigger          = FIRE_WALL_TRIGGER,
        appearSound      = "FIREWALL",
        appearAnimation  = "C07SPF60",
        animation        = "C07SPF61",
        removalAnimation = "C07SPF62",
        customSize       = { hex },
    }

    server:addObstacle(battle, descriptor)
end

function Script:onAfterAttack(server, battle, unit, other, payload)
    if not unit or not other then
        return
    end

    -- Only melee attacks can trigger Fire Wall.
    if payload and payload.ranged then
        return
    end

    -- 12% activation chance.
    local chance = self.val or 12

    if chance <= 0 or chance > 100 then
        return
    end

    if not server:rollCombatAbility(battle, unit, chance) then
        return
    end

    local spell = LIBRARY:getSpellByName(FIRE_WALL_SPELL)

    if not spell then
        return
    end

    local power = unit:getCount()

    if power <= 0 then
        return
    end

    local side = unit:getSide()
    local hexes = self:getFirewallHexes(other)

    for _, hex in ipairs(hexes) do
        self:makeFirewall(server, battle, hex, spell, side, power)
    end

    -- Battle log message.
    local message = self.messagePlural or "%s cast Fire Wall!"

    if power == 1 then
        message = self.messageSingular or "%s casts Fire Wall!"
    end

    server:appendLog(battle, {
        append = { message },
        replaceStrings = {
            unit:getCreature():getNameTextID(power)
        }
    })
end

return Script

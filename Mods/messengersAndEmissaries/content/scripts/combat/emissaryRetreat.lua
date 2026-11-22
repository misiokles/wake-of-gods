
local Base = require("combat/combatScript")
local Script = setmetatable({}, { __index = Base })
Script.__index = Script

-- Emissary retreat:
-- 1) Emissaries do not retreat when attacked.
-- 2) After their own attack, they deal symbolic damage and teleport 2-4 hexes away.
-- 3) Counterattacks do not trigger teleportation.

local function hexDistance(a, b)
    -- Convert odd-row coordinates to axial coordinates.
    local aq = a:getX() - math.floor(a:getY() / 2)
    local ar = a:getY()

    local bq = b:getX() - math.floor(b:getY() / 2)
    local br = b:getY()

    local dq = aq - bq
    local dr = ar - br

    return math.max(
        math.abs(dq),
        math.abs(dr),
        math.abs(dq + dr)
    )
end

local function findDestination(server, battle, unit)
    local creature = unit:getCreature()
    local side = unit:getSide()
    local currentHex = unit:getPosition()

    local candidates = {}
    local allHexes = battle:getAllPossibleHexes()

    for i = 1, allHexes:size() do
        local hex = allHexes:at(i)
        local distance = hexDistance(currentHex, hex)

        if distance >= 2
            and distance <= 4
            and hex:isValid()
            and hex:isAvailable()
            and battle:isAccessibleForNewUnit(hex, creature, side) then

            candidates[#candidates + 1] = hex
        end
    end

    if #candidates == 0 then
        return nil
    end

    return candidates[server:rngInt(1, #candidates)]
end

local function appendRetreatLog(server, battle, unit)
    local count = unit:getCount()

    local messageKey = count == 1
        and "wake-of-gods.creatures.battleLog.emissary.retreat.singular"
        or "wake-of-gods.creatures.battleLog.emissary.retreat.plural"

    server:appendLog(battle, {
        append = { messageKey },
        replaceStrings = {
            unit:getCreature():getNameTextID(count)
        }
    })
end

local function teleportAway(server, battle, unit)
    if not unit or not unit:isAlive() then
        return
    end

    local destination = findDestination(server, battle, unit)

    if destination then
        server:moveUnit(battle, unit, destination, true)
        appendRetreatLog(server, battle, unit)
    end
end

function Script:onAfterAttack(server, battle, unit, other, payload)
    if not unit or not unit:isAlive() then
        return
    end

    -- Do not retreat after a counterattack.
    if payload and payload.isCounter then
        return
    end

    -- Retreat after the Emissary's own attack.
    teleportAway(server, battle, unit)
end

return Script

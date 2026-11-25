local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

-- WoG Stack Experience: u (once in round 2) and U (rounds 2,6,10,14...).
-- interval=0: only the first round-start callback (beginning of round 2).
-- interval=4: first callback, then every fourth callback.
-- No new C++ engine functionality; progress is stored in oneBattle NONE bonus.
-- The bonus value (self.val) is a percentage of the living summoner count,
-- not a proc chance. Rounding is down; zero summoned creatures => no stack.
-- The onBattleStart marker makes later onRoundStart events safe: one battle only.

local MARKER_STACKING = "stackExperienceSummonRoundState"
local MARKER_SOURCE = ENUM.BonusSource.creatureAbility
local DURATION = ENUM.BonusDuration.oneBattle

-- A hidden NONE bonus is a no-effect per-stack state flag, not a game bonus.
local function markerValue(unit, creatureKey)
    local bonuses = unit:getBonuses({ type = "NONE", sourceType = MARKER_SOURCE })
    for i = 1, bonuses:size() do
        local bonus = bonuses:getBonus(i)
        if bonus:getStacking() == (MARKER_STACKING .. ":" .. creatureKey) and
           bonus:getSourceID() == unit:getCreature():getJsonKey() then
            return bonus:getVal()
        end
    end
    return 0
end

local function mark(server, battle, unit, value, creatureKey)
    server:addUnitBonus(battle, unit, {
        type = "NONE",
        val = value,
        duration = DURATION,
        sourceType = MARKER_SOURCE,
        sourceID = unit:getCreature():getJsonKey(),
        stacking = MARKER_STACKING .. ":" .. creatureKey,
        hidden = true
    }, false)
end

function Script:onBattleStart(server, battle, unit, other)
    -- 1 = ready for round 2. A summoned/clone unit introduced later cannot
    -- acquire this flag through onBattleSetup.
    if not unit:isAlive() or unit:isClone() or unit:isSummoned() then return end
    if (self.val or 0) <= 0 then return end
    mark(server, battle, unit, 1, self.creature)
end

function Script:onRoundStart(server, battle, unit, other)
    -- The VCMI 1.8 event starts with round 2 (round 1 uses onBattleStart).
    -- State 1 corresponds to round 2, state 5 to round 6, state 9 to round 10.
    -- Count all rounds even if no adjacent hex is free: blocked rounds are lost.
    local phase = markerValue(unit, self.creature)
    if phase < 1 then return end
    local interval = math.floor(self.interval or 0)
    if interval <= 0 and phase > 1 then return end
    if interval > 0 and (phase - 1) % interval ~= 0 then
        mark(server, battle, unit, phase + 1, self.creature)
        return
    end
    mark(server, battle, unit, phase + 1, self.creature)
    if not unit:isAlive() or unit:isClone() or unit:isSummoned() then return end

    local percent = math.max(0, self.val or 0)
    local count = math.floor(unit:getCount() * percent / 100)
    if count < 1 then return end

    local creature = LIBRARY:getCreatureByName(self.creature)
    if not creature then error("Stack Experience Summon: missing creature " .. tostring(self.creature)) end

    local adjacent = unit:getSurroundingHexes()
    local side = unit:getSide()
    for i = 1, adjacent:size() do
        local hex = adjacent:at(i)
        if battle:isAccessibleForNewUnit(hex, creature, side) then
            server:addUnit(battle, {
                count = count,
                type = creature,
                side = side,
                position = hex,
                summoned = true
            })
            if self.messageSingular and self.messagePlural then
                server:appendLog(battle, {
                    append = { unit:getCount() == 1 and self.messageSingular or self.messagePlural },
                    replaceStrings = { unit:getCreature():getNameTextID(unit:getCount()),
                                       creature:getNameTextID(count) },
                    replaceNumbers = { count }
                })
            end
            server:refreshBattleUnits(battle)
            return
        end
    end
end

return Script

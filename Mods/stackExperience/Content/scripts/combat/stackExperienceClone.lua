local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

-- WoG Stack Experience: 'l' (Summon Clone).
-- Enchanters summon a new independent illusory stack EACH round, starting
-- with round 2, provided an adjacent accessible hex is available.
-- R1-R5: clones of Arch Mage (5%-25%); R6-R10: clones of Enchanter (15%-35%).
-- Values are percentages of the current LIVING Enchanter stack count.
-- Summoned illusion stacks are NOT linked to the summoning Enchanter.
-- A Clone spell NONE marker makes cloned units survive normal round rollover.
-- This deliberately reuses the state model from VCMI scripts/spells/clone.lua
-- WITHOUT originalState:setClone(cloneUnit), to preserve the WoG special rule.

local MARKER = "stackExperienceCloneEligible"
local CREATURE_SOURCE = ENUM.BonusSource.creatureAbility
local DURATION = ENUM.BonusDuration.oneBattle

local function markerExists(unit)
    local bonuses = unit:getBonuses({ type = "NONE", sourceType = CREATURE_SOURCE })
    for i = 1, bonuses:size() do
        local bonus = bonuses:getBonus(i)
        if bonus:getStacking() == MARKER and
           bonus:getSourceID() == unit:getCreature():getJsonKey() then
            return true
        end
    end
    return false
end

function Script:onBattleStart(server, battle, unit, other)
    if (self.val or 0) <= 0 then return end
    if not unit:isAlive() or unit:isClone() or unit:isSummoned() then return end
    server:addUnitBonus(battle, unit, {
        type = "NONE",
        val = 1,
        duration = DURATION,
        sourceType = CREATURE_SOURCE,
        sourceID = unit:getCreature():getJsonKey(),
        stacking = MARKER,
        hidden = true
    }, false)
end

function Script:onRoundStart(server, battle, unit, other)
    -- VCMI 1.8: first ROUND_START is beginning of round 2.
    if not markerExists(unit) then return end
    if not unit:isAlive() or unit:isClone() or unit:isSummoned() then return end
    local percent = math.max(0, self.val or 0)
    local count = math.floor(unit:getCount() * percent / 100)
    if count < 1 then return end

    local creature = LIBRARY:getCreatureByName(self.creature)
    if creature == nil then
        error("Stack Experience Clone: unknown creature " .. tostring(self.creature))
    end
    local cloneSpell = LIBRARY:getSpellByName("clone")
    if cloneSpell == nil then
        error("Stack Experience Clone: missing core Clone spell")
    end

    local adjacent = unit:getSurroundingHexes()
    local side = unit:getSide()
    for i = 1, adjacent:size() do
        local hex = adjacent:at(i)
        if battle:isAccessibleForNewUnit(hex, creature, side) then
            local newUnit = server:addUnit(battle, {
                count = count,
                type = creature,
                side = side,
                position = hex,
                summoned = true
            })
            if newUnit == nil then return end

            -- Preserve Clone's 1-hit illusion rule, WITHOUT setting an origin
            -- link. Ordinary Clone spell would set originalState:setClone(),
            -- which makes the clone vanish when its original dies.
            local copy = newUnit:copy()
            copy:setCloned(true)
            server:changeUnit(battle, copy)

            -- CUnitState::afterNewRound requires a spellEffect NONE marker
            -- from the core Clone spell; otherwise it removes every clone.
            -- oneBattle persists until the clone is defeated/end of combat.
            server:addUnitBonus(battle, newUnit, {
                type = "NONE",
                val = 0,
                duration = DURATION,
                sourceType = ENUM.BonusSource.spellEffect,
                sourceID = cloneSpell:getJsonKey(),
                stacking = "stackExperienceIndependentClone",
                hidden = true
            }, true)

            if self.messageSingular and self.messagePlural then
                server:appendLog(battle, {
                    append = {unit:getCount() == 1 and self.messageSingular or self.messagePlural},
                    replaceStrings = {
                        unit:getCreature():getNameTextID(unit:getCount()),
                        creature:getNameTextID(count)
                    },
                    replaceNumbers = {count}
                })
            end
            server:refreshBattleUnits(battle)
            return
        end
    end
    -- No free adjacent hex: no clone this round, try again next round.
end

return Script

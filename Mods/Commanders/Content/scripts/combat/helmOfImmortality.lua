local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

local MARKER_TYPE = "REBIRTH_SPENT"
local ARTIFACT_SOURCE = "wake-of-gods.commanders:helmOfImmortality"
local ANIMATION = "C01SPE0"
local SOUND = "RESURECT"

local function hasLivingArmyUnit(battle, commander)
    local allies = battle:getUnitsIf(function(unit)
        return unit:unitID() ~= commander:unitID()
            and unit:isAlive()
            and not unit:isCommander()
            and not unit:isSummoned()
            and not unit:isClone()
            and not unit:isTurret()
            and not battle:isHostile(commander, unit)
    end)

    return #allies > 0
end

local function nextRevivalHealth(unit)
    local markers = unit:getBonuses({type = MARKER_TYPE})

    for index = 1, markers:size() do
        local marker = markers:getBonus(index)
        if marker:getSourceID() == ARTIFACT_SOURCE then
            return marker:getVal()
        end
    end

    return nil
end

function Script:onDeath(server, battle, unit)
    if not unit:isCommander() or unit:isAlive() then return end
    if not hasLivingArmyUnit(battle, unit) then return end

    local previousAmount = nextRevivalHealth(unit)
    local amount = previousAmount or math.floor(unit:getMaxHealth() / 2)
    if amount <= 0 then return end

    server:showBattleAnimation(battle, {{unit = unit}}, ANIMATION, SOUND, 0.5, true)
    local healed = server:healUnit(battle, unit, amount, ENUM.HealLevel.resurrect, ENUM.HealPower.permanent)
    if healed <= 0 then return end

    server:addUnitBonus(battle, unit, {
        type = MARKER_TYPE,
        val = math.floor(amount / 2),
        hidden = true,
        duration = ENUM.BonusDuration.oneBattle,
        sourceType = ENUM.BonusSource.artifact,
        sourceID = ARTIFACT_SOURCE
    }, false)
end

return Script

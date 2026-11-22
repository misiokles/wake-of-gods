local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

local TRANSFORMATION_ANIMATION = "C12SPF0"
local TRANSFORMATION_SOUND = "FRENZY"

local function isFullMoon()
    local day = GAME:getCalendar():getDayOfMonth()
    return day >= 14 and day <= 16
end

function Script:isImmune(unit)
    return unit:isCommander() or unit:hasBonuses({type = "TRANSMUTATION_IMMUNITY"})
end

function Script:resultingCount(victim, creature)
    if self.transmuteBy == "health" then
        return math.max(math.floor(victim:getCount() * victim:getMaxHealth() / creature:getMaxHealth()), 1)
    end

    if self.transmuteBy == "count" then
        return victim:getCount()
    end

    return nil
end

function Script:applyFullMoonBerserk(server, battle, unit)
    if not isFullMoon() or not unit:isAlive() then return end

    local spell = LIBRARY:getSpellByName("core:berserk")
    if not spell then
        error("Werewolf Lycanthropy requires the core berserk spell")
    end

    server:castSpell(battle, unit, spell, {unit}, 0)
end

function Script:onBattleStart(server, battle, unit)
    self:applyFullMoonBerserk(server, battle, unit)
end

function Script:onRoundStart(server, battle, unit)
    self:applyFullMoonBerserk(server, battle, unit)
end

function Script:onActionFinished(server, battle, unit, other)
    if not other or other:unitID() ~= unit:unitID() then return end
    self:applyFullMoonBerserk(server, battle, unit)
end

function Script:onAfterAttack(server, battle, unit, other, payload)
    if not unit:isAlive() then return end
    if not other or not other:isAlive() or not other:isLiving() then return end
    if self:isImmune(other) then return end

    local chance = self.val or 0
    if isFullMoon() then
        chance = chance * 2
    end
    if not server:rollCombatAbility(battle, unit, chance) then return end

    local creature = self.creature and LIBRARY:getCreatureByName(self.creature) or unit:getCreature()
    if other:getCreature():getJsonKey() == creature:getJsonKey() then return end

    local count = self:resultingCount(other, creature)
    if count == nil then return end

    local victimCount = other:getCount()
    local victimName = other:getCreature():getNameTextID(victimCount)
    local newName = creature:getNameTextID(count)
    local position = other:getPosition()
    local side = other:getSide()

    server:showBattleAnimation(battle, {{unit = other}}, TRANSFORMATION_ANIMATION, TRANSFORMATION_SOUND, 1.0, true)
    server:appendLog(battle, {
        append = {"wake-of-gods.creatures.battleLog.lycanthropy.transformation"},
        replaceNumbers = {victimCount, count},
        replaceStrings = {victimName, newName}
    })

    server:removeUnit(battle, other)
    server:addUnit(battle, {
        count = count,
        type = creature,
        side = side,
        position = position,
        summoned = false
    })
    server:refreshBattleUnits(battle)
end

return Script



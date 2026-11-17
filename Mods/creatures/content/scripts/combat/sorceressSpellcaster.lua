local Base = require("combat/combatScript")
local Script = setmetatable({}, {__index = Base})
Script.__index = Script

local SPELL_GROUPS = {
    few = {
        {"misfortune", 25}, {"disruptingRay", 25}, {"disease", 25}, {"weakness", 25}
    },
    pack = {
        {"slow", 20}, {"curse", 20}, {"dispelHelpful", 20},
        {"misfortune", 10}, {"disruptingRay", 10}, {"disease", 10}, {"weakness", 10}
    },
    lots = {
        {"poison", 15}, {"sorrow", 15}, {"acidBreath", 15}, {"forgetfulness", 15},
        {"slow", 8}, {"curse", 8}, {"dispelHelpful", 8},
        {"misfortune", 4}, {"disruptingRay", 4}, {"disease", 4}, {"weakness", 4}
    },
    horde = {
        {"poison", 11}, {"sorrow", 11}, {"acidBreath", 11}, {"forgetfulness", 11},
        {"slow", 8}, {"curse", 8}, {"dispelHelpful", 8},
        {"hypnotize", 4}, {"blind", 4}, {"berserk", 4}, {"age", 4},
        {"misfortune", 4}, {"disruptingRay", 4}, {"disease", 4}, {"weakness", 4}
    }
}

local function spellGroup(count)
    if count <= 9 then return SPELL_GROUPS.few end
    if count <= 19 then return SPELL_GROUPS.pack end
    if count <= 49 then return SPELL_GROUPS.lots end
    return SPELL_GROUPS.horde
end

local function chooseSpell(server, group)
    local roll = server:rngInt(1, 100)
    for _, entry in ipairs(group) do
        roll = roll - entry[2]
        if roll <= 0 then
            return entry[1]
        end
    end
    error("Sorceress spell weights must add up to 100")
end

function Script:onAfterAttack(server, battle, unit, other, payload)
    if not unit:isAlive() or not other or not other:isAlive() then return end
    if not payload.ranged or payload.isCounter then return end

    local count = unit:getCount()
    local chance = math.min(100, 20 + 2 * count)
    if not server:rollCombatAbility(battle, unit, chance) then return end

    local spell = LIBRARY:getSpellByName("core:" .. chooseSpell(server, spellGroup(count)))
    if not spell then
        error("Sorceress spell is missing from the game library")
    end

    server:appendLog(battle, {
        append = {"wake-of-gods.creatures.battleLog.sorceress.spellCast"},
        replaceStrings = {
            spell:getNameTextID(),
            other:getCreature():getNameTextID(other:getCount())
        }
    })
    server:castSpell(battle, unit, spell, {other}, 0)
end

return Script


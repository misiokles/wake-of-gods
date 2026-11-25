-- Extend core:dispel without changing the engine or unrelated creatures.
local Script = setmetatable({}, {__index = Base})
Script.__index = Script
function Script:getDispelableBonuses(mechanics, unit)
    local bonuses = Base.getDispelableBonuses(self, mechanics, unit)
    local level = 0
    local markers = unit:getBonuses({type = "NONE"})
    for i = 1, markers:size() do
        local marker = markers:getBonus(i)
        if marker:getStacking() == "stackExperienceDispelProtection" then
            level = math.max(level, marker:getVal())
        end
    end
    if level == 0 then return bonuses end
    local positiveOnly = self.dispelPositive and not self.dispelNegative and not self.dispelNeutral
    local regular = mechanics:getSpell():getJsonKey() == "core:dispel"
    if positiveOnly or (regular and (level == 2 or (level >= 3 and mechanics:getBattle():getUnitController(unit) ~= mechanics:getCasterColor()))) then
        return bonuses:filter(function() return false end)
    end
    return bonuses
end

-- Core tiers from SPTRAITS.TXT and config/spells indices; modded tiers need explicit extension.
local spellTier = {
    ["core:fireWallTrigger"] = 2,
    ["core:landMineTrigger"] = 3,
    ["core:airElemental"] = 5,
    ["core:airShield"] = 3,
    ["core:animateDead"] = 3,
    ["core:antiMagic"] = 3,
    ["core:armageddon"] = 4,
    ["core:berserk"] = 4,
    ["core:bless"] = 1,
    ["core:blind"] = 2,
    ["core:bloodlust"] = 1,
    ["core:chainLightning"] = 4,
    ["core:clone"] = 4,
    ["core:counterstrike"] = 4,
    ["core:cure"] = 1,
    ["core:curse"] = 1,
    ["core:deathRipple"] = 2,
    ["core:destroyUndead"] = 3,
    ["core:dimensionDoor"] = 5,
    ["core:disguise"] = 2,
    ["core:dispel"] = 1,
    ["core:disruptingRay"] = 2,
    ["core:earthElemental"] = 5,
    ["core:earthquake"] = 3,
    ["core:fireElemental"] = 5,
    ["core:fireShield"] = 4,
    ["core:fireWall"] = 2,
    ["core:fireball"] = 3,
    ["core:fly"] = 5,
    ["core:forceField"] = 3,
    ["core:forgetfulness"] = 3,
    ["core:fortune"] = 2,
    ["core:frenzy"] = 4,
    ["core:frostRing"] = 3,
    ["core:haste"] = 1,
    ["core:hypnotize"] = 3,
    ["core:iceBolt"] = 2,
    ["core:implosion"] = 5,
    ["core:inferno"] = 4,
    ["core:landMine"] = 3,
    ["core:lightningBolt"] = 2,
    ["core:magicArrow"] = 1,
    ["core:magicMirror"] = 5,
    ["core:meteorShower"] = 4,
    ["core:mirth"] = 3,
    ["core:misfortune"] = 3,
    ["core:prayer"] = 4,
    ["core:precision"] = 2,
    ["core:protectAir"] = 2,
    ["core:protectEarth"] = 3,
    ["core:protectFire"] = 1,
    ["core:protectWater"] = 1,
    ["core:quicksand"] = 2,
    ["core:removeObstacle"] = 2,
    ["core:resurrection"] = 4,
    ["core:sacrifice"] = 5,
    ["core:scuttleBoat"] = 2,
    ["core:shield"] = 1,
    ["core:slayer"] = 4,
    ["core:slow"] = 1,
    ["core:sorrow"] = 4,
    ["core:stoneSkin"] = 1,
    ["core:summonBoat"] = 1,
    ["core:teleport"] = 3,
    ["core:titanBolt"] = 5,
    ["core:townPortal"] = 4,
    ["core:viewAir"] = 1,
    ["core:viewEarth"] = 1,
    ["core:visions"] = 2,
    ["core:waterElemental"] = 5,
    ["core:waterWalk"] = 4,
    ["core:weakness"] = 2,
}

local mindSpells = { ["core:blind"] = true, ["core:berserk"] = true, ["core:sorrow"] = true, ["core:hypnotize"] = true, ["core:forgetfulness"] = true }

function Script:isReceptive(mechanics, unit)
    local spell = mechanics:getSpell()
    local hostile = not mechanics:isPositive()
    if spell:getJsonKey() == "core:dispel" then
        hostile = mechanics:getBattle():getUnitController(unit) ~= mechanics:getCasterColor()
    end
    -- WoG SCastSpell skips stack-experience resistance with Orb of Vulnerability.
    -- Direct damage separately reapplies DwarfResist in MagicDwarfResistance3.
    if spell:isMagical() and not spell:isDamage() and spell:getJsonKey() ~= "core:dispel"
        and unit:hasBonuses({type = "NEGATE_ALL_NATURAL_IMMUNITIES"}) then
        return Base.isReceptive(self, mechanics, unit)
    end
    local markers = unit:getBonuses({type = "NONE"})
    local active = {}
    local tierLimit = 0
    for i = 1, markers:size() do
        local marker = markers:getBonus(i)
        if marker:getVal() > 0 then
            active[marker:getStacking()] = true
            if marker:getStacking() == "stackExperienceHostileSpellTier" then tierLimit = math.max(tierLimit, marker:getVal()) end
        end
    end
    if active.stackExperienceHostileLevelOneImmunity then tierLimit = math.max(tierLimit, 1) end
    local tier = spellTier[spell:getJsonKey()]
    if hostile and tier and tier <= tierLimit and (not self.ignoreImmunity or spell:getJsonKey() == "core:dispel") then
        return false
    end
    -- Enchanted effects explicitly bypass ordinary immunity; preserve that policy.
    if not self.ignoreImmunity or spell:getJsonKey() == "core:dispel" then
        if hostile and active.stackExperienceHostileMind and mindSpells[spell:getJsonKey()] then return false end
        for _, school in ipairs(spell:getSchools()) do
            local key = school:getJsonKey()
            if key == "air" or key == "fire" or key == "water" or key == "earth" then key = "core:" .. key end
            if active["stackExperienceSchoolAll:" .. key] or
               (hostile and active["stackExperienceSchoolHostile:" .. key]) then
                return false
            end
        end
    end
    return Base.isReceptive(self, mechanics, unit)
end
return Script

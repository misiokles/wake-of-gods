local Script = setmetatable({}, {__index = Base})
Script.__index = Script

-- WoG w D: immunity to reflected Fire Shield damage, not to casting Fire Shield.
function Script:isImmune(attacker)
    local markers = attacker:getBonuses({type = "NONE"})
    for i = 1, markers:size() do
        local marker = markers:getBonus(i)
        local key = marker:getStacking()
        if (key == "stackExperienceFireShieldImmunity" or key == "stackExperienceSchoolHostile:core:fire" or key == "stackExperienceSchoolAll:core:fire") and marker:getVal() > 0 then
            return true
        end
        if key == "stackExperienceHostileSpellTier" and marker:getVal() >= 4 then
            return true
        end
    end
    return Base.isImmune(self, attacker)
end
return Script

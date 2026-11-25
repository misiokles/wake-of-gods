-- Extend the existing guardian summon, never spawn a second group.
local Script = setmetatable({}, {__index = Base})
Script.__index = Script
local upgrades = {
    ["core:pikeman"] = "core:halberdier",
    ["core:centaur"] = "core:centaurCaptain",
    ["core:dwarf"] = "core:battleDwarf",
    ["core:gremlin"] = "core:masterGremlin",
    ["core:imp"] = "core:familiar",
    ["core:skeleton"] = "core:skeletonWarrior",
    ["core:troglodyte"] = "core:infernalTroglodyte",
    ["core:goblin"] = "core:hobgoblin",
    ["core:gnoll"] = "core:gnollMarauder",
    ["core:pixie"] = "core:sprite"
}
function Script:onBattleStart(server, battle, unit, other)
    local percent, upgrade = 0, 0
    local markers = unit:getBonuses({type = "NONE"})
    for i = 1, markers:size() do
        local marker = markers:getBonus(i)
        if marker:getStacking() == "stackExperienceGuardBonus" then
            percent = math.max(percent, marker:getVal())
        elseif marker:getStacking() == "stackExperienceGuardUpgrade" then
            upgrade = math.max(upgrade, marker:getVal())
        end
    end
    if percent == 0 and upgrade == 0 then
        return Base.onBattleStart(self, server, battle, unit, other)
    end
    local guardian = LIBRARY:getCreatureByName(self.creature)
    if guardian == nil then
        return Base.onBattleStart(self, server, battle, unit, other)
    end
    local name = self.creature
    if upgrade > 0 then
        name = upgrades[guardian:getJsonKey()] or name
    end
    local adjusted = setmetatable({creature = name,
        val = (self.val or 0) * (100 + percent) / 100}, {__index = self})
    return Base.onBattleStart(adjusted, server, battle, unit, other)
end
return Script

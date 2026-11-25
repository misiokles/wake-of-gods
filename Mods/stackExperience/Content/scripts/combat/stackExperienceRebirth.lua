-- Patch the core rebirth handler, with a per-stack, per-battle counter.
local Script = setmetatable({}, {__index = Base})
Script.__index = Script
local SPENT = "REBIRTH_SPENT"
local LIMIT = "stackExperienceRebirthLimit"

function Script:onDeath(server, battle, unit, other, payload)
    local limit = 0
    local markers = unit:getBonuses({type = "NONE"})
    for i = 1, markers:size() do
        local marker = markers:getBonus(i)
        if marker:getStacking() == LIMIT or marker:getStacking() == "stackExperienceRebirthBaseLimit" then
            limit = math.max(limit, marker:getVal())
        end
    end
    if limit <= 0 then
        return Base.onDeath(self, server, battle, unit, other, payload)
    end
    if unit:isClone() then return end
    local spent = unit:getBonuses({type = SPENT})
    local used = 0
    for i = 1, spent:size() do
        used = math.max(used, spent:getBonus(i):getVal())
    end
    if used >= limit then return end
    local percentage = self.val or 0
    if percentage <= 0 then return end
    local count = self:getRebornCount(server, unit, percentage)
    if spent:size() > 0 then server:removeUnitBonuses(battle, unit, spent) end
    server:addUnitBonus(battle, unit, {
        type = SPENT, val = used + 1,
        duration = ENUM.BonusDuration.oneBattle,
        sourceType = ENUM.BonusSource.creatureAbility,
        sourceID = unit:getCreature():getJsonKey()
    }, false)
    if count <= 0 then return end
    server:showBattleAnimation(battle, {{unit = unit}}, "C01SPE0", "RESURECT", 0.5)
    local _, resurrected = server:healUnit(battle, unit, count * unit:getMaxHealth(), ENUM.HealLevel.resurrect, ENUM.HealPower.permanent)
    if resurrected > 0 then
        server:appendLog(battle, {
            append = {resurrected == 1 and "core.genrltxt.117" or "core.genrltxt.116"},
            replaceStrings = {unit:getCreature():getNameTextID(resurrected)},
            replaceNumbers = {resurrected}
        })
    end
    self:spendAnswer(server, battle, unit)
end
return Script

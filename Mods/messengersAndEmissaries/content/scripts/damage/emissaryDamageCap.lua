local Script = setmetatable({}, {__index = Base})
Script.__index = Script

local emissaries = {
    emissaryOfWar = true,
    emissaryOfPeace = true,
    emissaryOfMana = true,
    emissaryOfLore = true
}

function Script:getDamageCap(info)
    local creatureKey = info.attacker:getCreature():getJsonKey()

    if emissaries[creatureKey] then
        return 1
    end

    return Base.getDamageCap(self, info)
end

return Script
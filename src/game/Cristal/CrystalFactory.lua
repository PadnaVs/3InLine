local Crystal = require("src.game.Cristal.Crystal")
local MagicCrystal = require("src.game.Cristal.MagicCrystal")

local CrystalFactory = {}

local crystalTypes = 
{
    ["base"] = { 
        class = Crystal, params = { strType = "A"} 
    },
    ["magic"] = { 
        class = MagicCrystal, params = { strType = "A"} 
    },
}

function getRandomColor()
    local nColor = math.random(0, 5)

    local strTypes = 
    {
        [0] = "A",
        [1] = "B",
        [2] = "C",
        [3] = "D",
        [4] = "E",
        [5] = "F",
    }

    return strTypes[nColor]
end

function CrystalFactory.create(type, customParams)
    local config = crystalTypes[type]
    if not config then error("Неизвестный тип кристалла!") end
    
    -- Добавляем случайный цвет, если не указан вручную
    customParams = customParams or {}
    if not customParams.strColor then
        customParams.strColor = getRandomColor()
    end
    
    return config.class.new(unpack(customParams))
end

return CrystalFactory
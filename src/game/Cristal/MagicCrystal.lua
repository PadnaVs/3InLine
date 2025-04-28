local Crystal = require("src.game.Cristal.Crystal") 

local MagicCrystal = setmetatable({}, { __index = Crystal })

function MagicCrystal.new(strColor)
    local self = Crystal.new(strColor)

    setmetatable(self, { __index = MagicCrystal })
    return self
end

return MagicCrystal
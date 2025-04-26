local Crystal = require("src.game.Cristal.Crystal") 

local MagicCrystal = setmetatable({}, { __index = Crystal })

function MagicCrystal.new(strType)
    local self = Crystal.new(strType)

    setmetatable(self, { __index = MagicCrystal })
    return self
end

return MagicCrystal
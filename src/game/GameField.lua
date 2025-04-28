local CrystalFactory = require("src.game.Cristal.CrystalFactory")

local GameField = {}

function GameField.new()
    local self =
    {
        m_nSize = 10,
        m_fild = {}
    }

    setmetatable(self,{ __index = GameField })

    return self
end

function GameField:init()
    local size = self.m_nSize
    for i = 1, size do
        self.m_fild[i] = {}
        for j = 1, size do
            self.m_fild[i][j] = CrystalFactory.create("base")
        end
    end
end

function GameField:GetStrColorCell(x, y)
    return self.m_fild[x][y]:GetStrColor()
end

return GameField
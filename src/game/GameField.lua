local CrystalFactory = require("src.game.Cristal.CrystalFactory")

local GameField = {}

function GameField.new()
    local self =
    {
        m_nSize = 10,
        m_fild = {},

        m_mediator = {}
    }

    setmetatable(self,{ __index = GameField })

    return self
end

function GameField:OnDrawField()
    self.m_mediator:OnNotify("eventDrawField", self)
end

function GameField:OnEvent(strEvent, data)
    if strEvent == "eventMoveCristal" then
        self:MoveCrystal(data)
        self:OnDrawField()
    end
end

function getOtherCrystal(x, y, dir)
    local otherCoord = {
        m_nX = x,
        m_nY = y
    }

    if dir == 't' then
        otherCoord.m_nY = y - 1
    elseif dir == 'b' then
        otherCoord.m_nY = y + 1
    elseif dir == 'l' then
        otherCoord.m_nX = x - 1
    elseif dir == 'r' then
        otherCoord.m_nX = x + 1
    end

    return otherCoord
end

function GameField:DellCrystal(x, y, dir)
    local otherCoord = getOtherCrystal(x, y, dir)
    
    local startX = x
    if x < otherCoord.m_nX then
        startX = x
    else
        startX = otherCoord.m_nX
    end

    local startY = y
    if y < otherCoord.m_nY then
        startY = y
    else
        startY = otherCoord.m_nY
    end

    local x11 = self:GetStrColorCell(startY, startX-1);
    local x12 = self:GetStrColorCell(startY, startX);
    local x13 = self:GetStrColorCell(startY, startX+1);

    local y11 = self:GetStrColorCell(startX, startY);
    local y12 = self:GetStrColorCell(startX, startY);
    local y13 = self:GetStrColorCell(startX, startY);

    local blockY = {};
end

function GameField:MoveCrystal(dataMove)
    local x = dataMove.m_nX
    local y = dataMove.m_nY

    local dir = dataMove.m_strDirection

    local bIsNotInFild = x < 1 or y < 1 or x > 10 or y > 10
    local bIsBlockTop    = y == 1  and dir == 't'
    local bIsBlockBottom = y == 10 and dir == 'b'
    local bIsBlockLeft   = x == 1  and dir == 'l'
    local bIsBlockRight  = x == 10 and dir == 'r'
    
    if(bIsNotInFild or bIsBlockLeft or bIsBlockBottom or bIsBlockLeft or bIsBlockRight) then
        return
    else
        self:DellCrystal(x, y, dir)
    end
end

function GameField:init()
    local size = self.m_nSize
    for i = 1, size do
        self.m_fild[i] = {}
        for j = 1, size do
            self.m_fild[i][j] = CrystalFactory.create("base")
        end
    end

    self:OnDrawField()
end

function GameField:GetStrColorCell(y, x)
    if x > 0 or y > 0 or x < 11 or y < 11 then 
        return self.m_fild[y][x]:GetStrColor()
    end
end

return GameField
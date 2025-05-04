
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
        self:OnMoveCrystal(data)
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
    elseif dir == 'd' then
        otherCoord.m_nY = y + 1
    elseif dir == 'l' then
        otherCoord.m_nX = x - 1
    elseif dir == 'r' then
        otherCoord.m_nX = x + 1
    end

    return otherCoord
end

function GameField:MoveCrystal(x, y, dir)
    local crystal = self:GetCrystal(x, y)

    local otherCoord = getOtherCrystal(x, y, dir)

    local crystal2 = self:GetCrystal(otherCoord.m_nX, otherCoord.m_nY)

    local strColorTmp = crystal:GetStrColor()
    crystal:SetStrColor(crystal2:GetStrColor())
    crystal2:SetStrColor(strColorTmp)

    self:OnDrawField()
end

function GameField:GetCrossForCheckForCtystall(x, y)
    local block = 
    {
        { self:GetStrColorCell(x-2, y), self:GetStrColorCell(x-1, y), self:GetStrColorCell(x, y), self:GetStrColorCell(x+1, y), self:GetStrColorCell(x+2, y) },
        { self:GetStrColorCell(x, y-2), self:GetStrColorCell(x, y-1), self:GetStrColorCell(x, y), self:GetStrColorCell(x, y+1), self:GetStrColorCell(x, y+2) } 
    }

    return block
end

function checkNeedDellCrystalAfterMove(data, strType)
    if strType == " " then
        return false
    end
    
    local count = 1
    for i = 1, #data do
        if i == 3 then
            ::continue::
        else
            if strType == data[i] then
                count = count + 1
            else
                count = 1
            end
            if count >= 3 then
                return true
            end
        end
    end

    return false
end

function GameField:DellCrystalAfteMove(x, y)    
    local res = false

    local strTypeCrystal = self:GetStrColorCell(x, y)
    local crossForCheck = self:GetCrossForCheckForCtystall(x, y)
    
    if checkNeedDellCrystalAfterMove(crossForCheck[1], strTypeCrystal) or checkNeedDellCrystalAfterMove(crossForCheck[2], strTypeCrystal) then 
        res = true
        
        local step = 0
        local xlStrType = strTypeCrystal
        local ylStrType = strTypeCrystal
        local xrStrType = strTypeCrystal
        local yrStrType = strTypeCrystal

        local xlAllDel = false
        local xrAllDel = false
        local ylAllDel = false
        local yrAllDel = false
        
        while xlStrType == strTypeCrystal or ylStrType == strTypeCrystal or xrStrType == strTypeCrystal or yrStrType == strTypeCrystal do
            local xL = x - step
            local yL = y - step
            local xR = x + step
            local yR = y + step

            if xL == xR and yL == yR then
                self:DeleteCell(xL, yL)
            else
                if xlAllDel == false then
                    xlStrType = self:GetStrColorCell(xL, y)
                end
                
                if xlStrType == strTypeCrystal and xlAllDel == false then
                    self:DeleteCell(xL, y)
               else
                    xlAllDel = true
                end

                if xrAllDel == false then
                    xrStrType = self:GetStrColorCell(xR, y)
                end
                
                if xrStrType == strTypeCrystal and xrAllDel == false then
                    self:DeleteCell(xR, y)
                else
                    xrAllDel = true
                end

                if ylAllDel == false then
                    ylStrType = self:GetStrColorCell(x, yL)
                end
                
                if ylStrType == strTypeCrystal and ylAllDel == false then
                    self:DeleteCell(x, yL)
                else
                    ylAllDel = true
                end

                if yrAllDel == false then
                    yrStrType = self:GetStrColorCell(x, yR)
                end
                
                if yrStrType == strTypeCrystal and yrAllDel == false then
                    self:DeleteCell(x, yR)
                else
                    yrAllDel = true
                end
            end

            step = step + 1
        end
    end 
    
    return res
end

function GameField:OnMoveCrystal(dataMove)
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
        self:MoveCrystal(x, y, dir)
        local isDel1 = self:DellCrystalAfteMove(x, y)
        
        local othXY = getOtherCrystal(x, y, dir)
        local isDel2 = self:DellCrystalAfteMove(othXY.m_nX, othXY.m_nY)

        if isDel1 == false and isDel2 == false then
            self:MoveCrystal(x, y, dir)
        else
            for i = 1, self.m_nSize do
                self:LowerCrystalDown(i, 1)
            end

            self:tick()
        end
    end
end

function GameField:LowerCrystalDown(x, y)
    local yDown = -1

    for i = 1, self.m_nSize do
        local strColorTypeCrystalTmp = self:GetStrColorCell(x, i);
        if strColorTypeCrystalTmp == " " then
            yDown = i
        end
    end

    if yDown == -1 then
        return
    end

    local arrCollumn = {}
    for i = yDown, 1, -1 do
        local strColorTypeCrystalTmp = self:GetStrColorCell(x, i);
        if strColorTypeCrystalTmp ~= " " then
            arrCollumn[#arrCollumn+1] = strColorTypeCrystalTmp
            self:DeleteCell(x, i) 
        end
    end

    for i = yDown, 1, -1 do
        local strColorTypeCrystalTmp = " "
        if #arrCollumn >= 1 then
            strColorTypeCrystalTmp = arrCollumn[1]
            table.remove(arrCollumn, 1)
        end
        
        if strColorTypeCrystalTmp ~= " " then
            local customParams = { strColor = strColorTypeCrystalTmp }
            self.m_fild[i][x] = CrystalFactory.create("base", customParams)
        else
            self.m_fild[i][x] = CrystalFactory.create("base")
        end
    end
end

function GameField:tick()
    local isDel = true
    while isDel do
        local isDelTmp = false

        for i = 1, self.m_nSize do
            for j = 1, self.m_nSize do
                if self:DellCrystalAfteMove(j, i) then
                    isDelTmp = true
                end
            end
        end

        if isDelTmp then
            self:OnDrawField()

            for i = 1, self.m_nSize do
                self:LowerCrystalDown(i, 1)
            end
        else
            isDel = false
        end
    end

    self:OnDrawField()
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

    self:tick()
end

function GameField:GetCrystal(x, y)
    local strRes = " "
    if x > 0 and y > 0 and x < 11 and y < 11 then
        if self.m_fild[y][x] ~= nil then
            strRes = self.m_fild[y][x]
        end
    end
    return strRes
end

function GameField:GetStrColorCell(x, y)
    local strRes = " "
    if x > 0 and y > 0 and x < 11 and y < 11 then
        if self.m_fild[y][x] ~= nil then
            strRes = self.m_fild[y][x]:GetStrColor()
        end
    end
    return strRes
end

function GameField:DeleteCell(x, y)
    if x > 0 and y > 0 and x < 11 and y < 11 then
        if self.m_fild[y][x] ~= nil then 
            self.m_fild[y][x] = nil
        end
    end
end

return GameField
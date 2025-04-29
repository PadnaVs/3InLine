local Mediator = {}

function Mediator.new()
    local self = 
    {
       m_view = {},
       m_gameField = {}
    }

    setmetatable(self,{ __index = Mediator })

    return self
end

--не массивом т.к. всего 2 объекта и view и gamefild новых не будет -- можно поменять в будующем на массивы
function Mediator:SetView(view)
    view.m_mediator = self
    self.m_view = view
end

function Mediator:SetGameField(gameField)
    gameField.m_mediator = self
    self.m_gameField = gameField
end

function Mediator:OnNotify(event, objSend, data)
    if(objSend == self.m_view) then
        self.m_gameField:OnEvent(event, data)
    else
        self.m_view:OnEvent(event)
    end
end

return Mediator
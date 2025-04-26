local GameField = {}

function GameField.new()
    local self =
    {
        m_nSize = 10;
        m_fild = {};
    }

    setmetatable(self,{ __index = GameField })

    return self
end

return GameField
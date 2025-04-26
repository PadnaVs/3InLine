local Cristal = {}

function Cristal.new(strColor)
    local self = 
    {
        m_strColor = strColor
    }

    setmetatable(self,{ __index = Cristal })

    return self
end
local Crystal = {}

function Crystal.new(strColor)
    local self = 
    {
        m_strColor = strColor
    }

    setmetatable(self,{ __index = Crystal })

    return self
end

function Crystal:GetStrColor()
    return self.m_strColor
end

function Crystal:SetStrColor(strColor)
    self.m_strColor = strColor
end

return Crystal
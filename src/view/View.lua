local View = {}

function View.new(gameFieldInstance)
    local self = 
    {
        m_gameField = gameFieldInstance,
        m_mediatr = {}
    }

    setmetatable(self, { __index = View })
return self
end

function split(str, sep)
    local parts = {}
    for part in str:gmatch("[^"..sep.."]+") do
        table.insert(parts, part)
    end
    return parts
end

function GetDataInput(strInput)
    local dataInput = 
    {
        m_strEvent = '',
        m_nX = -1,
        m_nY = -1,
        m_strDirection = ''
    }

    local strData = split(strInput, " ")

    dataInput.m_strEvent = strData[1]
    dataInput.m_nX = tonumber(strData[2])
    dataInput.m_nY = tonumber(strData[3])
    dataInput.m_strDirection = strData[4]

    return dataInput
end

function View:OnEvent(strEvent)
    if strEvent == "eventDrawField" then
        self:printGameFild()
    end
end

function View:start()
    self.m_gameField:init()
    
    while true do
        print("Pls input command for game: evt, x, y, dir.")
        local strInput = io.read()
        if(strInput == "Exit") then
            return
        elseif strInput ~= "" then
            local dataInput = GetDataInput(strInput)

            if dataInput.m_strEvent == 'm' then
                self.m_mediator:OnNotify("eventMoveCristal", self, dataInput)
            end
        end
    end
end

function View:clearConsole()
    if package.config:sub(1,1) == "\\" then  -- Windows
        os.execute("cls")
    else  -- Unix-like (Linux, macOS)
        os.execute("clear")
    end
end

function View:printGameFild()
    self:clearConsole()

    local sizeFild = self.m_gameField.m_nSize
    
    for i = 1, sizeFild do
        for j = 1, sizeFild do
            io.write(self.m_gameField:GetStrColorCell(i, j))
        end
        io.write('\n')
    end

    print('\n')

    os.execute("timeout /T " .. 1 .. " /NOBREAK > NUL")
end

return View

local GameField = require "src.game.GameField"

local View = {}

function View.new()
    local self = 
    {
        m_gameFild = {};
    }

    setmetatable(self,{ __index = View })

    return self
end

function View:setGameFild(gameFild)
    self.m_gameFild = gamefild;
end

function View:start()
    
end

function View:clearConsole()
    if package.config:sub(1,1) == "\\" then  -- Windows
        os.execute("cls")
    else  -- Unix-like (Linux, macOS)
        os.execute("clear")
    end
end

return View
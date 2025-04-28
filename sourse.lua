
--********************************
--**"Developer Pakharev Mikhail"**
--********************************

local View = require "src.view.View"
local GameFild = require "src.game.GameField"

local gameFild = GameFild.new()

local view = View.new(gameFild)
view:start()


--********************************
--**"Developer Pakharev Mikhail"**
--********************************

local View = require "src.view.View"
local GameField = require "src.game.GameField"
local Mediator = require "src.mediator.Mediator"

local gameField = GameField.new()
local view = View.new(gameField)

local mediator = Mediator.new()
mediator:SetGameField(gameField)
mediator:SetView(view)

view:start()

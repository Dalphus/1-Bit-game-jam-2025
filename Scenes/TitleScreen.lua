require( "helpers" )
require( "UI/Button" )

Title_Screen = ( function()
  local title = "Supernova Drift"
  local Start_button = Button:new(0, 200, 300, 200, "BCENT")
  Start_button:setFunction(function() Start_button:disable() end)
  Start_button:setText("GO")

  return {
    name = "Title Screen",
    draw = function( self )
    end,
    1
  }
end)()

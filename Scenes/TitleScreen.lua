require( "helpers" )
require( "UI.Button" )

Title_Screen = ( function()
  local title = "Supernova Drift"

  local Start_button = Button:new( 570, 600, 300, 200 )
  Start_button:setText("GO")
  Start_button:setFunction(
    function ()
      Next_Scene = Gameplay
      Transition_Timer = 2
    end
  )

  return {
    name = "Title Screen",

    draw = function()
      Start_button:draw()
    end,

    mousereleased = function( x, y, button )
      if button == 1 then
        Start_button:mouseEvent()
      end
    end,

    mousepressed = function( x, y, button )
      if Start_button:isEnabled() then return end
    end,
  }
end)()

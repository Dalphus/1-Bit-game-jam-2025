require( "helpers" )
require( "UI.Button" )

-- Title Buttons are globals cause it's just easier that way
Start_button = Button:new( 570, 600, 300, 200 )

Title_Screen = {
  title = "Supernova Drift",

  load = function()
    Start_button:setText("GO")
    Start_button:setFunction(
      function ()
        Next_Scene = Gameplay
        Transition_Timer = 1
      end
    )
    Start_button:setAudio(love.audio.newSource("Assets/Sounds/button-8-88355.mp3", "static"))
    Title = love.graphics.newImage( "Assets/Title_large.png" )
  end,

  mousepressed = function( x, y, button )
    if Start_button:isEnabled() then return end
  end,
  
  mousereleased = function( x, y, button )
    if button == 1 then
      Start_button:mouseEvent()
    end
  end,

  draw = function()
    useColor1()
    local w, h = Title:getDimensions()
    love.graphics.draw( Title, (love.graphics.getWidth() - w) / 2, (love.graphics.getHeight() / 5) - (h / 2), 0)
    Start_button:draw()
  end
}

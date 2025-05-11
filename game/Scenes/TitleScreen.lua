-- Title Buttons are globals cause it's just easier that way
Start_button = Button:new( 570, 600, 300, 200 )
Color_button = Button:new( 570, 600, 1000, 200 )
Color_Prompt = nil

Title_Screen = {
  title = "Supernova Drift",

  load = function()
    local font = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", 80 )
    local font_small = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", 30 )
    local font_object = love.graphics.newText( font, "GO" )
    Color_Prompt = love.graphics.newText( font_small, "( press [ space ] to change the color! )" )

    Start_button.textObject = font_object
    Start_button:setFunction(
      function ()
        if Transition.timer <= 0 then
          Transition:fadeTo( Lore, 5 )
        end
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

  keypressed = function( key, scancode, isrepeat )
    if scancode == "space" then
      setColor1( math.random(), math.random(), math.random() )
    end
  end,

  draw = function()
    useColor1()
    local w, h = Title:getDimensions()
    love.graphics.draw( Title, (love.graphics.getWidth() - w) / 2, (love.graphics.getHeight() / 5) - (h / 2), 0)
    Start_button:draw()

    love.graphics.draw( Color_Prompt, love.graphics.getWidth() / 2 - Color_Prompt:getWidth() / 2, love.graphics.getHeight() - Color_Prompt:getHeight() - 30 )
  end
}

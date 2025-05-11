GameOver = {}

function GameOver.load()
  GameOver.font = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", 60 )
  GameOver.font_small = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", 30 )
end

function GameOver.keypressed(key, scancode, isrepeat)
  if scancode == "space" or scancode == "return" and Transition.timer <= 0 then
    Gameplay:load()
    G.LEVEL_DENSITY = 200
    Lore:load()
    Transition:fadeTo( Title_Screen, 3.5, { 0, 0, 0 } )
    Player.health = 10
  end
end

function GameOver.draw()
  setColor2( 0, 0, 0 )
  local text1 = love.graphics.newText( GameOver.font, "GAME OVER" )
  
  local text2 = love.graphics.newText( GameOver.font_small, "You have been defeated." )
  local text3 = love.graphics.newText( GameOver.font_small, "Sectors Cleared: " .. ( Gameplay.current_level - 1 ))
  local text4 = love.graphics.newText( GameOver.font_small, "Press [ space ] to go back to main menu" )

  useColor1()
  love.graphics.draw( text1, love.graphics.getWidth() / 2 - text1:getWidth() / 2, 30 )
  love.graphics.draw( text2, love.graphics.getWidth() / 2 - text2:getWidth() / 2, love.graphics.getHeight() / 2 - text2:getHeight() / 2 )
  love.graphics.draw( text3, love.graphics.getWidth() / 2 - text3:getWidth() / 2, love.graphics.getHeight() / 2 + text2:getHeight() )
  love.graphics.draw( text4, love.graphics.getWidth() / 2 - text4:getWidth() / 2, love.graphics.getHeight() - text4:getHeight() - 30 )
end

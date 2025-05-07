-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[ 2 ] == "vsc_debug" then
  require( "lldebugger" ).start()
end

require( "helpers" )
require( "Player" )
require( "UI/Button" )
require( "Scenes/TitleScreen" )
require( "Scenes/Lore" )
require( "Scenes/Asteroids" )

function love.load()
  -- Set up the window
  love.window.setMode(1440, 1080, { resizable = true, vsync = false })

  -- Global Variables
  Geraldo = Player:new( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )

  
  local font = love.graphics.getFont()
  Lore_dump = love.graphics.newText(font, {{1,1,1}, "LORE"})

  -- Pick random seed
  math.randomseed( os.time() )
end

function love.mousepressed( mouse_x, mouse_y, button )
  if button == 1 then
    -- if Start_button:isEnabled() then return end
    
    setColor1( math.random(), math.random(), math.random() )
  end
end

function love.mousereleased( mouse_x, mouse_y, button)
  if button == 1 then
    -- Start_button:mouseEvent()
  end
end

function love.mousemoved( mouse_x, mouse_y, dx, dy, force )

end

function love.keypressed( key, scancode, isrepeat )
  -- quit game if escape is pressed
  if scancode == "escape" then
    love.event.quit()
  end
  if scancode == "space" then
    print( love.graphics.getWidth(), love.graphics.getHeight() )
    -- fire bullet
  end
end

function love.draw()
  -- clear the screen
  love.graphics.clear( unpack( Color2 ))
  useColor1()

  if Start_button:isEnabled() then
    Start_button:draw()
    love.graphics.draw(Lore_dump, (love.graphics.getWidth()/2) - (Lore_dump:getWidth()/2), (love.graphics.getHeight()/4) - (Lore_dump:getHeight()/2))
  end

  -- draw the player
  Geraldo:draw()
end

function love.update( dt )
  Geraldo:update( dt )
end


local love_errorhandler = love.errorhandler
function love.errorhandler( msg )
  if lldebugger then
    error( msg, 2 )
  else
    return love_errorhandler( msg )
  end
end

-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[ 2 ] == "vsc_debug" then
  require( "lldebugger" ).start()
end

require( "helpers" )
require( "Player" )
require( "UI.Button" )
require( "UI.Camera" )
require( "Scenes.TitleScreen" )
require( "Scenes.Lore" )
require( "Scenes.Gameplay" )
require( "Scenes.Transition" )
require( "Scenes.Upgrades" )
require( "Scenes.GameOver" )
require( "Asteroid" )

function love.load()
  -- Set up the window
  love.window.setMode(1440, 1080, { resizable = true, vsync = false })

  -- 1-bit Colors
  Color1 = { 1, 1, 1, 1 }
  Color2 = { 0, 0, 0, 1 }

  -- Scene Management
  Camera:load()
  Title_Screen:load()
  Lore.load()
  Gameplay:load()
  Asteroid:load()
  Upgrade:load()
  GameOver.load()
  Active_Scene = Gameplay

  Level_Score = 0

  -- Pick random seed
  math.randomseed( os.time() )
end

function love.mousepressed( mouse_x, mouse_y, button )
  if button == 1 then
    -- setColor1( math.random(), math.random(), math.random() )
  end

  if Active_Scene.mousepressed then
    Active_Scene.mousepressed( mouse_x, mouse_y, button )
  end
end

function love.mousereleased( mouse_x, mouse_y, button )

  if Active_Scene.mousereleased then
    Active_Scene.mousereleased( mouse_x, mouse_y, button )
  end
end

function love.mousemoved( mouse_x, mouse_y, dx, dy, force )

  if Active_Scene.mousemoved then
    Active_Scene.mousemoved( mouse_x, mouse_y, dx, dy, force )
  end
end

function love.keypressed( key, scancode, isrepeat )
  if scancode == "escape" then
    love.event.quit()
  end
  
  if scancode == "h" then
    Camera:shake( 10, 0.5 )
    Level_Score = 3
  end

  if Active_Scene.keypressed then
    Active_Scene.keypressed( key, scancode, isrepeat )
  end
end

function love.draw()
  -- clear the screen
  love.graphics.clear( unpack( Color2 ))
  
  Camera:draw()
  Active_Scene.draw()

  Transition:draw()
end

function love.update( dt )
  Camera:update( dt )
  Transition:update( dt )

  if Active_Scene.update then
    Active_Scene.update( dt )
  end
end


local love_errorhandler = love.errorhandler
function love.errorhandler( msg )
  if lldebugger then
    error( msg, 2 )
  else
    return love_errorhandler( msg )
  end
end

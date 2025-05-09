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

function love.load()
  -- Set up the window
  love.window.setMode(1440, 1080, { resizable = true, vsync = false })

  -- Global Variables
  Color1 = { 1, 1, 1, 1 }
  Color2 = { 0, 0, 0, 1 }

  Main_Camera = Camera:new()

  Title_Screen:load()
  Gameplay:load()

  -- Scene Management
  Active_Scene = Title_Screen
  Next_Scene = nil
  Previous_Scene = nil
  Transition_Timer = -1

  -- Pick random seed
  math.randomseed( os.time() )
end

function love.mousepressed( mouse_x, mouse_y, button )
  if button == 1 then
    -- if Start_button:isEnabled() then return end
    
    setColor1( math.random(), math.random(), math.random() )
  end

  if Active_Scene.mousepressed then
    Active_Scene.mousepressed( mouse_x, mouse_y, button )
  end
end

function love.mousereleased( mouse_x, mouse_y, button)

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
  -- quit game if escape is pressed
  if scancode == "escape" then
    love.event.quit()
  end
  
  if scancode == "space" then
    print( love.graphics.getWidth(), love.graphics.getHeight() )
    -- fire bullet
  end

  if Active_Scene.keypressed then
    Active_Scene.keypressed( key, scancode, isrepeat )
  end
end

function love.draw()
  -- clear the screen
  -- love.graphics.clear( unpack( Color2 ))
  useColor1()

  Main_Camera:shake()
  Active_Scene.draw()
end

function love.update( dt )
  -- check if transition timer is active
  -- start fading color1 into color2
  -- change scene
  if Transition_Timer > 0 then
    Transition_Timer = Transition_Timer - dt
    if Transition_Timer <= 0 then
      -- change scene
      Previous_Scene = Active_Scene
      Active_Scene = Next_Scene
      Next_Scene = nil
      Transition_Timer = -1
    end
  end

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

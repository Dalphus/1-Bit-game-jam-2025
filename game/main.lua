
require( "helpers" )
require( "Player" )
require( "UI.Button" )
require( "UI.Camera" )
require( "Scenes.TitleScreen" )
require( "Scenes.Gameplay" )
require( "Scenes.Transition" )
require( "Scenes.Upgrades" )
require( "Scenes.GameOver" )
require( "Asteroid" )

Lore = {
  dump = {
    "Supernovae are likely the most destructive force in the universe.",
    "The firey explosion can easily destroy all life within the solar",
    "system, expanding to swallow it whole. And all this destructive",
    "force can move close to 10% the speed of light. Even worse, the",
    "radiation from such an explosion can be lethal even at lightyear",
    "distances. These facts are brought forward by invasive thoughts,",
    "or perhaps a sense of acceptance. Spica, the star you are in the",
    "system of right now is going supernova.",
    "",
    "",
    "You have to escape...",
    "",
    "",
    "But you don't have time.",
    "",
    "",
    "Not with the fuel you have. Your only hope is to try to find the",
    "precious fuel you need in sectors along your escape route. Along",
    "with all of the other desperate civilians escaping Spica's solar",
    "system. Destroy the asteroids with minerals needed for fuel,",
    "collect the scraps. Then warp to the next sector and do it all",
    "again. Try to outrun all the others.",
    "",
    "",
    "Try to outrun the sun.",
    "",
    "",
    "Try to outrun the speed of light.",
    "                                                                 "
  },
  font_size = 25,
  interval = 0.06,
  sentence_delay = 0.9
}

function Lore.load()
  Lore.font = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", Lore.font_size )
  Lore.counters = {}
  Lore.timers = {}
  for i = 1, #Lore.dump do
    Lore.counters[ i ] = 0
    Lore.timers[ i ] = 0
  end
  Lore.counters[ 1 ] = 1

  Lore.sound = love.audio.newSource("Assets/Sounds/mechanical-key-soft-80731.mp3", "static")
end

function Lore.update( dt )
  for i = 1, #Lore.counters do
    if Lore.counters[ i ] > 0 and Lore.counters[ i ] < 100 then
      Lore.timers[ i ] = Lore.timers[ i ] + dt
      local last_char = string.sub( Lore.dump[ i ], Lore.counters[ i ], Lore.counters[ i ] )
      local pause = last_char == "," or last_char == "."
      -- if pause then print( "pause" ) end
      if Lore.timers[ i ] > ( Lore.interval + ( pause and Lore.sentence_delay or 0 )) then
        if i < #Lore.dump then
          love.audio.play( Lore.sound:clone() )
        end
        Lore.counters[ i ] = Lore.counters[ i ] + 1
        Lore.timers[ i ] = 0

        if Lore.counters[ i ] > string.len( Lore.dump[ i ] ) then
          Lore.counters[ i ] = 100
          if i < #Lore.dump and Lore.counters[ i + 1 ] == 0 then
            Lore.counters[ i + 1 ] = 1
          end
        end
      end
    end
  end
end

function Lore.draw()
  useColor1()
  love.graphics.setFont( Lore.font )
  for i = 1, #Lore.dump do
    local x = Lore.font_size + 25
    local y = i * ( Lore.font_size + 2 ) + 25
    local text = string.sub( Lore.dump[ i ], 1, Lore.counters[ i ] )
    love.graphics.print( text, x, y )
  end
  if Lore.counters[ #Lore.dump ] == 100 then
    local x = Lore.font_size + 25
    local y = ( #Lore.dump + 4 ) * ( Lore.font_size + 2 ) + 25
    love.graphics.print( "[ Press any key to enter warp speed ]", x, y )
  end
end

function Lore.keypressed( key, scancode, isrepeat )
  for i = 1, #Lore.counters do
    if Lore.counters[ i ] == 0 then
      Lore.counters[ i ] = 1
      break
    end
  end

  if Lore.counters[ #Lore.dump ] == 100 and Transition.timer <= 0 then
    Transition:fadeTo( Gameplay, 6, { 1, 1, 1 } )
    local into_lightspeed = love.audio.newSource("Assets/Sounds/sci-fi-chargeup.mp3", "static")
    into_lightspeed:play()
  end
end



function love.load()
  -- Set up the window
  love.window.setMode(1440, 1000, { resizable = false, vsync = false })

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
  Active_Scene = Title_Screen

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
  if scancode == "f12" then
    Camera:shake( 10, 0.5 )
    Level_Score = 4
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

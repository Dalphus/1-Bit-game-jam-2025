-- Globals
Geraldo = Player
Bullets = {}
Asteroids = {}
Fuel_Asteroids = {}
Screen_Covered = false

-- Constants
Gameplay = {
  -- Player Physics
  BULLET_LIFETIME = 1,
  BULLET_SIZE = 2,
  PINBALL_COEFFICIENT = 1.9,
  -- Asteroids
  LEFT_WALL = -7000,
  RIGHT_WALL = 7000,
  TOP_WALL = 7000,
  BOTTOM_WALL = -7000,
  WALL_DENSITY = 50,
  WALL_SHUFFLE = 300,
  LEVEL_DENSITY = 200,
  LEVEL_SHUFFLE_V = 20,
  SAFE_ZONE = 400,
  FUEL_ASTEROIDS = 4,
  -- Visuals
  SCORE_SIZE = 50,
  PARALLAX_CONSTANT = 0.1,
  SCANNER_RADIUS = 75,
  LEVEL_TRANSITION_DURATION = 7.8,

  level_timer = 0,
  enter_animation_duration = 3,

  current_level = 1,
  level_max_time = 123
}
G = Gameplay

function G.load()
  G.font = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", 60 )
  G.font_small = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", 30 )

  local screen_width = love.graphics.getWidth()
  local screen_height = love.graphics.getHeight()

  G.level_timer = 0

  collide = love.audio.newSource( "Assets/Sounds/collide.mp3", "static" )

  Asteroids = {}
  Fuel_Asteroids = {}
  Geraldo = Player:new( screen_width / 2, screen_height / 2 )

  for i = 1, G.LEVEL_DENSITY do
    local ast_x, ast_y
    repeat
      ast_x = math.random( G.LEFT_WALL, G.RIGHT_WALL )
      ast_y = math.random( G.BOTTOM_WALL, G.TOP_WALL )
    until distance( ast_x, ast_y, Geraldo.x, Geraldo.y ) > G.SAFE_ZONE
    local asteroid = Asteroid:new(
      "normal_big",
      ast_x,
      ast_y,
      math.random( 0, 2 * math.pi ),
      math.random( 450, 460 ),
      math.random( -G.LEVEL_SHUFFLE_V, G.LEVEL_SHUFFLE_V ),
      math.random( -G.LEVEL_SHUFFLE_V, G.LEVEL_SHUFFLE_V ),
      math.random( -0.05, 0.05 ),
      1
    )
    table.insert( Asteroids, asteroid )
  end

  for i = 1, G.FUEL_ASTEROIDS do
    local ast_x = screen_width / 2
    local ast_y = screen_height / 2
    while (ast_x > (screen_width / 2) - G.SAFE_ZONE and ast_x < (screen_width / 2) + G.SAFE_ZONE) and (ast_y > (screen_height / 2) - G.SAFE_ZONE and ast_y < (screen_height / 2) + G.SAFE_ZONE) do
      ast_x = math.random(G.LEFT_WALL, G.RIGHT_WALL)
      ast_y = math.random(G.BOTTOM_WALL, G.TOP_WALL)
    end
    local fuel = Asteroid:new( "tritium_big", ast_x, ast_y, 0, 300, 0, 0, 0.1 )
    table.insert( Asteroids, fuel)
    table.insert( Fuel_Asteroids, fuel)
  end

  star_background_1 = imageToCanvas( "Assets/big-stars-splash.png" )
  warpin_sound = love.audio.newSource("Assets/Sounds/whooshin.mp3", "static")

  Score_Image =  imageToCanvas( "Assets/fuelBIG.png" )
  sw, sh = Score_Image:getDimensions()

  for i = 1, G.WALL_DENSITY do
    local offset = (love.math.random() - 0.5) * G.WALL_SHUFFLE
    -- top border
    table.insert( Asteroids, Asteroid:new( "normal_big", offset + G.LEFT_WALL + ((G.RIGHT_WALL - G.LEFT_WALL) * i / G.WALL_DENSITY), offset + G.TOP_WALL, 0, 500, 0, 0, 0, 100))
    -- left border
    table.insert( Asteroids, Asteroid:new( "normal_big", offset + G.LEFT_WALL, offset + G.BOTTOM_WALL + ((G.TOP_WALL - G.BOTTOM_WALL) * i / G.WALL_DENSITY), 0, 500, 0, 0, 0, 100))
    -- bottom border
    table.insert( Asteroids, Asteroid:new( "normal_big", offset + G.LEFT_WALL + ((G.RIGHT_WALL - G.LEFT_WALL) * i / G.WALL_DENSITY), offset + G.BOTTOM_WALL, 0, 500, 0, 0, 0, 100))
    -- right border
    table.insert( Asteroids, Asteroid:new( "normal_big", offset + G.RIGHT_WALL, offset + G.BOTTOM_WALL + ((G.TOP_WALL - G.BOTTOM_WALL) * i / G.WALL_DENSITY), 0, 500, 0, 0, 0, 100))
  end
end

function G.mousepressed( x, y, button )
  if button == 1 then
    table.insert( Bullets, Geraldo:fire() )
  end
end

function G.draw()
  
  local bg_offset_x = -1250 -- Geraldo.x - (Geraldo.x % 2500) - (love.graphics.getWidth()/2)
  local bg_offset_y = -1250 -- Geraldo.y - (Geraldo.y % 2500) - (love.graphics.getHeight()/2)
  
  useColor1()
  -- Should look into a way to get this to repeat
  -- paralax very slow section
  Camera:camOffset( G.PARALLAX_CONSTANT * 0.1 )
  Camera:center( Geraldo.x, Geraldo.y, G.PARALLAX_CONSTANT * 0.1 )
  love.graphics.draw( star_background_1, bg_offset_x - 200, bg_offset_y, 0, 5, 5 )
  
  -- paralax slow section
  Camera:camOffset( G.PARALLAX_CONSTANT )
  Camera:center( Geraldo.x, Geraldo.y, G.PARALLAX_CONSTANT )
  love.graphics.draw( star_background_1, bg_offset_x, bg_offset_y - 250, 0, 5, 5 )
  
  -- paralax fast section
  Camera:camOffset( G.PARALLAX_CONSTANT )
  Camera:center( Geraldo.x, Geraldo.y, G.PARALLAX_CONSTANT )
  love.graphics.draw( star_background_1, bg_offset_x, bg_offset_y, 0, 5, 5 )
  
  -- reset graphics transforms
  love.graphics.origin()
  
  -- draw collected resources
  if Level_Score > 0 then
    love.graphics.draw( Score_Image, love.graphics.getWidth() - (G.SCORE_SIZE * 0.6), 30, 0, G.SCORE_SIZE / sw, G.SCORE_SIZE / sh, sw / 2, sh / 2 )
    if Level_Score > 1 then
      love.graphics.draw( Score_Image, love.graphics.getWidth() - (G.SCORE_SIZE * 1.8), 30, 0, G.SCORE_SIZE / sw, G.SCORE_SIZE / sh, sw / 2, sh / 2 )
      if Level_Score > 2 then
        love.graphics.draw( Score_Image, love.graphics.getWidth() - (G.SCORE_SIZE * 3.0), 30, 0, G.SCORE_SIZE / sw, G.SCORE_SIZE / sh, sw / 2, sh / 2 )
      end
    end
  end

  Camera:camOffset()

  local cx = love.graphics.getWidth()/2
  local cy = love.graphics.getHeight()/2

  -- Fuel pointers
  for i = 1, #Fuel_Asteroids do
    local a = Fuel_Asteroids[i]
    local angle = math.atan2( Geraldo.y - a.y, Geraldo.x - a.x )
    love.graphics.circle("fill", cx - (G.SCANNER_RADIUS * math.cos(angle)), cy - (G.SCANNER_RADIUS * math.sin(angle)), 8, 50)
  end

  Camera:center( Geraldo.x, Geraldo.y )
  
  Geraldo:draw()

  -- show origin of asteroid field
  -- love.graphics.circle("fill", 0, 0, 25, 50)
  
  for i = 1, #Asteroids do
    local a = Asteroids[ i ]
    a:draw()
  end

  for i = 1, #Bullets do
    local b = Bullets[ i ]
    love.graphics.draw( Geraldo.decal, b.x + G.BULLET_SIZE / 2, b.y + G.BULLET_SIZE / 2, b.rotation, G.BULLET_SIZE, G.BULLET_SIZE, Geraldo.decal:getWidth() / 2, Geraldo.decal:getHeight() / 2 )
  end

  if G.level_timer < G.enter_animation_duration then
    if G.level_timer > 1 then warpin_sound:play() end

    local w, h = love.graphics.getDimensions()
    local t = G.enter_animation_duration - G.level_timer
    love.graphics.circle("fill", w / 2, h / 2, 2000 * t / 2, 50)
  end

  love.graphics.origin()
  useColor1()

  love.graphics.setFont( G.font_small )
  love.graphics.print("Level " .. G.current_level, 30, 30)
  love.graphics.print("Health: " .. Geraldo.health, 30, 90)

  local seconds_remaining = math.floor( G.level_max_time - G.level_timer )
  local minutes_remaining = seconds_remaining / 60
  local milliseconds_remaining = math.floor(( G.level_max_time - G.level_timer ) * 1000 )
  local clock_text = ""
  if seconds_remaining > 60 then
    clock_text = string.format( "%1d:%02d", minutes_remaining, seconds_remaining % 60 )
  else
    clock_text = string.format( "%2d.%003d", seconds_remaining % 60, milliseconds_remaining % 1000 )
  end
  local clock = love.graphics.newText( G.font, clock_text )
  love.graphics.draw( clock, love.graphics.getWidth() / 2 - clock:getWidth() / 2, 30 )
end

function G.update( dt )
  G.level_timer = G.level_timer + dt

  -- Compare every bullet with every asteroid
  for i = 1, #Bullets do
    local b = Bullets[ i ]
    for j = 1, #Asteroids do
      local a = Asteroids[ j ]
      if not b or not a then break end -- bandaid, find cause later
      if distance( b.x, b.y, a.x, a.y ) < a.size / 2 then
        -- remove bullet
        table.remove( Bullets, i )
        i = i - 1
        -- damage asteroid
        a:damage( 1 )
        break
      end
    end
  end

  -- Check score
  if Level_Score >= G.FUEL_ASTEROIDS then
    Level_Score = 0
    Transition:warpTo( Upgrade, G.LEVEL_TRANSITION_DURATION )
    local into_lightspeed = love.audio.newSource("Assets/Sounds/sci-fi-chargeup.mp3", "static")
    into_lightspeed:play()
  end
  if ( G.level_timer > G.level_max_time or Geraldo.health <= 0 ) and Transition.timer <= 0 then
    Transition:fadeTo( GameOver, 3.5, { 0, 0, 0 } )
    love.audio.newSource("Assets/Sounds/videogame-death-sound-43894.mp3", "static"):play()
  end

  -- check health of asteroids and destroy them if needed
  for i = 1, #Asteroids do
    local a = Asteroids[ i ]
    if a.health <= 0 then
      table.remove( Asteroids, i )
      
      if a.type == "tritium_big" or a.type == "tritium_shard" then -- replace at some point
        for ii = 1, #Fuel_Asteroids do
          if a == Fuel_Asteroids[ii] then
            table.remove(Fuel_Asteroids, ii)
          end
        end
      end
      
      a:destroy()
      break
    end
  end

  -- check player for collisions with asteroids
  for i = 1, #Asteroids do
    local a = Asteroids[ i ]
    if distance( Geraldo.x, Geraldo.y, a.x, a.y ) < a.size / 2 then
      local Good_Collision = false
      
      -- destroy asteroid
      a:destroy()
      
      -- for fuel, don't do anything but destroy the object.
      if a.type == "tritium_shard" then
        for ii = 1, #Fuel_Asteroids do
          if a == Fuel_Asteroids[ii] then
            table.remove(Fuel_Asteroids, ii)
          end
        end
        Good_Collision = true 
      end
      table.remove( Asteroids, i )
      if Good_Collision then return end
      
      -- damage player
      Geraldo:damage( 1 )
      -- shake camera
      Camera:shake( 10, 0.5 )
      -- play collision sound
      local boomsound = collide:clone()
      boomsound:play()
      -- throw player back
      local angle = math.atan2( Geraldo.y - a.y, Geraldo.x - a.x )
      Geraldo.vx = Geraldo.vx + math.cos( angle ) * math.sqrt(Geraldo.vx^2 + Geraldo.vy^2) * G.PINBALL_COEFFICIENT
      Geraldo.vy = Geraldo.vy + math.sin( angle ) * math.sqrt(Geraldo.vx^2 + Geraldo.vy^2) * G.PINBALL_COEFFICIENT
      break
    end
  end

  Geraldo:update( dt )

  for i = 1, #Asteroids do
    local a = Asteroids[ i ]
    a:update( dt )
  end

  for i in pairs( Bullets ) do
    local b = Bullets[ i ]
    b.x = b.x + b.vx * dt
    b.y = b.y + b.vy * dt
    b.lifetime = b.lifetime - dt
    if b.lifetime <= 0 then
      table.remove( Bullets, i )
    end
  end

  if G.level_max_time - G.level_timer < 30 then
    Camera:shake( 10, 0.5 )
    local color = 1 - ( G.level_max_time - G.level_timer ) / 30
    setColor2( 0, color * .5, color * .5 )
  end
  if G.level_max_time - G.level_timer < 5 then
    Camera:shake( 18, 0.5 )
  end

end

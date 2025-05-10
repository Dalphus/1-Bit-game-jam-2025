require( "helpers" )
require( "UI.Button" )
require( "Player" )
require( "Asteroids" )

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
  PINBALL_COEFFICIENT = 2,
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
  -- Visuals
  SCORE_SIZE = 50,
  PARALLAX_CONSTANT = 0.1,
  SCANNER_RADIUS = 75
}
G = Gameplay

function G.load()
  local screen_width = love.graphics.getWidth()
  local screen_height = love.graphics.getHeight()

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

  for i = 1, 3 do
    local ast_x = screen_width / 2
    local ast_y = screen_height / 2
    while (ast_x > (screen_width / 2) - G.SAFE_ZONE and ast_x < (screen_width / 2) + G.SAFE_ZONE) and (ast_y > (screen_height / 2) - G.SAFE_ZONE and ast_y < (screen_height / 2) + G.SAFE_ZONE) do
      ast_x = math.random(G.LEFT_WALL, G.RIGHT_WALL)
      ast_y = math.random(G.BOTTOM_WALL, G.TOP_WALL)
    end
    local fuel = Asteroid:new( "tritium_big", ast_x, ast_y, 0, 300, math.random(-G.LEVEL_SHUFFLE_V, G.LEVEL_SHUFFLE_V), math.random(-G.LEVEL_SHUFFLE_V, G.LEVEL_SHUFFLE_V), 0.1 )
    table.insert( Asteroids, fuel)
    table.insert( Fuel_Asteroids, fuel)
  end

  star_background_1 = imageToCanvas( "Assets/big-stars-splash.png" )
  warpin_sound = love.audio.newSource("Assets/Sounds/whooshin.mp3", "static")

  Score_Image =  imageToCanvas( "Assets/fuelBig.png" )
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
  love.graphics.circle("fill", 0, 0, 25, 50)
  
  for i = 1, #Asteroids do
    local a = Asteroids[ i ]
    a:draw()
  end

  for i = 1, #Bullets do
    local b = Bullets[ i ]
    love.graphics.draw( Geraldo.decal, b.x + G.BULLET_SIZE / 2, b.y + G.BULLET_SIZE / 2, b.rotation, G.BULLET_SIZE, G.BULLET_SIZE, Geraldo.decal:getWidth() / 2, Geraldo.decal:getHeight() / 2 )
  end
end

function G.update( dt )
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

    -- Check score
    if Level_Score >= 3 then
      Level_Score = 0
      Transition:warpTo( "Title_Screen", 8.26 )
      local into_lightspeed = love.audio.newSource("Assets/Sounds/sci-fi-chargeup.mp3", "static")
      into_lightspeed:play()
    end
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
end

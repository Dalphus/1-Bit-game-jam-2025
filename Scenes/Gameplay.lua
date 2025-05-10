require( "helpers" )
require( "UI.Button" )
require( "Player" )
require( "Asteroids" )

-- Globals
Geraldo = Player
Bullets = {}
Asteroids = {}
Screen_Covered = false

-- Constants
BULLET_LIFETIME = 1
BULLET_SIZE = 2
PINBALL_COEFFICIENT = 10
SCORE_SIZE = 50
PARALLAX_CONSTANT = 0.1
LEFT_WALL = -7000
RIGHT_WALL = 7000
TOP_WALL = 7000
BOTTOM_WALL = -7000
WALL_DENSITY = 50
WALL_SHUFFLE = 300

Gameplay = {
  load = function()
    Asteroids = {}
    
    Asteroid:load()
    Geraldo = Player:new( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )

    table.insert( Asteroids, Asteroid:new( "normal_big", 100, 100, 0, 500, 10, 10, 0.1 ))
    table.insert( Asteroids, Asteroid:new( "tritium_big", -300, -300, 0, 300, 0, 0, 0, 0.1))
    table.insert( Asteroids, Asteroid:new( "tritium_big", -1300, -300, 0, 300, 0, 0, 0, 0.1))
    table.insert( Asteroids, Asteroid:new( "tritium_big", -300, -1300, 0, 300, 0, 0, 0, 0.1))

    star_background_1 = imageToCanvas( "Assets/big-stars-splash.png" )

    Score_Image =  imageToCanvas( "Assets/fuelBig.png" )
    sw, sh = Score_Image:getDimensions()

    -- top border
    for i = 1, WALL_DENSITY do
      local offset = (love.math.random() - 0.5) * WALL_SHUFFLE
      table.insert( Asteroids, Asteroid:new( "normal_big", offset + LEFT_WALL + ((RIGHT_WALL - LEFT_WALL) * i / WALL_DENSITY), offset + TOP_WALL, 0, 500, 0, 0, 0, 100))
    end

    -- left border
    for i = 1, WALL_DENSITY do
      local offset = (love.math.random() - 0.5) * WALL_SHUFFLE
      table.insert( Asteroids, Asteroid:new( "normal_big", offset + LEFT_WALL, offset + BOTTOM_WALL + ((TOP_WALL - BOTTOM_WALL) * i / WALL_DENSITY), 0, 500, 0, 0, 0, 100))
    end

    -- bottom border
    for i = 1, WALL_DENSITY do
      local offset = (love.math.random() - 0.5) * WALL_SHUFFLE
      table.insert( Asteroids, Asteroid:new( "normal_big", offset + LEFT_WALL + ((RIGHT_WALL - LEFT_WALL) * i / WALL_DENSITY), offset + BOTTOM_WALL, 0, 500, 0, 0, 0, 100))
    end

    -- right border
    for i = 1, WALL_DENSITY do
      local offset = (love.math.random() - 0.5) * WALL_SHUFFLE
      table.insert( Asteroids, Asteroid:new( "normal_big", offset + RIGHT_WALL, offset + BOTTOM_WALL + ((TOP_WALL - BOTTOM_WALL) * i / WALL_DENSITY), 0, 500, 0, 0, 0, 100))
    end
  end,

  mousepressed = function( x, y, button )
    if button == 1 then
      table.insert( Bullets, Geraldo:fire() )
    end
  end,

  draw = function()
    local bg_offset_x = -1250 -- Geraldo.x - (Geraldo.x % 2500) - (love.graphics.getWidth()/2)
    local bg_offset_y = -1250 -- Geraldo.y - (Geraldo.y % 2500) - (love.graphics.getHeight()/2)
    
    -- Should look into a way to get this to repeat
    -- paralax very slow section
    Camera:camOffset(PARALLAX_CONSTANT * 0.1)
    Camera:center( Geraldo.x, Geraldo.y, PARALLAX_CONSTANT * 0.1)
    love.graphics.draw(star_background_1, bg_offset_x - 200, bg_offset_y, 0, 5, 5)

    -- paralax slow section
    Camera:camOffset(PARALLAX_CONSTANT)
    Camera:center( Geraldo.x, Geraldo.y, PARALLAX_CONSTANT )
    love.graphics.draw(star_background_1, bg_offset_x, bg_offset_y - 250, 0, 5, 5)

    -- paralax fast section
    Camera:camOffset(PARALLAX_CONSTANT)
    Camera:center( Geraldo.x, Geraldo.y, PARALLAX_CONSTANT )
    love.graphics.draw(star_background_1, bg_offset_x, bg_offset_y, 0, 5, 5)

    -- reset graphics transforms
    love.graphics.origin()
    
    -- draw collected resources
    if Level_Score > 0 then
      love.graphics.draw( Score_Image, love.graphics.getWidth() - (SCORE_SIZE * 0.6), 30, 0, SCORE_SIZE / sw, SCORE_SIZE / sh, sw / 2, sh / 2 )
      if Level_Score > 1 then
        love.graphics.draw( Score_Image, love.graphics.getWidth() - (SCORE_SIZE * 1.8), 30, 0, SCORE_SIZE / sw, SCORE_SIZE / sh, sw / 2, sh / 2 )
        if Level_Score > 2 then
          love.graphics.draw( Score_Image, love.graphics.getWidth() - (SCORE_SIZE * 3.0), 30, 0, SCORE_SIZE / sw, SCORE_SIZE / sh, sw / 2, sh / 2 )
        end
      end
    end
    
    Camera:camOffset()

    -- Fuel celebration
    if 6 > Transition_Timer and Transition_Timer > 5 then 
      local pi = math.pi -- lazy
      local cx = love.graphics.getWidth()/2
      local cy = love.graphics.getHeight()/2
      love.graphics.setLineWidth(7)
      love.graphics.line(cx, cy, cx + (6 - Transition_Timer) * 800 * math.cos(pi / 3), cy + (6 - Transition_Timer) * 800 * math.sin(pi / 3))
      love.graphics.line(cx, cy, cx + (6 - Transition_Timer) * 800 * math.cos(2 * pi / 3), cy + (6 - Transition_Timer) * 800 * math.sin(2 * pi / 3))
      love.graphics.line(cx, cy, cx + (6 - Transition_Timer) * 800 * math.cos(3 * pi / 3), cy + (6 - Transition_Timer) * 800 * math.sin(3 * pi / 3))
      love.graphics.line(cx, cy, cx + (6 - Transition_Timer) * 800 * math.cos(4 * pi / 3), cy + (6 - Transition_Timer) * 800 * math.sin(4 * pi / 3))
      love.graphics.line(cx, cy, cx + (6 - Transition_Timer) * 800 * math.cos(5 * pi / 3), cy + (6 - Transition_Timer) * 800 * math.sin(5 * pi / 3))
      love.graphics.line(cx, cy, cx + (6 - Transition_Timer) * 800 * math.cos(6 * pi / 3), cy + (6 - Transition_Timer) * 800 * math.sin(6 * pi / 3))
      love.graphics.setLineWidth(1)
    end

    Camera:center( Geraldo.x, Geraldo.y )

    Geraldo:draw()

    for i = 1, #Asteroids do
      local a = Asteroids[ i ]
      a:draw()
    end

    for i = 1, #Bullets do
      local b = Bullets[ i ]
      love.graphics.draw( Geraldo.decal, b.x + BULLET_SIZE / 2, b.y + BULLET_SIZE / 2, b.rotation, BULLET_SIZE, BULLET_SIZE, Geraldo.decal:getWidth() / 2, Geraldo.decal:getHeight() / 2 )
    end

    love.graphics.circle("fill", 0, 0, 25, 50)

    -- level transition
    if Transition_Timer > 5 then
      -- purposefully empty
    elseif Transition_Timer > 3 then
      love.graphics.origin() -- reset coordinate changes
      Camera:camOffset()
      love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 2000 * (5 - Transition_Timer)/(2), 50)
    elseif Transition_Timer > 2 then
      love.graphics.origin() -- reset coordinate changes
      love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 2000, 50)  
      Screen_Covered = true
    elseif Transition_Timer > 0 then
      love.graphics.origin() -- reset coordinate changes
      if Screen_Covered then 
        Gameplay:load() -- reset the level
        Screen_Covered = false
      end
      Camera:camOffset()
      love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 2000 * (Transition_Timer)/(2), 50)
    end
  end,

  update = function( dt )

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
        Next_Scene = Gameplay
        Transition_Timer = 6
      end
    end

    -- check health of asteroids and destroy them if needed
    for i = 1, #Asteroids do
      local a = Asteroids[ i ]
      if a.health <= 0 then
        a:destroy()
        table.remove( Asteroids, i )
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
        if a.type == "tritium_shard" then Good_Collision = true end
        table.remove( Asteroids, i )
        if Good_Collision then return end
        
        -- damage player
        Geraldo:damage( 1 )
        -- shake camera
        Camera:shake( 10, 0.5 )
        -- throw player back
        local angle = math.atan2( Geraldo.y - a.y, Geraldo.x - a.x )
        Geraldo.vx = Geraldo.vx + math.cos( angle ) * a.size * PINBALL_COEFFICIENT
        Geraldo.vy = Geraldo.vy + math.sin( angle ) * a.size * PINBALL_COEFFICIENT
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
}

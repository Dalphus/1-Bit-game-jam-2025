require( "helpers" )
require( "UI.Button" )
require( "Player" )
require( "Asteroids" )

-- Globals
Geraldo = Player
Bullets = {}
Asteroids = {}

-- Constants
BULLET_LIFETIME = 1
BULLET_SIZE = 2
PINBALL_COEFFICIENT = 10
SCORE_SIZE = 50

Gameplay = {
  load = function()
    Asteroid:load()
    Geraldo = Player:new( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )

    table.insert( Asteroids, Asteroid:new( "normal_big", 100, 100, 0, 500, 10, 10, 0.1 ))
    table.insert( Asteroids, Asteroid:new( "tritium_big", -300, -300, 0, 300, 0, 0, 0, 0.1))
    table.insert( Asteroids, Asteroid:new( "tritium_big", -1300, -300, 0, 300, 0, 0, 0, 0.1))
    table.insert( Asteroids, Asteroid:new( "tritium_big", -300, -1300, 0, 300, 0, 0, 0, 0.1))

    Score_Image =  imageToCanvas( "Assets/fuelBig.png" )
    sw, sh = Score_Image:getDimensions()
  end,

  mousepressed = function( x, y, button )
    if button == 1 then
      table.insert( Bullets, Geraldo:fire() )
    end
  end,

  draw = function()
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

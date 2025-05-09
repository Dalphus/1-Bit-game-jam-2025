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

Gameplay = {
  load = function()
    Asteroid:load()
    Geraldo = Player:new( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )

    table.insert( Asteroids, Asteroid:new( "normal_big", 100, 100, 0, 500, 10, 10, 0.1 ))
  end,

  mousepressed = function( x, y, button )
    if button == 1 then
      table.insert( Bullets, Geraldo:fire() )
    end
  end,

  draw = function()
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
        -- damage player
        Geraldo:damage( 1 )
        a:destroy()
        table.remove( Asteroids, i )
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

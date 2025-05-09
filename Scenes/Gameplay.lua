require( "helpers" )
require( "UI.Button" )
require( "Player" )
require( "Asteroids" )

Gameplay = ( function()

  local Geraldo = Player
  local bullet_size = 2
  local bullets = {}
  local asteroids = {}
    

  return {
    name = "Gameplay",

    load = function()
      Asteroid:load()
      Geraldo = Player:new( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )

      table.insert( asteroids, Asteroid:new( "normal_big", 100, 100, 0, 500, 10, 10, 0.1 ))
    end,

    mousepressed = function( x, y, button )
      if button == 1 then
        bullets[ #bullets + 1 ] = Geraldo:fire()
      end
    end,

    draw = function()
      Main_Camera:center(Geraldo.x, Geraldo.y)
      
      Geraldo:draw()

      for i = 1, #asteroids do
        local a = asteroids[ i ]
        a:draw()
      end

      for i = 1, #bullets do
        local b = bullets[ i ]
        love.graphics.draw( Geraldo.decal, b.x + bullet_size / 2, b.y + bullet_size / 2, b.rotation, bullet_size, bullet_size, Geraldo.decal:getWidth() / 2, Geraldo.decal:getHeight() / 2 )
      end

      love.graphics.circle("fill", 0, 0, 25, 50)
    end,

    update = function( dt )
      Geraldo:update( dt )

      for i = 1, #asteroids do
        local a = asteroids[ i ]
        a:update( dt )
      end

      for i in pairs( bullets ) do
        local b = bullets[ i ]
        b.x = b.x + b.vx * dt
        b.y = b.y + b.vy * dt
        b.lifetime = b.lifetime - dt
        if b.lifetime <= 0 then
          table.remove( bullets, i )
        end
      end
    end,
  }
end)()

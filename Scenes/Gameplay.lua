require( "helpers" )
require( "UI.Button" )
require( "Player" )
require( "Asteroids" )

Geraldo = Player
Bullets = {}
Asteroids = {}

-- Constants
BULLET_LIFETIME = 1
BULLET_SIZE = 2

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
    Main_Camera:center(Geraldo.x, Geraldo.y)
    
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

Asteroid = {}
Asteroid.__index = Asteroid

Asteroid.images = {}

function Asteroid:load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  Asteroid.images = {
    normal_big =     imageToCanvas( "Assets/meteorBIG.png" ),
    normal_small_1 = imageToCanvas( "Assets/fragmentOne.png" ),
    normal_small_2 = imageToCanvas( "Assets/fragmentTwo.png" ),
    normal_small_3 = imageToCanvas( "Assets/fragmentThree.png" ),
    tritium_big =    imageToCanvas( "Assets/fuelBig.png" ),
  }
end

function Asteroid:new( _type, _x, _y, _rotation, _size, _vx, _vy, _va, _health )
  local asteroid = {
    type = _type or "normal_big",
    x = _x or 0,
    y = _y or 0,
    rotation = _rotation or 0,
    size = _size or 50,
    vx = _vx or 0,
    vy = _vy or 0,
    va = _va or 0,
    health = _health or 1,
    image = Asteroid.images[ _type ] or Asteroid.images[ "normal_big" ],
  }

  setmetatable( asteroid, Asteroid )
  return asteroid
end

function Asteroid:damage( amount )
  self.health = self.health - amount
  -- play sound of some sort
end

function Asteroid:destroy()
  if self.type == "normal_big" then
    table.insert( Asteroids, Asteroid:new( "normal_small_1", self.x, self.y, 0, 100, 10, 10, 0.1 ))
    table.insert( Asteroids, Asteroid:new( "normal_small_2", self.x, self.y, 0, 100, -10, -10, -0.1 ))
    table.insert( Asteroids, Asteroid:new( "normal_small_3", self.x, self.y, 0, 100, -10, 10, -0.1 ))
  end
  -- play sound of some sort
  -- drop collectibles
end

function Asteroid:draw()
  useColor1()
  local w, h = self.image:getDimensions()
  love.graphics.draw( self.image, self.x, self.y, self.rotation, self.size / w, self.size / h, w / 2, h / 2 )
  love.graphics.circle( "line", self.x, self.y, self.size / 2 )
end

function Asteroid:update( dt )
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
  self.rotation = self.rotation + self.va * dt
  self.rotation = self.rotation % ( math.pi * 2 )
end

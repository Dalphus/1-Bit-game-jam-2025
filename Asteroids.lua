Asteroid = {}
Asteroid.__index = Asteroid

Asteroid.images = {
  normal_big =     love.graphics.newImage( "Assets/meteorBIG.png" ),
  normal_small_1 = love.graphics.newImage( "Assets/fragmentOne.png" ),
  normal_small_2 = love.graphics.newImage( "Assets/fragmentTwo.png" ),
  normal_small_3 = love.graphics.newImage( "Assets/fragmentThree.png" ),
  tritium_big =    love.graphics.newImage( "Assets/fuelBig.png" ),
}

function Asteroid:new( _type, _x, _y, _rotation, _size, _vx, _vy, _va )
  local asteroid = {
    type = _type or "normal_big",
    x = _x or 0,
    y = _y or 0,
    rotation = _rotation or 0,
    size = _size or 50,
    vx = _vx or 0,
    vy = _vy or 0,
    va = _va or 0
  }

  setmetatable( asteroid, Asteroid )
  return asteroid
end

function Asteroid:draw()
  useColor1()
  local image = Asteroid.images[ self.type ]
  love.graphics.draw( image, self.x, self.y, self.rotation, self.size / 100, self.size / 100, self.image:getWidth() / 2, self.image:getHeight() / 2 )
  love.graphics.circle( "line", self.x, self.y, self.size / 2 )
end

function Asteroid:update( dt )
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
  self.rotation = self.rotation + self.va * dt
  self.rotation = self.rotation % ( math.pi * 2 )
end

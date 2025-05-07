Player = {}
Player.__index = Player

function Player:new( x, y )
  local player = {
    x = x or 0,
    y = y or 0,
    radius = 20,
    speed = 0,
    heading = 0,
    acceleration = 100,
    rotation = 0,
  }
  setmetatable(player, self)
  return player
end

function Player:draw()
  useColor1()
  love.graphics.circle("fill", self.x, self.y, self.radius)
  useColor2()
  local offset_vector = math.min( self.radius / 2, 20 )
  local offset_x = math.cos(self.rotation) * ( self.radius - offset_vector )
  local offset_y = math.sin(self.rotation) * ( self.radius - offset_vector )

  love.graphics.circle("fill", self.x + offset_x, self.y + offset_y, offset_vector )
end

function Player:update(dt)

  if love.keyboard.isDown( "w ") or love.keyboard.isDown( "up" ) then
    local theta = self.
  end

  self.x = self.x + math.cos( self.heading ) * self.speed * dt
  self.y = self.y + math.sin( self.heading ) * self.speed * dt
end

Player = {}
Player.__index = Player

function Player:new(x, y, radius, acceleration)
  local player = {
    x = x or 0,
    y = y or 0,
    radius = radius or 20,
    vx = 0,
    vy = 0,
    acceleration = 100 or acceleration,
    rotation = math.pi / 2,
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

  -- w goes forward, a and d strafe left and right
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    self.vx = self.vx + ( self.acceleration * math.cos( self.rotation ) * dt )
    self.vy = self.vy + ( self.acceleration * math.sin( self.rotation ) * dt )
  end

  local theta = math.atan2( self.vy, self.vx )
  self.vx = self.vx - ( 1 * math.cos( theta ) * dt )
  self.vy = self.vy - ( 1 * math.sin( theta ) * dt )

  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
end

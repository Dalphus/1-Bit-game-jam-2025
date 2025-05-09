Player = {}
Player.__index = Player

function Player:new( x, y )
  local player = {
    x = x or 0,
    y = y or 0,
    rotation = 0,
    vx = 0,
    vy = 0,
    acceleration = 200,
    max_speed = 200,
    dampening = 0.7,
    particles = {},
  }
  local image, canvas
  image = love.graphics.newImage( "Assets/shipBIG.png" )
  local scale = 140
  canvas = love.graphics.newCanvas( scale, scale )
  love.graphics.setCanvas( canvas )
  love.graphics.setColor( 1, 1, 1 )
  local w, h = image:getWidth(), image:getHeight()
  love.graphics.draw( image, scale / 2, scale / 2, math.pi / 2, scale / w, scale / h, w / 2, h / 2 )
  love.graphics.setCanvas()

  player.image = canvas

  image = love.graphics.newImage( "Assets/pixel.png" )
  scale = 8
  canvas = love.graphics.newCanvas( scale, scale )
  love.graphics.setCanvas( canvas )
  love.graphics.setColor( 1, 1, 1 )
  love.graphics.draw( image, 0, 0, 0, scale, scale )
  love.graphics.setCanvas()

  player.decal = canvas

  setmetatable( player, Player )
  return player
end

function Player:draw()
  useColor1()
  -- love.graphics.circle( "line", self.x, self.y, self.image:getWidth() / 2 )
  love.graphics.draw( self.image, self.x, self.y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2 )

  for i in pairs( self.particles ) do
    local p = self.particles[ i ]
    local size = p.lifetime * 10
    love.graphics.draw( self.decal, p.x + size / 2, p.y + size / 2, p.rotation, size, size, self.decal:getWidth() / 2, self.decal:getHeight() / 2 )
  end
end

function Player:fire()
  local bullet = {
    x = self.x + math.cos( self.rotation ) * 60,
    y = self.y + math.sin( self.rotation ) * 60,
    rotation = self.rotation,
    lifetime = 1,
    vx = self.vx + math.cos( self.rotation ) * 1000,
    vy = self.vy + math.sin( self.rotation ) * 1000
  }
  return bullet
end

function Player:update(dt)

  for i in pairs(self.particles) do
    local particle = self.particles[i]
    particle.x = particle.x + particle.vx * dt
    particle.y = particle.y + particle.vy * dt
    particle.lifetime = particle.lifetime - dt
    if particle.lifetime <= 0 then
      table.remove( self.particles, i )
    end
  end

  --local mouse_x, mouse_y = love.mouse.getPosition()
  --local dx, dy = mouse_x - self.x, mouse_y - self.y
  --self.rotation = math.atan2( dy, dx )
  self.rotation = Main_Camera:pointingAngle()

  if love.keyboard.isDown( "w" ) or love.keyboard.isDown( "up" ) then
    self.vx = self.vx + math.cos( self.rotation ) * self.acceleration * dt * 2
    self.vy = self.vy + math.sin( self.rotation ) * self.acceleration * dt * 2

    table.insert( self.particles, newParticle( self.x, self.y, self.vx, self.vy, self.rotation + math.pi, .2 ))
  else
    self.vx = self.vx - self.vx * self.dampening * dt
    self.vy = self.vy - self.vy * self.dampening * dt
  end
  if love.keyboard.isDown( "a" ) or love.keyboard.isDown( "left" ) then
    local rotation = self.rotation - math.pi / 2.4

    self.vx = self.vx + math.cos( rotation ) * self.acceleration * dt
    self.vy = self.vy + math.sin( rotation ) * self.acceleration * dt

    table.insert( self.particles, newParticle( self.x, self.y, self.vx, self.vy, rotation + math.pi, .1 ))
  end
  if love.keyboard.isDown( "d" ) or love.keyboard.isDown( "right" ) then
    local rotation = self.rotation + math.pi / 2.4

    self.vx = self.vx + math.cos( rotation ) * self.acceleration * dt
    self.vy = self.vy + math.sin( rotation ) * self.acceleration * dt

    table.insert( self.particles, newParticle( self.x, self.y, self.vx, self.vy, rotation + math.pi, .1 ))
  end

  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt

end

function newParticle( _x, _y, _vx, _vy, _rotation, _lifetime )
  return {
    x = _x + math.cos( _rotation ) * 70,
    y = _y + math.sin( _rotation ) * 70,
    vx = _vx + math.cos( _rotation ) * 700,
    vy = _vy + math.sin( _rotation ) * 700,
    rotation = _rotation,
    lifetime = _lifetime,
  }
end

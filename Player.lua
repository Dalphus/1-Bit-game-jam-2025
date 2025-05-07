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
    dampening = 0.5,
    particles = {},
  }
  local ship_image = love.graphics.newImage( "Assets/shipBIG.png" )
  local ship_canvas = love.graphics.newCanvas( 320, 320 )
  love.graphics.setCanvas( ship_canvas )
  love.graphics.setColor( 1, 1, 1 )
  love.graphics.draw( ship_image, ship_image:getWidth() / 2, ship_image:getHeight() / 2, math.pi / 2, 1, 1, ship_image:getWidth() / 2, ship_image:getHeight() / 2 )
  love.graphics.setCanvas()

  player.image = ship_canvas

  local decal_image = love.graphics.newImage( "Assets/pixel.png" )
  local decal_canvas = love.graphics.newCanvas( 25, 25 )
  love.graphics.setCanvas( decal_canvas )
  love.graphics.setColor( 1, 1, 1 )
  love.graphics.draw( decal_image, 0, 0, 0, 25, 25 )
  love.graphics.setCanvas()

  player.decal = decal_canvas

  setmetatable(player, Player)
  return player
end

function Player:draw()
  useColor1()
  love.graphics.circle( "line", self.x, self.y, self.image:getWidth() / 2 )
  love.graphics.draw( self.image, self.x, self.y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2 )

  for i in pairs( self.particles ) do
    local particle = self.particles[ i ]
    -- love.graphics.circle( "fill", particle.x, particle.y, particle.lifetime * 25 )
    love.graphics.draw( self.decal, particle.x, particle.y )
  end
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

  local mouse_x, mouse_y = love.mouse.getPosition()
  local dx, dy = mouse_x - self.x, mouse_y - self.y
  self.rotation = math.atan2( dy, dx )

  if love.keyboard.isDown( "w" ) or love.keyboard.isDown( "up" ) then
    self.vx = self.vx + math.cos( self.rotation ) * self.acceleration * dt
    self.vy = self.vy + math.sin( self.rotation ) * self.acceleration * dt

    table.insert( self.particles, newParticle( self.x, self.y, self.vx, self.vy, self.rotation + math.pi, .3 ))
  else
    self.vx = self.vx - self.vx * self.dampening * dt
    self.vy = self.vy - self.vy * self.dampening * dt
  end
  if love.keyboard.isDown( "a" ) or love.keyboard.isDown( "left" ) then
    local rotation = self.rotation - math.pi / 2.4

    self.vx = self.vx + math.cos( rotation ) * self.acceleration * dt
    self.vy = self.vy + math.sin( rotation ) * self.acceleration * dt

    table.insert( self.particles, newParticle( self.x, self.y, self.vx, self.vy, rotation + math.pi, .2 ))
  end
  if love.keyboard.isDown( "d" ) or love.keyboard.isDown( "right" ) then
    local rotation = self.rotation + math.pi / 2.4

    self.vx = self.vx + math.cos( rotation ) * self.acceleration * dt
    self.vy = self.vy + math.sin( rotation ) * self.acceleration * dt

    table.insert( self.particles, newParticle( self.x, self.y, self.vx, self.vy, rotation + math.pi, .2 ))
  end

  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt

end

function newParticle( _x, _y, _vx, _vy, _rotation, _lifetime )
  return {
    x = _x + math.cos( _rotation ) * 40,
    y = _y + math.sin( _rotation ) * 40,
    vx = _vx + math.cos( _rotation ) * 200,
    vy = _vy + math.sin( _rotation ) * 200,
    lifetime = _lifetime,
  }
end

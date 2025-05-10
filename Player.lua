require( "helpers" )

-- Constants
Player = {
  SIZE = 140,
  FORWARD_ACCELERATION = 400,
  STRAFE_ACCELERATION = 300,
  STRAFE_VECTOR_OFFSET = math.pi / 2.4, -- pi / 2 is perpendicular to the forward vector
  DAMPENING = 0.7,
  MAX_SPEED = 200, -- not implemented yet
  PARTICLE_LIFETIME = 0.2,
  PARTICLE_SIZE = 10, -- multiplied by lifetime
  PARTICLE_DISTANCE = 70,
  PARTICLE_SPEED = 700,
}
Player.__index = Player

function Player:new( x, y )
  local player = {
    x = x or 0,
    y = y or 0,
    rotation = 0,
    vx = 0,
    vy = 0,
    particles = {},
    health = 10,
  }

  player.image = imageToCanvas( "Assets/shipNEW.png", Player.SIZE, math.pi / 2 )
  player.decal = imageToCanvas( "Assets/pixel.png", 8 )
  player.shoot_audio = love.audio.newSource("Assets/Sounds/gun.mp3", "static")
  player.shoot_audio:setVolume(0.5)

  setmetatable( player, Player )
  return player
end

function Player:draw()
  useColor1()
  love.graphics.draw( self.image, self.x, self.y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2 )

  for i in pairs( self.particles ) do
    local p = self.particles[ i ]
    local size = p.lifetime * Player.PARTICLE_SIZE
    love.graphics.draw( self.decal, p.x + size / 2, p.y + size / 2, p.rotation, size, size, self.decal:getWidth() / 2, self.decal:getHeight() / 2 )
  end
end

function Player:damage( amount )
  self.health = self.health - amount
  -- play sound of some sort
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
  local shoot_audio = self.shoot_audio:clone()
  shoot_audio:play()
  return bullet
end

function Player:update( dt )

  for i = 1, #self.particles do
    local particle = self.particles[ i ]
    if not particle then break end -- bandaid, find cause later
    particle.x = particle.x + particle.vx * dt
    particle.y = particle.y + particle.vy * dt
    particle.lifetime = particle.lifetime - dt
    if particle.lifetime <= 0 then
      table.remove( self.particles, i )
      i = i - 1
    end
  end

  --local mouse_x, mouse_y = love.mouse.getPosition()
  --local dx, dy = mouse_x - self.x, mouse_y - self.y
  --self.rotation = math.atan2( dy, dx )
  self.rotation = Camera:pointingAngle()

  if love.keyboard.isDown( "w" ) or love.keyboard.isDown( "up" ) then
    self.vx = self.vx + math.cos( self.rotation ) * Player.FORWARD_ACCELERATION * dt
    self.vy = self.vy + math.sin( self.rotation ) * Player.FORWARD_ACCELERATION * dt

    table.insert( self.particles, self:newParticle( self.rotation + math.pi, Player.PARTICLE_LIFETIME ))
  else
    self.vx = self.vx - self.vx * Player.DAMPENING * dt
    self.vy = self.vy - self.vy * Player.DAMPENING * dt
  end
  if love.keyboard.isDown( "a" ) or love.keyboard.isDown( "left" ) then
    local rotation = self.rotation - Player.STRAFE_VECTOR_OFFSET

    self.vx = self.vx + math.cos( rotation ) * Player.STRAFE_ACCELERATION * dt
    self.vy = self.vy + math.sin( rotation ) * Player.STRAFE_ACCELERATION * dt

    table.insert( self.particles, self:newParticle( rotation + math.pi, Player.PARTICLE_LIFETIME / 2 ))
  end
  if love.keyboard.isDown( "d" ) or love.keyboard.isDown( "right" ) then
    local rotation = self.rotation + Player.STRAFE_VECTOR_OFFSET

    self.vx = self.vx + math.cos( rotation ) * Player.STRAFE_ACCELERATION * dt
    self.vy = self.vy + math.sin( rotation ) * Player.STRAFE_ACCELERATION * dt

    table.insert( self.particles, self:newParticle( rotation + math.pi, Player.PARTICLE_LIFETIME / 2 ))
  end

  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt

end

function Player:newParticle( _rotation, _lifetime )
  return {
    x = self.x + math.cos( _rotation ) * Player.PARTICLE_DISTANCE,
    y = self.y + math.sin( _rotation ) * Player.PARTICLE_DISTANCE,
    vx = self.vx + math.cos( _rotation ) * Player.PARTICLE_SPEED,
    vy = self.vy + math.sin( _rotation ) * Player.PARTICLE_SPEED,
    rotation = _rotation,
    lifetime = _lifetime,
  }
end

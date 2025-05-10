Camera = {
  impact = 0,
  cooldown = 0,
  duration = 0,
  shake_x = 0,
  shake_y = 0,
}
Camera.__index = Camera

function Camera:load()
  self.window_height = love.graphics.getHeight()
  self.window_width = love.graphics.getWidth()
end

function Camera:shake(_impact, _cooldown)
  self.impact = _impact
  self.cooldown = _cooldown
  self.duration = _cooldown
end

function Camera:update(dt)
  if self.cooldown > 0 then
    local scale = self.impact * self.cooldown / self.duration
    self.shake_x, self.shake_y = math.random( -scale, scale ), math.random( -scale, scale )

    self.cooldown = self.cooldown - dt
  end
end

function Camera:draw()
  if self.cooldown > 0 then
    love.graphics.translate( self.shake_x, self.shake_y )
  end
end

function Camera:center(_x, _y, _offset)
  local offset = _offset or 1
  love.graphics.translate(((self.window_width/2) - _x) * offset, ((self.window_height/2) - _y) * offset)
end

function  Camera:camOffset(_offset)
  local offset = _offset or 1
  local mouse_x, mouse_y = love.mouse.getPosition()
  love.graphics.translate((((self.window_width/2) - mouse_x) * 0.33) * offset, (((self.window_height/2) - mouse_y) * 0.33) * offset)
end

function Camera:pointingAngle()
  local mouse_x, mouse_y = love.mouse.getPosition()
  return math.atan2(((self.window_height/2) - mouse_y) * 0.5, ((self.window_width/2) - mouse_x) * 0.5) - math.pi
end

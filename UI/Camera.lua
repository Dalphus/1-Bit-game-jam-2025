Camera = {}
Camera.__index = Camera

function Camera:new()
  local camera = {
    impact = 0,
    cooldown = 0,
    duration = 0,
  }

  camera.window_height = love.graphics.getHeight()
  camera.window_width = love.graphics.getWidth()

  setmetatable(camera, Camera)
  return camera
end

function Camera:applyShake(_impact, _cooldown)
  self.impact = _impact
  self.cooldown = _cooldown
  self.duration = _cooldown
end

function Camera:cool(dt)
  self.cooldown = self.cooldown - dt
  if self.cooldown < 0 then
    self.impact = 0
    self.cooldown = 0
    self.duration = 0
    return
  end
end

function Camera:shake()
  if self.cooldown <= 0 then return end
  love.graphics.translate(math.random(-self.impact * (self.cooldown/self.duration), self.impact * (self.cooldown/self.duration)), math.random(-self.impact * (self.cooldown/self.duration), self.impact * (self.cooldown/self.duration)))
end

function Camera:center(_x, _y)
  love.graphics.translate((self.window_width/2) - _x, (self.window_height/2)-_y)
  local mouse_x, mouse_y = love.mouse.getPosition()
  love.graphics.translate(((self.window_width/2) - mouse_x) * 0.5, ((self.window_height/2) - mouse_y) * 0.5)
end





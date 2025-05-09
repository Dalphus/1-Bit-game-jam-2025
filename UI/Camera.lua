Camera = {}
Camera.__index = Camera

function Camera:new()
  local camera = {
    impact = 0,
    cooldown = 0,
    duration = 0,
  }

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





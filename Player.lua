Player = {}
Player.__index = Player

function Player:new(x, y, radius)
  local player = {
    x = x or 0,
    y = y or 0,
    radius = radius or 20,
    speed = 200,
    rotation = 0,
  }
  setmetatable(player, self)
  return player
end

function Player:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(0, 0, 0)
end

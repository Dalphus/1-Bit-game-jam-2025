Button = {}
Button.__index = Button

function Button:new( _x, _y, _width, _height )
  local button = {
    x = _x,
    y = _y,
    width = _width,
    height = _height,
    enabled = true,
  }
  setmetatable(button, Button)
  return button
end

function Button:draw()
  if not self.enabled then return end

  local invert = false
  if mouseWithin(self) and not self.heldAction then
    if love.mouse.isDown( 1 ) then
      love.graphics.rectangle("fill", self.true_x - (self.width * 0.05), self.true_y - (self.height * 0.05), self.width * 1.1, self.height * 1.1)
    else
      love.graphics.rectangle("fill", self.true_x, self.true_y, self.width, self.height)
      love.graphics.setColor(1 - self.r, 1 - self.g, 1 - self.b)
      love.graphics.rectangle("fill", self.true_x + 2, self.true_y + 2, self.width - 4, self.height - 4)
      invert = true
    end
  else
    love.graphics.rectangle("fill", self.true_x, self.true_y, self.width, self.height)
  end
end

function Button:mouseEvent()
  if not self.enabled then return end
  if mouseWithin(self) then
    if self.clickAction then
      self.clickAction(unpack(self.cmdArgs))
      return true
    end
  end
end

function Button:setFunction(_click_action, ...)
  self.click_action = _click_action
  self.args = {...}
end

function Button:setText( _text )
  local font = love.graphics.getFont()
  self.textObject = love.graphics.newText( font, { { 1,1,1 }, _text } )
end

function mouseWithin(self)
  return ((love.mouse.getX() > self.true_x) and (love.mouse.getX() < (self.true_x + self.width))) and ((love.mouse.getY() > self.true_y) and (love.mouse.getY() < (self.true_y + self.height)))
end

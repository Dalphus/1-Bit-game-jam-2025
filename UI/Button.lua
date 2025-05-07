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
  if self:isHovered() and not self.heldAction then
    if love.mouse.isDown( 1 ) then
      love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height )
    else
      love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height )

      love.graphics.rectangle("fill", self.x + 2, self.y + 2, self.width - 4, self.height - 4)
      invert = true
    end
  else
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  end

  love.graphics.draw( self.text )
end

function Button:mouseEvent()
  if not self.enabled then return end
  if self:isHovered() then
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
  self.text = love.graphics.newText( font, { { 1,1,1 }, _text } )
end

function Button:isHovered()
  local mouse_x, mouse_y = love.mouse.getPosition()
  return mouse_x >= self.x and mouse_x <= self.x + self.width and
         mouse_y >= self.y and mouse_y <= self.y + self.height
end

Button = {}
Button.__index = Button

function Button:new(_x, _y, _width, _height, _anchor)
  local button = {
    ["x"] = _x or 0,
    ["y"] = _y or 0,
    ["true_x"] = _x or 0,
    ["true_y"] = _y or 0,
    ["width"] = _width or 0,
    ["height"] = _height or 0,
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["anchor"] = _anchor or "TLEFT",
    ["clickAction"] = nil,
    ["cmdArgs"] = nil,
    ["textObject"] = nil,
    ["heldAction"] = nil,
  }
  setmetatable(button, Button)
  return button
end

function Button:draw()
  if self.anchor == "BRIGHT" then
    coordBottomRight(self)
  elseif self.anchor == "BCENT" then
    coordBottomCenter(self)
  else
    coordTopLeft(self)
  end
  
  if self.heldAction then
    love.graphics.setColor(1, 0, 0)
  else
    love.graphics.setColor(self.r, self.g, self.b)
  end

  
  love.graphics.rectangle("fill", self.true_x, self.true_y, self.width, self.height)

  -- recolor button when user is hovering/clicking 
  if mouseWithin(self) and not self.heldAction then
    if love.mouse.isDown( 1 ) then
      love.graphics.setColor(self.r * 0.2, self.g * 0.2, self.b * 0.2)
    else
      love.graphics.setColor(self.r * 0.8, self.g * 0.8, self.b *0.8)
    end
    love.graphics.rectangle("fill", self.true_x + 2, self.true_y + 2, self.width - 4, self.height - 4)
  end

  love.graphics.setColor(1, 1, 1)
  if self.textObject then
    love.graphics.draw(self.textObject, self.true_x + (self.width/2) - (self.textObject:getWidth()/2), self.true_y + (self.height/2) - (self.textObject:getHeight()/2))
  end
end

function Button:mouseEvent()
  if love.mouse.isDown( 1 ) and mouseWithin(self) then
    if self.clickAction then
      self.clickAction(unpack(self.cmdArgs))
    end
  end
end

function Button:setColor(_r, _g, _b)
  self.r = _r
  self.g = _g
  self.b = _b
end

function Button:setFunction(_clickAction, _toggle, ...)
  self.clickAction = _clickAction
  self.toggle = _toggle
  self.cmdArgs = {...}
end

function Button:coolDown(dt)
  if self.heldAction then
    coroutine.resume(self.heldAction)
    if coroutine.status(self.heldAction) == 'dead' then
      self.heldAction = nil
    end
  end
end

function Button:setText(_text)
  local font = love.graphics.getFont()
  self.textObject = love.graphics.newText(font, {{1,1,1}, _text})
end

function mouseWithin(self)
  return ((love.mouse.getX() > self.true_x) and (love.mouse.getX() < (self.true_x + self.width))) and ((love.mouse.getY() > self.true_y) and (love.mouse.getY() < (self.true_y + self.height)))
end

function coordBottomRight(self)
  local window_height = love.graphics.getHeight()
  local window_width = love.graphics.getWidth()
  self.true_x = window_width - self.width - self.x
  self.true_y = window_height - self.height - self.y
end

function coordTopLeft(self)
  self.true_x = self.x
  self.true_y = self.y
end

function coordBottomCenter(self)
  local window_height = love.graphics.getHeight()
  local window_width = love.graphics.getWidth()
  self.true_x = (window_width/2) - (self.width/2) - self.x
  self.true_y = window_height - self.height - self.y
end
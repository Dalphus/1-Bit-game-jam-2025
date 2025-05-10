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
    ["enabled"] = true,
    ["audio"] = nil
  }
  setmetatable(button, Button)
  return button
end

function Button:draw()
  if not self.enabled then return end

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

  local invert = false
  -- recolor button when user is hovering/clicking 
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

  if self.textObject then
    if invert then
      love.graphics.setColor(self.r, self.g, self.b)
    else
      love.graphics.setColor(1 - self.r, 1 - self.g, 1 - self.b)
    end
    love.graphics.draw(self.textObject, self.true_x + (self.width/2) - (self.textObject:getWidth()/2), self.true_y + (self.height/2) - (self.textObject:getHeight()/2))
  end
end

function Button:mouseEvent()
  if not self.enabled then return end
  if mouseWithin(self) then
    if self.audio then love.audio.play(self.audio) end
    if self.clickAction then
      self.clickAction(unpack(self.cmdArgs))
      return true
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

function Button:disable()
  self.enabled = false
end

function Button:isEnabled()
  return self.enabled
end

function Button:setAudio(_audio)
  self.audio = _audio
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

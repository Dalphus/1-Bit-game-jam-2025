Transition = {
  fade_in_duration = 0,
  fade_out_duration = 0,
  fade_color = { 0, 0, 0 },
  timer = -1,
  is_fade = false,
  is_warp = false,
}
Next_Scene = nil
Previous_Scene = nil


function Transition:update( dt )
  if self.timer > 0 then
    self.timer = self.timer - dt
    
    if self.is_fade then

      local alpha = 0
      if self.timer > self.fade_out_duration then
        alpha = 1 - (self.timer - self.fade_out_duration) / self.fade_in_duration

      elseif self.timer > 0 then
        if Next_Scene ~= nil then
          Previous_Scene = Active_Scene
          Active_Scene = Next_Scene
          Next_Scene = nil
        end

        alpha = (self.timer / self.fade_out_duration)
      else
        self.is_fade = false
      end

      self.fade_color[ 4 ] = alpha
    elseif self.is_warp then
    end
  end
end

function Transition:draw()
  love.graphics.origin()

  if self.timer > 0 then
    if self.is_warp then
      local w, h = love.graphics.getDimensions()
      useColor1()
      
      Camera:camOffset()

      -- lines
      if 6 > self.timer and self.timer > 4 then
        love.graphics.setLineWidth( 7 )
        for i = 1, 6 do
          local x = w / 2 + ( 6 - self.timer ) * 800 * math.cos( i * math.pi / 3 )
          local y = h / 2 + ( 6 - self.timer ) * 800 * math.sin( i * math.pi / 3 )
          love.graphics.line(w / 2, h / 2, x, y)
        end
        love.graphics.setLineWidth( 1 )
      end

      if self.timer < 5 and not self.is_fade then
        self.is_fade = true
        self.fade_color = { 0, 0, 0 }
        self.fade_in_duration = 2.5
        self.fade_out_duration = 2.5
      end
      
      -- level transition
      if self.timer > 5 then
      -- left blank intentionally
      elseif self.timer > 3 then
        love.graphics.circle("fill", w / 2, h / 2, 2000 * ( 5 - self.timer ) / 2, 50 )
      elseif self.timer > 2.5 then
        love.graphics.circle("fill", w / 2, h / 2, 2000, 50 )
      else
        self.is_warp = false
        warpin_sound:play()
        -- love.graphics.origin()
        -- Camera:camOffset()
        -- love.graphics.circle("fill", w / 2, h / 2, 2000 * (self.timer)/(2), 50)
      end
    end
    if self.is_fade then
      love.graphics.origin()
      love.graphics.setColor( unpack( self.fade_color ))
      love.graphics.rectangle( "fill", 0, 0, love.graphics.getDimensions() )
    end
  end
end

function Transition:fadeTo( scene, duration, color )
  self.is_fade = true
  self.fade_color = color or Color2
  self.fade_in_duration = duration / 2
  self.fade_out_duration = duration / 2
  self.timer = duration

  if scene ~= nil then
    Next_Scene = scene
    Previous_Scene = Active_Scene
  end
end

function Transition:warpTo( scene, duration )
  self.is_warp = true
  self.timer = duration

  Next_Scene = scene
  Previous_Scene = Active_Scene
end

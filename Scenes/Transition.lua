Transition = {
  fade_in_duration = 0,
  fade_out_duration = 0,
  fade_color = { 0, 0, 0 },
  timer = -1,
  sceneChanged = false
}
Active_Scene = Title_Screen
Next_Scene = nil
Previous_Scene = nil


function Transition:update( dt )
  if self.timer > 0 then
    self.timer = self.timer - dt
    
    if self.style == "fade" then

      local alpha = 0
      if self.timer > self.fade_out_duration then
        alpha = 1 - (self.timer - self.fade_out_duration) / self.fade_in_duration

      elseif self.timer > 0 then
        if not self.sceneChanged then
          self.sceneChanged = true
          Previous_Scene = Active_Scene
          Active_Scene = Next_Scene
        end

        alpha = (self.timer / self.fade_out_duration)
      end

      self.fade_color[ 4 ] = alpha
    elseif self.style == "warp" then
    end
  end
end

function Transition:draw()

  if self.timer > 0 then
    if self.style == "fade" then
      love.graphics.setColor( unpack( self.fade_color ))
      love.graphics.rectangle( "fill", 0, 0, love.graphics.getDimensions() )

    elseif self.style == "warp" then
      local w, h = love.graphics.getDimensions()
      useColor1()
      
      love.graphics.origin()
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
      -- level transition
      if self.timer > 5 then
      -- left blank intentionally
      elseif self.timer > 3 then
        love.graphics.circle("fill", w / 2, h / 2, 2000 * ( 5 - self.timer ) / 2, 50 )
      elseif self.timer > 2 then
        love.graphics.circle("fill", w / 2, h / 2, 2000, 50 )
        Screen_Covered = true
      else
        love.graphics.origin()
        if Screen_Covered then
          Gameplay:load() -- reset the level
          Screen_Covered = false
        end
        warpin_sound:play()
        Camera:camOffset()
        love.graphics.circle("fill", w / 2, h / 2, 2000 * (self.timer)/(2), 50)
      end
    end
  end
end

function Transition:fadeTo( scene, duration, color )
  self.style = "fade"
  self.fade_color = color or Color2
  self.fade_in_duration = duration / 2
  self.fade_out_duration = duration / 2
  self.timer = duration
  self.sceneChanged = false

  Next_Scene = scene
  Previous_Scene = Active_Scene
end

function Transition:warpTo( scene, duration )
  self.style = "warp"
  self.timer = duration
  self.sceneChanged = false

  Next_Scene = scene
  Previous_Scene = Active_Scene
end

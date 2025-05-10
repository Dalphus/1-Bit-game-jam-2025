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
  end
end

function Transition:draw()
  love.graphics.origin()
  if self.timer > 0 then
    love.graphics.setColor( unpack( self.fade_color ))
    love.graphics.rectangle( "fill", 0, 0, love.graphics.getDimensions() )
  end
end

function Transition:fadeTo( scene, duration, color )
  self.fade_color = color or Color2
  self.fade_in_duration = duration / 2
  self.fade_out_duration = duration / 2
  self.timer = duration
  self.sceneChanged = false

  Next_Scene = scene
  Previous_Scene = Active_Scene
end

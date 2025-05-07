require( "helpers" )
require( "UI/Button" )
require( "Player" )

Gameplay = ( function()
  Geraldo = Player:new( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
  
  return {
    name = "Asteroids",
    draw = function()
      Geraldo:draw()
    end,
    keypressed = function( key )
      if key == "y" then
        local image = love.graphics.newImage( "Assets/shipBIG.png" )
        local canvas = love.graphics.newCanvas( 320, 320 )
        love.graphics.setCanvas( canvas )
        love.graphics.setColor( 1, 1, 1 )
        local scale = 100 / image:getWidth()
        love.graphics.draw( image, image:getWidth() / 2, image:getHeight() / 2, math.pi / 2, scale, scale, image:getWidth() / 2, image:getHeight() / 2 )
        love.graphics.setCanvas()
        
        Geraldo.image = canvas

        local decal_image = love.graphics.newImage( "Assets/pixel.png" )
        local decal_canvas = love.graphics.newCanvas( 25, 25 )
        love.graphics.setCanvas( decal_canvas )
        love.graphics.setColor( 1, 1, 1 )
        love.graphics.draw( decal_image, 0, 0, 0, 25, 25 )
        love.graphics.setCanvas()

        Geraldo.image = decal_canvas
      end
    end,
    update = function( dt )
      Geraldo:update( dt )
    end,
  }
end)()

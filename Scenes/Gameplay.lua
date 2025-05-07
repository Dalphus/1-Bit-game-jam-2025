require( "helpers" )
require( "UI/Button" )
require( "Player" )

Gameplay = ( function()
  Geraldo = Player:new( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
  
  return {
    name = "Asteroids",
    draw = function()
    end,
    update = function( dt )
      Geraldo:update( dt )
    end,
  }
end)()

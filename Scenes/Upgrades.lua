Upgrade = {
  text = {
    "Warp successful. You've survived… for now.",
    "Press [ space ] to confirm upgrades.",
    "(  Pretend there's a really cool upgrades screen here.  )",
  },
  font_size = 40,
}

function Upgrade.load()
  Upgrade.font = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", Upgrade.font_size )
  Upgrade.font_small = love.graphics.newFont( "Assets/Fonts/joystix monospace.otf", 20 )
end

function Upgrade.update( dt )
end

function Upgrade.keypressed( key, scancode, isrepeat )
  if scancode == "space" or scancode == "return" and Transition.timer <= 0 then
    Gameplay:load()
    G.LEVEL_DENSITY = G.LEVEL_DENSITY + 200
    Transition:fadeTo( Gameplay, 3.5, { 1, 1, 1 } )
  end
end

function Upgrade.draw()
  useColor1()
  love.graphics.setFont( Upgrade.font )
  love.graphics.print( Upgrade.text[ 1 ], 25, 25 + Upgrade.font_size )
  love.graphics.print( Upgrade.text[ 2 ], 25, 25 + Upgrade.font_size * 2 )

  love.graphics.setFont( Upgrade.font_small )
  love.graphics.print( Upgrade.text[ 3 ], 25, love.graphics.getHeight() - Upgrade.font_size * 2 )
end

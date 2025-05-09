require( "helpers" )
require( "UI.Button" )

Lore = ( function()
  local font = love.graphics.getFont()
  local Lore_dump = love.graphics.newText(font, {{1,1,1}, "LORE"})
  
  return {
    name = "Lore",
    draw = function()
    end,
    1
  }
end)()

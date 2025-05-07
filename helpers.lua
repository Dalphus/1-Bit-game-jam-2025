function distance( x1, y1, x2, y2 )
  return math.sqrt(( x2 - x1 ) ^ 2 + ( y2 - y1 ) ^ 2 )
end

Color1 = { 0.31, 0.43, 0.24, 1 }
Color2 = { 0, 0, 0, 1 }

function setColor1(r, g, b, a)
  if a == nil then a = 1 end
  Color1 = { r, g, b, a }
end
function setColor2(r, g, b, a)
  if a == nil then a = 1 end
  Color2 = { r, g, b, a }
end
function useColor1()
  love.graphics.setColor( unpack( Color1 ))
end
function useColor2()
  love.graphics.setColor( unpack( Color2 ))
end

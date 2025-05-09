function distance( x1, y1, x2, y2 )
  return math.sqrt(( x2 - x1 ) ^ 2 + ( y2 - y1 ) ^ 2 )
end
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

function imageToCanvas( image, size, angle )
  if type( image ) == "string" then
    image = love.graphics.newImage( image )
  end
  size = size or image:getWidth()
  local canvas = love.graphics.newCanvas( size, size )
  love.graphics.setCanvas( canvas )
  love.graphics.setColor( 1, 1, 1 )
  local w, h = image:getDimensions()
  love.graphics.draw( image, size / 2, size / 2, angle, size / w, size / h, w / 2, h / 2 )
  love.graphics.setCanvas()
  canvas:newImageData():encode( "png", "temp.png" )
  return canvas
end

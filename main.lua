-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[ 2 ] == "vsc_debug" then
  require( "lldebugger" ).start()
end

require( "helpers" )
require( "Player" )
require( "UI.Button" )

function love.load()
  -- Set up the window
  love.window.setMode(1440, 1080, { resizable = true, vsync = false })

  -- Global Variables
  Dots = {}
  Dot_size = 40
  Selector = {
    x = 0,
    y = 0,
    is_active = false,
  }
  Color = { 0.31, 0.43, 0.24 }
  Start_button = Button:new(0, 200, 300, 200, "BCENT")
  Start_button:setFunction(function() Start_button:disable() end)
  Start_button:setText("GO")
  local font = love.graphics.getFont()
  Lore_dump = love.graphics.newText(font, {{1,1,1}, "LORE"})
  Background = { 0, 0, 0, 1}

  -- Pick random seed
  math.randomseed( os.time() )
end

function love.mousepressed( mouse_x, mouse_y, button )
  if button == 1 then
    if Start_button:isEnabled() then return end
    
    setColor1( math.random(), math.random(), math.random() )

    local is_valid = true
    local should_remove = false
    local remove_index = 0

    for i = 1, #Dots do
      local dist = distance( mouse_x, mouse_y, Dots[i].x, Dots[i].y )
      if dist < Dot_size * 2 then
        is_valid = false
        if dist < Dot_size then
          should_remove = true
          remove_index = i
        end
        break
      end
    end

    if is_valid then
      -- create a new dot
      local dot = {}
      dot.x = mouse_x
      dot.y = mouse_y
      Dots[ #Dots + 1 ] = dot
      
    elseif should_remove then
      -- remove the dot
      table.remove( Dots, remove_index )
    end

    love.mousemoved( mouse_x, mouse_y )
  end
end

function love.mousereleased( mouse_x, mouse_y, button)
  if button == 1 then
    Start_button:mouseEvent()
  end
end

function love.mousemoved( mouse_x, mouse_y, dx, dy, force )
  -- draw circle around dot under cursor
  for i = 1, #Dots do
    if distance( mouse_x, mouse_y, Dots[i].x, Dots[i].y ) <= Dot_size then
      Selector.x = Dots[i].x
      Selector.y = Dots[i].y
      Selector.is_active = true
      return
    end
  end
  Selector.is_active = false
end

function love.keypressed( key, scancode, isrepeat )
  -- quit game if escape is pressed
  if scancode == "escape" then
    love.event.quit()
  end
  if scancode == "space" then
    print( love.graphics.getWidth(), love.graphics.getHeight() )
  end
end

function love.draw()
  -- clear the screen
  love.graphics.clear( 0, 0, 0, 1 )
  useColor1()
  love.graphics.setColor( unpack( Color ))
  
  if Start_button:isEnabled() then
    Start_button:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Lore_dump, (love.graphics.getWidth()/2) - (Lore_dump:getWidth()/2), (love.graphics.getHeight()/4) - (Lore_dump:getHeight()/2))
  end
  
  for i = 1, #Dots do
    love.graphics.circle( "fill", Dots[i].x, Dots[i].y, Dot_size )
  end

  if Selector.is_active then
    love.graphics.circle( "line", Selector.x, Selector.y, Dot_size + 10 )
  end
end

function love.update( dt )
  
end


local love_errorhandler = love.errorhandler
function love.errorhandler( msg )
  if lldebugger then
    error( msg, 2 )
  else
    return love_errorhandler( msg )
  end
end

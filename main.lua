-- the debugger causes a lot of lag, so we only want to load it when debugging
if arg[ 2 ] == "vsc_debug" then
  require( "lldebugger" ).start()
end

require( "helpers" )

function love.load()
  -- Set up the window
  love.window.setMode(1000, 800, { resizable = true, vsync = false })

  -- Global Variables
  dots = {}
  dot_size = 40
  selector = {
    x = 0,
    y = 0,
    is_active = false,
  }

  -- Pick random seed
  math.randomseed( os.time() )
end

function love.mousepressed( mouse_x, mouse_y, button )
  if button == 1 then
    local is_valid = true
    local should_remove = false
    local remove_index = 0

    for i = 1, #dots do
      local dist = distance( mouse_x, mouse_y, dots[i].x, dots[i].y )
      if dist < dot_size * 2 then
        is_valid = false
        if dist < dot_size then
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
      dot.color = {
        math.random(),
        math.random(),
        math.random(),
        1
      }
      dots[ #dots + 1 ] = dot
    elseif should_remove then
      -- remove the dot
      table.remove( dots, remove_index )
    end

    love.mousemoved( mouse_x, mouse_y )
  end
end

function love.mousemoved( mouse_x, mouse_y, dx, dy, force )
  -- draw circle around dot under cursor
  for i = 1, #dots do
    if distance( mouse_x, mouse_y, dots[i].x, dots[i].y ) <= dot_size then
      selector.x = dots[i].x
      selector.y = dots[i].y
      selector.is_active = true
      return
    end
  end
  selector.is_active = false
end

function love.draw()
  -- clear the screen
  love.graphics.clear( 0, 0, 0, 1 )
  for i = 1, #dots do
    love.graphics.setColor( dots[i].color )
    love.graphics.circle( "fill", dots[i].x, dots[i].y, dot_size )
  end

  if selector.is_active then
    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.circle( "line", selector.x, selector.y, dot_size + 10 )
  end
end

function love.update( dt )
  -- quit game if escape is pressed
  if love.keyboard.isDown( "escape" ) then
    love.event.quit()
  end
end


local love_errorhandler = love.errorhandler
function love.errorhandler( msg )
  if lldebugger then
    error( msg, 2 )
  else
    return love_errorhandler( msg )
  end
end

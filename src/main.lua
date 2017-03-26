local g = require "./game"

local width  = 400
local height = 300

local game

love.load = function()
   love.window.setTitle("Pong")
   love.window.setMode(width, height)

   game = g.Game:new(width, height)
end

love.keypressed = function(key, _, _)
   if key == "escape" then
      love.event.quit()
   else
      game:keypressed(key)
   end
end

love.keyreleased = function(key, _, _)
   game:keyreleased(key)
end

love.update = function(dt)
   game:update()
end

love.draw = function()
   game:draw()
end

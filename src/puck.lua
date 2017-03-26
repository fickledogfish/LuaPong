local mod = {}

local math = require "math"

mod.Puck = {}
mod.Puck.__index = mod.Puck

local newSpeed = function(scale, angle)
   local angle = angle or math.random() + math.random(1, 2*math.pi)

   return scale*math.cos(angle),
          scale*math.sin(angle)
end

mod.Puck.new = function(self, x, y, r, box, scale)
   local scale = scale

   local speedX, speedY = newSpeed(scale)

   local newPuck = {
      startX = x,
      startY = y,

      x = x,
      y = y,
      r = r,

      scale  = scale,
      speedX = speedX,
      speedY = speedY,

      box = box
   }

   return setmetatable(newPuck, mod.Puck)
end

--[[
Checks if the puck collided with the borders of the field. Returns 1 if it
collided in the left border, 2 if it collided with the right or -1 when neither
of these happen.

This also makes the puck bounce in the top/bottom walls.
--]]
mod.Puck.edges = function(self)
   local x, y, r = self.x, self.y, self.r
   local minX, maxX = self.box.minX, self.box.maxX
   local minY, maxY = self.box.minY, self.box.maxY

   -- Bounce in the y axis
   if y - r < minY or y + r > maxY then
      self.speedY = self.speedY*(-1)
   end

   if x + r < minX then
      return 1
   elseif x - r > maxX then
      return 2
   end

   return -1
end

mod.Puck.collidesWith = function(self, paddle, isRightPaddle)
   local x, y, r = self.x, self.y, self.r

   if y > paddle.y and y < paddle.y + paddle.h then
      if isRightPaddle then
         if x + r > paddle.x then
            return true
         end
      else
         if x - r < paddle.x + paddle.w then
            return true
         end
      end
   end

   return false
end

--[[
Updates the puck's position according to its speed and returns the result of
edges.
--]]
mod.Puck.update = function(self, leftPaddle, rightPaddle)
   if self:collidesWith(leftPaddle) or self:collidesWith(rightPaddle, true) then
      self.speedX = self.speedX*(-1)
   end

   self.x = self.x + self.speedX
   self.y = self.y + self.speedY

   return self:edges()
end

mod.Puck.draw = function(self)
   love.graphics.circle("line", self.x, self.y, self.r)
end

mod.Puck.reset = function(self)
   self.speedX, self.speedY = newSpeed(self.scale)

   self.x = self.startX
   self.y = self.startY
end

return mod

local mod = {}

mod.Paddle = {}
mod.Paddle.__index = mod.Paddle

mod.Paddle.new = function(self, x, y, w, h, box, up, down, dy)
   local newPaddle = {
      startX = x,
      startY = y,

      minY = box.minY,
      maxY = box.maxY,

      x = x,
      y = y,
      w = w,
      h = h,

      movingUp   = false,
      movingDown = false,

      upkey = up,
      downkey = down,

      dy = dy or 1,
      speed = 0
   }

   return setmetatable(newPaddle, mod.Paddle)
end

mod.Paddle.keypressed = function(self, key)
   if key == self.upkey then
      self.movingUp = true
   elseif key == self.downkey then
      self.movingDown = true
   end
end

mod.Paddle.keyreleased = function(self, key)
   if key == self.upkey then
      self.movingUp = false
   elseif key == self.downkey then
      self.movingDown = false
   end
end

mod.Paddle.draw = function(self)
   love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

mod.Paddle.collidesWith = function(self, puck)

end

mod.Paddle.update = function(self)
   if self.movingUp then
      self.speed = self.speed - self.dy
   end

   if self.movingDown then
      self.speed = self.speed + self.dy
   end

   self.y = self.y + self.speed

   -- Constrain the paddle in the given box
   if self.y < self.minY then
      self.y = self.y - self.speed
   elseif self.y + self.h > self.maxY then
      self.y = self.y - self.speed
   end

   self.speed = 0
end

mod.Paddle.reset = function(self)
   self.x = self.startX
   self.y = self.startY
end

return mod

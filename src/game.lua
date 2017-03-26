local mod = {}

local paddle = require "./paddle"
local puck = require "./puck"

mod.Game = {}
mod.Game.__index = mod.Game

mod.Game.new = function(self, width, height)
   math.randomseed(os.time())

   local box = {
      minX = 0,
      maxX = width,
      minY = 0,
      maxY = height
   }

   local newGame = {
      width  = width,
      height = height,

      box = box,

      leftScore  = 0,
      rightScore = 0,

      leftPaddle  = paddle.Paddle:new(10, height/2, 10, 50, box, "q", "z", 5),
      rightPaddle = paddle.Paddle:new(width - 20, height/2, 10, 50, box, "p",
                                      ".", 5),

      puck = puck.Puck:new(width/2, height/2, 10, box, 3)
   }

   return setmetatable(newGame, mod.Game)
end

mod.Game.keypressed = function(self, key)
   if key == "r" then
      self:resetScore()
      self:reset()
   else
      self.leftPaddle:keypressed(key)
      self.rightPaddle:keypressed(key)
   end
end

mod.Game.keyreleased = function(self, key)
   self.leftPaddle:keyreleased(key)
   self.rightPaddle:keyreleased(key)
end

mod.Game.update = function(self)
   self.leftPaddle:update()
   self.rightPaddle:update()

   local winner = self.puck:update(self.leftPaddle, self.rightPaddle)

   if winner == 1 then
      self.leftScore = self.leftScore + 1
      self:reset()
   elseif winner == 2 then
      self.rightScore = self.rightScore + 1
      self:reset()
   end
end

mod.Game.draw = function(self)
   love.graphics.print(self.leftScore, 30, 20)
   love.graphics.print(self.rightScore, self.width - 40, 20)

   self.leftPaddle:draw()
   self.rightPaddle:draw()

   self.puck:draw()
end

mod.Game.resetScore = function(self)
   self.leftScore = 0
   self.rightScore = 0
end

mod.Game.resetPaddles = function(self)
   self.leftPaddle:reset()
   self.rightPaddle:reset()
end

mod.Game.resetPuck = function(self)
   self.puck:reset()
end

mod.Game.reset = function(self)
   self:resetPuck()
   self:resetPaddles()
end

return mod

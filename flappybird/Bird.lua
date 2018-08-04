Bird = Class{}

local GRAVITY = 6

function Bird:init()
  self.image = love.graphics.newImage('images/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.x = (VIRTUAL_WIDTH / 2) - self.width / 2
  self.y = (VIRTUAL_HEIGHT / 2) - self.height / 2

  self.dy = 0
end

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt

  if love.keyboard.wasPressed('space') or love.keyboard.wasPressed(1) then
    audio['jump']:play()
    self.dy = -2
  end

  self.y = self.y + self.dy
end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
  -- shrinking the bounding box of bird
  -- to make collision look realistic
  if (self.x + 4) + (self.width - 8) >= pipe.x and (self.x + 4) <= (pipe.x + pipe.width) then
    if (self.y + 4) + (self.height - 8) >= pipe.y and (self.y + 4) <= (pipe.y + pipe.height) then
      return true
    end
  end

  return false
end

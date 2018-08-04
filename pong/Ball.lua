
Ball = Class{}

function Ball:init(x, y, width, height)
  self.x = x or 5
  self.y = y or 5
  self.width = width
  self.height = height

  self.dx = math.random(-50, 50)
  self.dy = math.random(2) == 1 and 100 or -100
end

function Ball:collides(paddle)
  if self.x > paddle.x + paddle.width or self.x + self.width < paddle.x then
    return false
  end

  if self.y > paddle.y + paddle.height or self.y + self.height < paddle.y then
    return false
  end

  -- it must be colliding
  return true
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  self.dx = math.random(-50, 50)
  self.dy = math.random(2) == 1 and 100 or -100
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

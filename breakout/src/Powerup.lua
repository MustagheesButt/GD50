Powerup = Class{}

function Powerup:init(n)
    self.x = math.random(5, VIRTUAL_WIDTH - 10)
    self.y = -5
    self.width = 16
    self.height = 16

    self.dy = 100

    self.n = n -- how many balls to generate
end

function Powerup:collides(target)
  if self.x > (target.x + target.width) or (self.x + self.width) < target.x then
    return false
  end

  if (self.y + self.height) < target.y or self.y > (target.y + target.height) then
    return false
  end

  return true
end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    love.graphics.draw(gImages['main'], gFrames['powerups'][self.n], self.x, self.y)
end
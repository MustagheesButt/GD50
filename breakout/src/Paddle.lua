Paddle = Class{}

function Paddle:init(skin)
  self.skin = skin -- the color, can range from 1 - 4

  self.size = 2 -- can range from 1 - 4

  self.x = VIRTUAL_WIDTH / 2 - PADDLE_SIZES[self.size]/2
  self.y = VIRTUAL_HEIGHT - 32

  self.dx = 0

  self.width = PADDLE_SIZES[self.size]
  self.height = 16
end

function Paddle:update(dt)
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    self.dx = -PADDLE_SPEED
  elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
    self.dx = PADDLE_SPEED
  else
    self.dx = 0
  end

  -- clamping
  if self.dx < 0 then -- going left
    self.x = math.max(0, self.x + self.dx * dt)
  else
    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
  end
end

function Paddle:render()
  love.graphics.draw(gImages['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end
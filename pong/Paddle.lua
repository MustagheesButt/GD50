Paddle = Class{}

function Paddle:init(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = 0
    self.color = color
end

function Paddle:update(dt)
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:update_AI_easy(dt, ballX)
    self.dx = ballX - self.x
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:update_AI_hard(dt, ballX)
    self.dx = (ballX - self.x)
    if self.dx < 0 then
         self.x = math.max(0, ballX)
     else
         self.x = math.min(VIRTUAL_WIDTH - self.width, ballX)
    end
end

function Paddle:render()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(default_color)
end

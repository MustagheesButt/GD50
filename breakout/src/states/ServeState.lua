ServeState = Class{__includes = BaseState}

function ServeState:init()
  self.paddle = nil
  self.balls = nil

  self.level = nil
  self.bricks = nil
  self.health = 3
  self.score = 0
end

function ServeState:enter(params)
  self.paddle = params.paddle
  self.balls = params.balls
  for i, ball in pairs(self.balls) do
    ball.skin = math.random(7)
  end

  self.level = params.level
  self.bricks = params.bricks

  self.health = params.health
  self.score = params.score

  gSounds['bgm']:setVolume(0.6)
end

function ServeState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play', {
      paddle = self.paddle,
      balls = self.balls,
      bricks = self.bricks,
      health = self.health,
      score = self.score,
      level = self.level
    })
  end
end

function ServeState:render()
  self.paddle:render()
  
  for i, ball in pairs(self.balls) do
    ball:render()
  end

  for i = 1, #self.bricks do
    self.bricks[i]:render()
  end

  renderScore(self.score)
  renderHealth(self.health)
  love.graphics.printf("Level: " .. tostring(self.level), 0, 14 - gFonts['small']:getHeight(), VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf("Press ENTER to start", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
end

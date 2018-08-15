VictoryState = Class{__includes = BaseState}

function VictoryState:init()
  self.paddle = nil
  self.level = 0
  self.score = 0
  self.health = 0

  self.timer = 0
end

function VictoryState:enter(params)
  self.paddle = params.paddle
  self.level = params.level
  self.score = params.score
  self.health = params.health

  -- check new highscore
  if not params.highscore_checked and checkHighScore(self.score) then
    gStateMachine:change('enter-highscore', {
      paddle = self.paddle,
      level = self.level,
      score = self.score,
      health = self.health,
      return_to = 'victory'
    })
  else
    gSounds['bgm']:setVolume(0.1)
    gSounds['victory']:play()
  end
end

function VictoryState:update(dt)
  self.timer = self.timer + 1 * dt

  if self.timer >= 3 then
    gSounds['bgm']:setVolume(0.6)
  end

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('serve', {
      paddle = self.paddle,
      balls = { Ball(1) },
      bricks = LevelMaker.createMap(self.level + 1),
      health = self.health,
      score = self.score,
      level = self.level + 1
    })
  end
end

function VictoryState:render()
  love.graphics.setFont(gFonts['xlarge'])
  love.graphics.printf("Victory!", 0, VIRTUAL_HEIGHT / 2 - gFonts['xlarge']:getHeight(), VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf("Press Enter to continue", 0, VIRTUAL_HEIGHT / 2 - gFonts['medium']:getHeight() + 20, VIRTUAL_WIDTH, 'center')
end

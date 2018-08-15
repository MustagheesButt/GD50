GameOverState = Class{__includes = BaseState}

function GameOverState:init()
  self.score = 0
end

function GameOverState:enter(params)
  self.score = params.score

  -- check new highscore
  if not params.highscore_checked and checkHighScore(self.score) then
    gStateMachine:change('enter-highscore', {
      score = self.score,
      return_to = 'game-over'
    })
  end
end

function GameOverState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start')
  end
end

function GameOverState:render()
  love.graphics.setFont(gFonts['xlarge'])
  love.graphics.printf("Game Over!", 0, VIRTUAL_HEIGHT / 2 - gFonts['xlarge']:getHeight(), VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf(self.score, 0, VIRTUAL_HEIGHT / 2 - gFonts['large']:getHeight() + 40, VIRTUAL_WIDTH, 'center')
end

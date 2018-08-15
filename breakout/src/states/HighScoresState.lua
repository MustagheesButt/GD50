HighScoresState = Class{__includes = BaseState}

function HighScoresState:init() end

function HighScoresState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('escape') then
    gStateMachine:change('start')
  end
end

function HighScoresState:render()
  love.graphics.setFont(gFonts['xlarge'])
  love.graphics.printf("Highscores", 0, 10, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])

  for i, line in pairs(gHighScores) do
    love.graphics.print(tostring(i), VIRTUAL_WIDTH / 4, gFonts['xlarge']:getHeight() + i * gFonts['medium']:getHeight())
    love.graphics.print(line.name, VIRTUAL_WIDTH / 2.5, gFonts['xlarge']:getHeight() + i * gFonts['medium']:getHeight())
    love.graphics.print(tostring(line.score), VIRTUAL_WIDTH / 1.5, gFonts['xlarge']:getHeight() + i * gFonts['medium']:getHeight())
  end
end

ScoreState = Class{__includes = BaseState}

function ScoreState:init()
  self.score = 0

  self.medals = {
    ['bronze'] = love.graphics.newImage('images/bronze.png'),
    ['silver'] = love.graphics.newImage('images/silver.png'),
    ['gold'] = love.graphics.newImage('images/gold.png')
  }
end

function ScoreState:enter(params)
  self.score = params.score
end

function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function ScoreState:render()
  love.graphics.setFont(font36)
  love.graphics.printf("Score  " .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2 - 36, VIRTUAL_WIDTH, 'center')
  love.graphics.printf("High  " .. tostring(gHighscore), 0, VIRTUAL_HEIGHT / 2 - 36 + 40, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(font18)
  love.graphics.printf("Press  Enter  to  start  again", 0, VIRTUAL_HEIGHT / 2 - 18 + 80 , VIRTUAL_WIDTH, 'center')

  local to_draw = nil
  if self.score >= 50 then
    to_draw = 'gold'
  elseif self.score >= 30 then
    to_draw = 'silver'
  elseif self.score >= 10 then
    to_draw = 'bronze'
  end

  if to_draw then
    love.graphics.draw(self.medals[to_draw], VIRTUAL_WIDTH - self.medals[to_draw]:getWidth() - 10, 20)
  end
end

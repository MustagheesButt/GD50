StartState = Class{__includes = BaseState}

function StartState:init()
  self.highlighted = 1
  self.menu = {
    {text = "Play Now", val = 'paddle-select', params = {
      paddle = Paddle(1),
      balls = { Ball(1) },
      bricks = LevelMaker.createMap(1),
      health = 3,
      score = 0,
      level = 1
    }},
    {text = "High Scores", val = 'high-scores'},
    {text = "Instructions", val = 'instructions'},
    {text = "Credits", val = 'credits'}
  }
end

function StartState:update(dt)
  -- menu scrolling
  if (love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up')) and self.highlighted > 1 then
    self.highlighted = self.highlighted - 1
    gSounds['select']:play()
  elseif (love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down')) and self.highlighted < #self.menu then
    self.highlighted = self.highlighted + 1
    gSounds['select']:play()
  end

  -- transition into other states
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change(self.menu[self.highlighted].val, self.menu[self.highlighted].params)
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function StartState:render()
  love.graphics.setFont(gFonts['xlarge'])

  love.graphics.setColor(DEFAULT_COLOR)
  love.graphics.printf("Breakout", 0, 20, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  for i, menuItem in pairs(self.menu) do
    if self.highlighted == i then
      love.graphics.setColor(HIGHLIGHT_COLOR)
    else
      love.graphics.setColor(DEFAULT_COLOR)
    end

    love.graphics.printf(menuItem.text, 0, 80 + (i - 1) * 24, VIRTUAL_WIDTH, 'center')
  end
end

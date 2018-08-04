CountdownState = Class{__includes = BaseState}

-- since a second is too long
COUNTDOWN_TIME = 0.75

function CountdownState:init()
  self.countdown = 3
  self.timer = 0
end

function CountdownState:update(dt)
  self.timer = self.timer + dt
  if self.timer > COUNTDOWN_TIME then
    self.countdown = self.countdown - 1
    self.timer = 0
  end

  if self.countdown == 0 then
    gStateMachine:change('play')
  end
end

function CountdownState:render()
  love.graphics.setFont(font36)
  love.graphics.printf(tostring(self.countdown), 0, VIRTUAL_HEIGHT / 2 - 36, VIRTUAL_WIDTH, 'center')
end

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function TitleScreenState:render()
  love.graphics.setFont(font36)
  love.graphics.printf('Noob Bird', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(font18)
  love.graphics.printf('Press ENTER to start', 0, 100, VIRTUAL_WIDTH, 'center')
end

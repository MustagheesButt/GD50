EnterHighScoreState = Class{__includes = BaseState}

function EnterHighScoreState:init()
  self.name_size = 0
  self.MAX_NAME_SIZE = 5
  self.name = {'_', '_', '_', '_', '_'}
  self.highscore = 0

  self.persist_data = nil
end

function EnterHighScoreState:enter(params)
  gSounds['highscore']:play()

  self.persist_data = params
  self.highscore = params.score

  -- so highscore doesn't gets checked more than once
  self.persist_data.highscore_checked = true
end

function love.keypressed(key)
  
end

function EnterHighScoreState:update(dt)
  -- check all pressed keys
  for i, key in pairs(love.keyboard.keysPressed) do
    if string.len(key) == 1 and self.name_size < self.MAX_NAME_SIZE and ((key >= 'a' and key <= 'z') or (key >= 'A' and key <= 'Z')) then
      self.name_size = self.name_size + 1
      self.name[self.name_size] = key
    elseif self.name_size > 0 and key == 'backspace' then
      self.name[self.name_size] = '_'
      self.name_size = self.name_size - 1
    end
  end

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- update highscores table
    for i, highscore in pairs(gHighScores) do
      if self.highscore > highscore.score then
        highscore.name = table.tostring(self.name)
        highscore.score = self.highscore
        break
      end
    end

    -- update highscores file
    saveHighscores(gHighScores)
    
    gStateMachine:change(self.persist_data.return_to, self.persist_data)
  end
end

function EnterHighScoreState:render()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf("New Highscore: " .. tostring(self.highscore), 0, 20, VIRTUAL_WIDTH, 'center')

  love.graphics.printf("Enter your name", 0, 20 + gFonts['large']:getHeight(), VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['xlarge'])
  for i = 1, #self.name do
    love.graphics.print(self.name[i], VIRTUAL_WIDTH / 4 + i * 30, VIRTUAL_HEIGHT / 2)
  end
end
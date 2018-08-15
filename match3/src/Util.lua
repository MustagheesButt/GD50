-- contains utility functions

function displayFPS()
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5, 5)
end

function renderHealth(health)
  local healthX = VIRTUAL_WIDTH - 60

  -- render current health
  for i = 1, health do
    love.graphics.draw(gImages['hearts'], gFrames['hearts'][1], healthX, 4)
    healthX = healthX + 11
  end

  -- render missing health
  for i = 1, 3 - health do
    love.graphics.draw(gImages['hearts'], gFrames['hearts'][2], healthX, 4)
    healthX = healthX + 11
  end
end

function renderScore(score)
  love.graphics.setFont(gFonts['small'])
  love.graphics.print(score, VIRTUAL_WIDTH - 100, 14 - gFonts['small']:getHeight())
end

function gResetColor()
  love.graphics.setColor(255, 255, 255, 255)
end

function loadHighScores()
  love.filesystem.setIdentity('breakout')

  -- if file doesn't exists, initialize it with some default scores
  if not love.filesystem.exists('breakout.lst') then
    local scores = ''

    for i = 10, 1, -1 do
      scores = scores .. "CTO\n"
      scores = scores .. tostring(i * 1000) .. '\n'
    end

    love.filesystem.write('breakout.lst', scores)
  end

  local name = true
  local currentName = nil
  local counter = 1

  local scores = {}

  -- initialize scores table
  for i = 1, 10 do
    local record = {name = nil, score = nil}
    table.insert(scores, record)
  end

  -- fill in the scores table with actuall values from the saved file
  for line in love.filesystem.lines('breakout.lst') do
    if name then
      scores[counter].name = line
    else
      scores[counter].score = tonumber(line)
      counter = counter + 1
    end

    name = not name
  end

  return scores
end

function saveHighscores(HighscoresTable)
  local scores = ''
  
  for i = 1, #HighscoresTable do
    scores = scores .. HighscoresTable[i].name .. "\n"
    scores = scores .. tostring(HighscoresTable[i].score) .. '\n'
  end
  
  love.filesystem.write('breakout.lst', scores)
end

function checkHighScore(score)
  for i = 1, #gHighScores do
    if score > gHighScores[i].score then
      return true
    end
  end

  return false
end

function GenerateQuads(atlas, width, height)
  local spritesheet = {}
  local counter = 1

  local spriteWidth = atlas:getWidth() / width -- how many sprites in one row (or number of columns)
  local spriteHeight = atlas:getHeight() / height -- // // // in one column (or number of rows)

  for i = 0, spriteHeight - 1 do
    for j = 0, spriteWidth - 1 do
      spritesheet[counter] = love.graphics.newQuad(j * width, i * height, width, height, atlas:getDimensions())
      counter = counter + 1
    end
  end

  return spritesheet
end

function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

function table.tostring( tbl )
  str = ""

  for i, char in pairs(tbl) do
    if type(char) == "string" then
      str = str .. char
    end
  end

  return str
end
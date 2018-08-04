PlayState = Class{__includes = BaseState}

gHighscore = 0

function PlayState:init()
  self.bird = Bird()
  self.pipe_pairs = {}
  self.spawnTimer = 0
  self.score = 0

  -- for gap placement, we record last Y value
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
  self.spawnTimer = self.spawnTimer + dt

  if self.spawnTimer > 2 then
    local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
    self.lastY = y

    table.insert(self.pipe_pairs, PipePair(y))
    self.spawnTimer = 0
  end

  self.bird:update(dt)

  for k, pipe_pair in pairs(self.pipe_pairs) do
    if not pipe_pair.scored and self.bird.x > pipe_pair.x + PIPE_WIDTH then
      self.score = self.score + 1
      pipe_pair.scored = true
      audio['score']:play()

      if self.score > gHighscore then
        gHighscore = self.score
      end
    end

    pipe_pair:update(dt)
  end

  -- remove any flagged pipes
  -- we need this second loop, rather than deleting in the previous loop, because
  -- modifying the table in-place without explicit keys will result in skipping the
  -- next pipe, since all implicit keys (numerical indices) are automatically shifted
  -- down after a table removal
  for k, pipe_pair in pairs(self.pipe_pairs) do
      if pipe_pair.remove then
          table.remove(self.pipe_pairs, k)
      end

      if self.bird:collides(pipe_pair.pipes['top']) or self.bird:collides(pipe_pair.pipes['bot']) then
        audio['collision']:play()
        gStateMachine:change('score', {
          score = self.score
        })
      end
  end

  if (self.bird.y + self.bird.height) > (VIRTUAL_HEIGHT - 6) then
    gStateMachine:change('score', {
      score = self.score
    })
  end
end

function PlayState:render()
  for k, pipe_pair in pairs(self.pipe_pairs) do
    pipe_pair:render()
  end

  self.bird:render()

  love.graphics.setFont(font18)
  love.graphics.printf("Score  " .. tostring(self.score), -40, 20, VIRTUAL_WIDTH, 'right')
  love.graphics.printf("High " .. tostring(gHighscore), -40, 20 + 18 + 10, VIRTUAL_WIDTH, 'right')
end

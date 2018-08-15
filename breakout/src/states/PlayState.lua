PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.paddle = Paddle()
  self.balls = { Ball(1) }

  self.level = 1
  self.bricks = LevelMaker.createMap(self.level)

  self.health = 3
  self.score = 0

  self.paused = false
  self.powerup_timer = 0
end

function PlayState:enter(params)
  self.paddle = params.paddle
  self.balls = params.balls

  self.level = params.level
  self.bricks = params.bricks

  self.health = params.health
  self.score = params.score
end

function PlayState:update(dt)
  if self.paused then
    if love.keyboard.wasPressed('space') then
      self.paused = false
      gSounds['pause']:play()
    end

    return
  elseif love.keyboard.wasPressed('space') then
    self.paused = true
    gSounds['pause']:play()
    return
  end

  self.powerup_timer = self.powerup_timer + 1 * dt
  if self.powerup_timer >= 30 then
    self.powerup = Powerup(math.random(1, 10))
    self.powerup_timer = 0
  end

  if self.powerup then
    self.powerup:update(dt)

    if self.powerup:collides(self.paddle) then
      for i = 1, self.powerup.n do
        table.insert(self.balls, Ball(math.random(1, 7)))
      end

      self.powerup = nil
    end
  end

  self.paddle:update(dt)

  -- update ball and check all collisions
  for i, ball in pairs(self.balls) do
    ball:update(dt)

    -- collisions
    if ball:collides(self.paddle) then
      ball.y = self.paddle.y - 8
      ball.dy = -ball.dy

      -- angle adjustment
      -- hits left while paddle is moving left
      if self.paddle.dx < 0 and (ball.x + ball.width / 2) < (self.paddle.x + self.paddle.width / 2) then
        ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
      -- hits right while paddle is moving right
      elseif self.paddle.dx > 0 and (ball.x + ball.width / 2) > (self.paddle.x + self.paddle.width / 2) then
        ball.dx = 50 + 8 * (ball.x - (self.paddle.x + self.paddle.width / 2))
      end

      gSounds['paddle-hit']:play()
    end

    -- brick collision
    for i, brick in pairs(self.bricks) do
      if brick.inPlay and ball:collides(brick) then
        brick:hit()
        self.score = self.score + (brick.tier * 200 + brick.color * 25)

        -- check victory
        if self:checkVictory() then
          gStateMachine:change('victory', {
            score = self.score,
            level = self.level,
            paddle = self.paddle,
            health = self.health
          })
        end

        -- left edge; only check if we're moving right
        if ball.x + 2 < brick.x and ball.dx > 0 then

            -- flip x velocity and reset position outside of brick
            ball.dx = -ball.dx
            ball.x = brick.x - 8

        -- right edge; only check if we're moving left
        elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then

            -- flip x velocity and reset position outside of brick
            ball.dx = -ball.dx
            ball.x = brick.x + 32

        -- top edge if no X collisions, always check
        elseif ball.y < brick.y then

            -- flip y velocity and reset position outside of brick
            ball.dy = -ball.dy
            ball.y = brick.y - 8

        -- bottom edge if no X collisions or top collision, last possibility
        else
            -- flip y velocity and reset position outside of brick
            ball.dy = -ball.dy
            ball.y = brick.y + 16
        end

        -- slightly scale the y velocity to speed up the game
        ball.dy = ball.dy * 1.02

        -- only allow colliding with one brick, for corners
        break
      end
    end

    -- health update
    if ball.y >= VIRTUAL_HEIGHT and #self.balls > 1 then
      ball.nerf = true -- remove this shit, after this loop so it doesn't cause any issues within the loop
    elseif ball.y >= VIRTUAL_HEIGHT then
      self.health = self.health - 1
      ball:reset()
      gSounds['hurt']:play()

      -- game over check
      if self.health == 0 then
        gStateMachine:change('game-over', {score = self.score})
      else
        gStateMachine:change('serve', {
          balls = self.balls,
          paddle = self.paddle,
          bricks = self.bricks,
          score = self.score,
          health = self.health,
          level = self.level
        })
      end
    end
  end

  -- remove nerfed balls
  for i = #self.balls, 1, -1 do
    if self.balls[i].nerf then
      table.remove(self.balls, i)
    end
  end

  for i, brick in pairs(self.bricks) do
    brick:update(dt)
  end

  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('start')
  end
end

function PlayState:render()
  for i = 1, #self.bricks do
    self.bricks[i]:render()
    self.bricks[i]:renderParticles()
  end

  if self.powerup then
    self.powerup:render()
  end

  self.paddle:render()

  for i, ball in pairs(self.balls) do
    ball:render()
  end

  renderScore(self.score)
  renderHealth(self.health)
  love.graphics.printf("Level: " .. tostring(self.level), 0, 14 - gFonts['small']:getHeight(), VIRTUAL_WIDTH, 'center')

  if self.paused then
      love.graphics.setFont(gFonts['large'])
      love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
  end
end

function PlayState:checkVictory()
  for i, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end

  return true
end

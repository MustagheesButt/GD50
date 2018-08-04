push = require 'push'

Class = require 'class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 800
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

default_color = {255, 255, 255}
flat_colors = {
  {231, 76, 60}, -- alizarin red
  {46, 204, 113}, -- emerald green
  {155, 89, 182}, -- amythest purple
  {241, 196, 15}, -- sunflower
  {52, 152, 219} -- peter river blue
}
ball_color_counter = 0

bgm = love.audio.newSource('sfx/gangplank_bgm.mp3', 'stream')

function love.load()
  -- window title
  love.window.setTitle("Super Pong")

  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  font12 = love.graphics.newFont('fonts/Roboto-Bold.ttf', 12)
  font24 = love.graphics.newFont('fonts/Roboto-Bold.ttf', 24)

  sounds = {
    ['paddle_hit'] = love.audio.newSource('sfx/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sfx/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sfx/wall_hit.wav', 'static')
  }

  -- set active fonts
  love.graphics.setFont(font12)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = true,
      resizable = false,
      vsync = true
  })

  p1Score = 0
  p2Score = 0

  paddle1 = Paddle(VIRTUAL_WIDTH / 2 - 2, 2, 20, 5, flat_colors[1])
  paddle2 = Paddle(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT - 5 - 2, 20, 5, flat_colors[5])

  -- ball config
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  gameState = 'main_menu'
  winner = 'none'

  bgm:play()
end

function love.keypressed(key)
  if key == 'escape' then
    if gameState == 'play' or gameState == 'start' then
      -- reset stuff
      ball:reset()
      gameState = 'main_menu'
      bgm:play()
    else
      love.event.quit()
    end
  elseif key == 'enter' or key == 'return' then
    if gameState == 'main_menu' then
      gameState = 'start'
      againstPlayer = 'player'
      -- to ensure new game
      p1Score = 0
      p2Score = 0
      bgm:stop()
    elseif gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'play' then
      gameState = 'start'
      -- reset stuff
      ball:reset()
    elseif gameState == 'victory' then
      gameState = 'main_menu'
      bgm:play()
    end
  elseif key == 'j' then
    if gameState == 'main_menu' then
      gameState = 'start'
      againstPlayer = 'AI_easy'
      -- to ensure new game
      p1Score = 0
      p2Score = 0
      bgm:stop()
    end
  elseif key == 'k' then
    if gameState == 'main_menu' then
      gameState = 'start'
      againstPlayer = 'AI_hard'
      -- to ensure new game
      p1Score = 0
      p2Score = 0
      bgm:stop()
    end
  end
end

function love.update(dt)
  -- player 1 paddle
  -- in case of AI, everything will happen in paddle1:update_AI_*level*()
  if love.keyboard.isDown('a') then
    paddle1.dx = -PADDLE_SPEED
  elseif love.keyboard.isDown('d') then
    paddle1.dx = PADDLE_SPEED
  else
    paddle1.dx = 0
  end

  -- player 2 paddle
  if love.keyboard.isDown('left') then
    paddle2.dx = -PADDLE_SPEED
  elseif love.keyboard.isDown('right') then
    paddle2.dx = PADDLE_SPEED
  else
    paddle2.dx = 0
  end

  if gameState == 'play' then
    -- collision detection
    if ball:collides(paddle1) then
      ball.dy = -ball.dy * 1.03
      ball.y = paddle1.y + 5 -- ensuring correct position

      ball_color_counter = (ball_color_counter + 1) % #flat_colors

      -- sfx
      sounds['paddle_hit']:play()
    end

    if ball:collides(paddle2) then
      ball.dy = -ball.dy * 1.03
      ball.y = paddle2.y - 5

      ball_color_counter = (ball_color_counter + 1) % #flat_colors

      -- sfx
      sounds['paddle_hit']:play()
    end

    -- boundary collision
    if ball.x < 0 or ball.x + 5 > VIRTUAL_WIDTH then
      ball.dx = -ball.dx

      -- sfx
      sounds['wall_hit']:play()
    end

    -- score (top n bottom boundary collision)
    if ball.y < 0 then
      p2Score = p2Score + 1
      ball:reset()
      sounds['score']:play()
    elseif ball.y - 5 > VIRTUAL_HEIGHT then
      p1Score = p1Score + 1
      ball:reset()
      sounds['score']:play()
    end

    -- victory update
    if p1Score == 10 then
      gameState = 'victory'
      winner = 'Player 1'
    elseif p2Score == 10 then
      gameState = 'victory'
      winner = 'Player 2'
    end

    -- ball update
    ball:update(dt)
  end

  if againstPlayer == 'player' then
    paddle1:update(dt)
  elseif againstPlayer == 'AI_easy' then
    paddle1:update_AI_easy(dt, ball.x)
  else
    paddle1:update_AI_hard(dt, ball.x)
  end
  paddle2:update(dt)

end

function love.draw()
  push:apply('start')

  -- set BG
  love.graphics.clear(40, 45, 52, 255)

  love.graphics.setColor(default_color)

  if gameState == 'main_menu' then
    love.graphics.setFont(font24)
    love.graphics.printf("Super Pong", 0, VIRTUAL_HEIGHT / 2 - 24, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(font12)

    PvP = {default_color, "Press ENTER to ", flat_colors[1], "Player", default_color, " vs ", flat_colors[5], "Player"}
    love.graphics.printf(PvP, 0, VIRTUAL_HEIGHT / 2 - 12 + 24, VIRTUAL_WIDTH, 'center')
    AIEvP = {default_color, "Press J to ", flat_colors[1], "AI (easy)", default_color, " vs ", flat_colors[5], "Player"}
    love.graphics.printf(AIEvP, 0, VIRTUAL_HEIGHT / 2 - 12 + 36, VIRTUAL_WIDTH, 'center')
    AIHvP = {default_color, "Press K to ", flat_colors[1], "AI (hard)", default_color, " vs ", flat_colors[5], "Player"}
    love.graphics.printf(AIHvP, 0, VIRTUAL_HEIGHT / 2 - 12 + 48, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'victory' then
    love.graphics.setFont(font24)
    love.graphics.setColor(flat_colors[2]) -- flat green (emerald)
    love.graphics.printf("Victory!", 0, VIRTUAL_HEIGHT / 2 - 24, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(font12)
    love.graphics.printf(winner .. " is the winner.", 0, VIRTUAL_HEIGHT / 2 - 12 + 24, VIRTUAL_WIDTH, 'center')
  else
    -- draw paddles
    paddle1:render()
    paddle2:render()

    -- ball
    love.graphics.setColor(flat_colors[ball_color_counter + 1])
    ball:render()

    -- p1, p2 score
    love.graphics.setColor(255, 255, 255, 127)
    love.graphics.setFont(font24)
    love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2 - 50)
    love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2 - 24 + 50)

    -- write FPS
    love.graphics.setFont(font12)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
  end

  push:apply('end')
end

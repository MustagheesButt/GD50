require 'src/dependencies'

function love.load()
  love.window.setTitle('Breakout')

  love.graphics.setDefaultFilter('nearest', 'nearest')

  math.randomseed(os.time())

  gFonts = {
    ['small'] = love.graphics.newFont('fonts/fixedsys.ttf', 10),
    ['medium'] = love.graphics.newFont('fonts/fixedsys.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/fixedsys.ttf', 32),
    ['xlarge'] = love.graphics.newFont('fonts/fixedsys.ttf', 42)
  }
  love.graphics.setFont(gFonts['small'])

  gImages = {
    ['background'] = love.graphics.newImage('images/background.jpg'),
    ['main'] = love.graphics.newImage('images/breakout-spritesheet.png'),
    ['hearts'] = love.graphics.newImage('images/hearts.png'),
    --['arrows'] = love.graphics.newImage('images/arrows.png'),
    ['particle'] = love.graphics.newImage('images/particle.png')
  }

  gFrames = {
    ['paddles'] = GenerateQuadPaddles(gImages['main']),
    ['balls'] = GenerateQuadBalls(gImages['main']),
    ['bricks'] = GenerateQuadBricks(gImages['main']),
    ['hearts'] = GenerateQuads(gImages['hearts'], 10, 9),
    ['powerups'] = GenerateQuadPowerups(gImages['main'])
  }

  gSounds = {
    ['select'] = love.audio.newSource('sfx/select.wav', 'static'),
    ['no-select'] = love.audio.newSource('sfx/no-select.wav', 'static'),
    ['wall-hit'] = love.audio.newSource('sfx/wall-hit.wav', 'static'),
    ['paddle-hit'] = love.audio.newSource('sfx/wall-hit.wav', 'static'),
    ['brick-hit-1'] = love.audio.newSource('sfx/brick-hit-1.wav', 'static'),
    ['brick-hit-2'] = love.audio.newSource('sfx/brick-hit-2.wav', 'static'),
    ['highscore'] = love.audio.newSource('sfx/highscore.wav', 'static'),
    ['hurt'] = love.audio.newSource('sfx/hurt.wav', 'static'),
    ['victory'] = love.audio.newSource('sfx/victory.wav', 'static'),
    ['pause'] = love.audio.newSource('sfx/pause.wav', 'static'),

    ['bgm'] = love.audio.newSource('sfx/proj-jhin-login-bgm.mp3', 'stream')
  }
  gSounds['bgm']:setVolume(0.6)
  gSounds['bgm']:setLooping(true)
  gSounds['bgm']:play()

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    resizable = true,
    fullscreen = true,
    vsync = true
  })

  -- state machine
  gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['paddle-select'] = function() return PaddleSelectState() end,
    ['serve'] = function() return ServeState() end,
    ['play'] = function() return PlayState() end,
    ['game-over'] = function() return GameOverState() end,
    ['victory'] = function() return VictoryState() end,
    ['high-scores'] = function() return HighScoresState() end,
    ['enter-highscore'] = function() return EnterHighScoreState() end,
    ['credits'] = function() return CreditsState() end,
    ['instructions'] = function() return InstructionsState() end
  }
  gStateMachine:change('start')

  gHighScores = loadHighScores()

  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = key
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()

  local backgroundWidth = gImages['background']:getWidth()
  local backgroundHeight = gImages['background']:getHeight()

  love.graphics.draw(gImages['background'],
  0, 0, -- X, Y
  0,    -- rotation
  VIRTUAL_WIDTH / (backgroundWidth), VIRTUAL_HEIGHT / (backgroundHeight)) -- X, Y scaling

  -- for debugging
  --displayFPS()

  gResetColor()
  gStateMachine:render()

  push:finish()
end

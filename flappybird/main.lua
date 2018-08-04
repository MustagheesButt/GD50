push = require 'push'

Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 800

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('images/background-orig.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle("Noob Bird")

  font12 = love.graphics.newFont('fonts/ARCADECLASSIC.TTF', 12)
  font18 = love.graphics.newFont('fonts/ARCADECLASSIC.TTF', 18)
  font36 = love.graphics.newFont('fonts/ARCADECLASSIC.TTF', 36)

  audio = {
    ['bgm'] = love.audio.newSource('sfx/Just_Forget_-_Force_Of_Nature.mp3', 'stream'),
    ['score'] = love.audio.newSource('sfx/score.wav', 'static'),
    ['collision'] = love.audio.newSource('sfx/collision.wav', 'static'),
    ['jump'] = love.audio.newSource('sfx/jump.wav', 'static')
  }
  audio['bgm']:setVolume(0.4)

  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    resizable = true,
    fullscreen = true
  })

  -- the small `g` in the start denotes global scope
  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end
  }
  gStateMachine:change('title')

  audio['bgm']:setLooping(true)
  audio['bgm']:play()

  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true

  if key == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  love.keyboard.keysPressed[button] = {x, y}
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.update(dt)
  backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start() -- de facto standard

  love.graphics.draw(background, -backgroundScroll, 0)
  gStateMachine:render()
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  push:finish()
end

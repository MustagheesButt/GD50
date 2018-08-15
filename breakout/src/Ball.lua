Ball = Class{}

function Ball:init(skin)
  assert(skin)
  self.x = VIRTUAL_WIDTH / 2 - 8
  self.y = VIRTUAL_HEIGHT / 2 - 8

  self.dx = math.random(-200, 200)
  self.dy = math.random(-50, -60)

  self.width = 8
  self.height = 8

  self.skin = skin
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 8
  self.y = VIRTUAL_HEIGHT / 2 - 8

  self.dx = math.random(-200, 200)
  self.dy = math.random(-50, -60)
end

-- `target` is anything with a bounding box, be it a paddle or a brick
function Ball:collides(target)
  if self.x > (target.x + target.width) or (self.x + self.width) < target.x then
    return false
  end

  if (self.y + self.height) < target.y or self.y > (target.y + target.height) then
    return false
  end

  return true
end

function Ball:update(dt)
  -- apply velocity
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  -- bouncing off walls
  if self.x <= 0 then
    self.x = 0
    self.dx = -self.dx
    gSounds['wall-hit']:play()
  elseif self.x >= (VIRTUAL_WIDTH - self.width) then
    self.x = (VIRTUAL_WIDTH - self.width)
    self.dx = -self.dx
    gSounds['wall-hit']:play()
  end

  if self.y <= 0 then
    self.y = 0
    self.dy = -self.dy
    gSounds['wall-hit']:play()
  end
end

function Ball:render()
  love.graphics.draw(gImages['main'], gFrames['balls'][self.skin], self.x, self.y)
end

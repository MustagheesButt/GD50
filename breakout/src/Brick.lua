Brick = Class{}

paletteColors = {
  [1] = {
    ['r'] = 91,
    ['g'] = 110,
    ['b'] = 125
  },
  [2] = {
    ['r'] = 75,
    ['g'] = 105,
    ['b'] = 47
  },
  [3] = {
    ['r'] = 172,
    ['g'] = 50,
    ['b'] = 50
  },
  [4] = {
    ['r'] = 118,
    ['g'] = 66,
    ['b'] = 138
  },
  [5] = {
    ['r'] = 223,
    ['g'] = 113,
    ['b'] = 38
  }
}

function Brick:init(x, y)
  self.tier = 0
  self.color = 1

  self.x = x
  self.y = y
  self.width = 32
  self.height = 16

  self.inPlay = true

  -- pArTiClE sYsTeM
  self.psystem = love.graphics.newParticleSystem(gImages['particle'], 64)

  -- particle system config
  self.psystem:setParticleLifetime(0.5, 1)

  self.psystem:setLinearAcceleration(-15, 0, 15, 80)

  self.psystem:setAreaSpread('normal', 10, 10)
end

function Brick:hit()
  -- particle explosion on hit
  self.psystem:setColors(
    paletteColors[self.color].r,
    paletteColors[self.color].g,
    paletteColors[self.color].b,
    55 * (self.tier + 1),
    paletteColors[self.color].r,
    paletteColors[self.color].g,
    paletteColors[self.color].b,
    0
  )
  self.psystem:emit(64)

  -- sound on hit
  gSounds['brick-hit-2']:stop()
  gSounds['brick-hit-2']:play()

  -- if we're at a higher tier than the base, we need to go down a tier
  -- if we're already at the lowest color, else just go down a color
  if self.tier > 0 then
      if self.color == 1 then
          self.tier = self.tier - 1
          self.color = 5
      else
          self.color = self.color - 1
      end
  else
      -- if we're in the first tier and the base color, remove brick from play
      if self.color == 1 then
          self.inPlay = false
      else
          self.color = self.color - 1
      end
  end

  -- play a second layer sound if the brick is destroyed
  if not self.inPlay then
      gSounds['brick-hit-1']:stop()
      gSounds['brick-hit-1']:play()
  end
end

function Brick:update(dt)
  self.psystem:update(dt)
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(gImages['main'],
    gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
    self.x, self.y)
  end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end

PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
  self.x = VIRTUAL_WIDTH + 32
  self.y = y

  self.pipes = {
    ['top'] = Pipe('top', self.y),
    ['bot'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
  }

  self.remove = false

  -- flag that it's score has been counted
  self.scored = false
end

function PipePair:update(dt)
  self.x = self.x - PIPE_SPEED * dt
  self.pipes['top'].x = self.x
  self.pipes['bot'].x = self.x

  if self.x < -PIPE_WIDTH then
    self.remove = true
  end
end

function PipePair:render()
  for k, pipe_pair in pairs(self.pipes) do
    pipe_pair:render()
  end
end

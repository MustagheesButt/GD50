PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:init()
    self.paddle_skin_counter = 1
    self.paddle_size_counter = 1
    self.passed_params = {}
end

function PaddleSelectState:enter(params)
    self.passed_params = params
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.passed_params.paddle.skin = self.paddle_skin_counter
        self.passed_params.paddle.size = self.paddle_size_counter
        self.passed_params.paddle.width = PADDLE_SIZES[self.paddle_size_counter]
        gStateMachine:change('serve', self.passed_params)
    end

    -- change paddle config
    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
        if self.paddle_skin_counter > 1 then
            self.paddle_skin_counter = self.paddle_skin_counter - 1
            gSounds['select']:play()
        else
            gSounds['no-select']:play()
        end
    end

    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
        if self.paddle_skin_counter < 4 then
            self.paddle_skin_counter = self.paddle_skin_counter + 1
            gSounds['select']:play()
        else
            gSounds['no-select']:play()
        end
    end

    -- paddle size config
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        if self.paddle_size_counter > 1 then
            self.paddle_size_counter = self.paddle_size_counter - 1
            gSounds['select']:play()
        else
            gSounds['no-select']:play()
        end
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        if self.paddle_size_counter < 4 then
            self.paddle_size_counter = self.paddle_size_counter + 1
            gSounds['select']:play()
        else
            gSounds['no-select']:play()
        end
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select a paddle", 0, VIRTUAL_HEIGHT / 2 - gFonts['medium']:getHeight(), VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Use UP, DOWN, LEFT, RIGHT keys", 0, VIRTUAL_HEIGHT / 2 + gFonts['medium']:getHeight(), VIRTUAL_WIDTH, 'center')

    love.graphics.draw(gImages['main'], gFrames['paddles'][self.paddle_size_counter + 4 * (self.paddle_skin_counter - 1)], VIRTUAL_WIDTH / 2 - PADDLE_SIZES[self.paddle_size_counter]/2, VIRTUAL_HEIGHT - 40)
end
InstructionsState = Class{__includes = BaseState}

function InstructionsState:init() end

function InstructionsState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
end

function InstructionsState:render()
    love.graphics.setFont(gFonts['xlarge'])
    love.graphics.printf("Instructions", 0, 15, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Left, Right Movement: Left, Right arrow keys OR A, D.\n" ..
                        "Pause: SPACEBAR.\n" ..
                        "Paddle Size Select: UP, DOWN arrow keys.\n" ..
                        "Paddle Color Select: Left, Right arrow keys.", 0, 25 + gFonts['xlarge']:getHeight(), VIRTUAL_WIDTH, 'center')
end
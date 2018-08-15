CreditsState = Class{__includes = BaseState}

function CreditsState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
end

function CreditsState:render()
    love.graphics.setFont(gFonts['xlarge'])
    love.graphics.printf("Breakout", 0, 20, VIRTUAL_WIDTH, 'center')
    
    -- left
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Lead Developer", 20, 20 + gFonts['xlarge']:getHeight(), VIRTUAL_WIDTH, 'left')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Mustaghees Butt", 20, 20 + gFonts['xlarge']:getHeight() + gFonts['small']:getHeight() + 5, VIRTUAL_WIDTH, 'left')

    -- right
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Art Director", -20, 20 + gFonts['xlarge']:getHeight(), VIRTUAL_WIDTH, 'right')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Mustaghees Butt", -20, 20 + gFonts['xlarge']:getHeight() + gFonts['small']:getHeight() + 5, VIRTUAL_WIDTH, 'right')

    -- bot center
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Special Thanks To", 0, 20 + gFonts['xlarge']:getHeight() + gFonts['medium']:getHeight() + gFonts['small']:getHeight() + 15, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Colton Ogden", 0, 20 + gFonts['xlarge']:getHeight() + gFonts['medium']:getHeight() * 2 + gFonts['small']:getHeight() + 15 , VIRTUAL_WIDTH, 'center')
    love.graphics.printf("David J. Malan", 0, 20 + gFonts['xlarge']:getHeight() + gFonts['medium']:getHeight() * 3 + gFonts['small']:getHeight() + 15 , VIRTUAL_WIDTH, 'center')
    

end
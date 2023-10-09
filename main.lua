function love.load() --To load in at the start of the program
    target = {}
    target.x = 150
    target.y = 365
    target.radius = 50
    targetTries = 0
    targetIsHit = 0

    score = 0
    currentScore = 0
    
    timerTime = 5
    timer = 0
    timerState = 0 --0 is unstarted, 1 is started, 2 is over

    gameState = 1 -- 1 is main menu, 2 is Game started, 3 is game over screen, 4 is debug

    --Upload Sprites
    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')

    love.mouse.setVisible(true)

    joe = love.graphics.newFont("font.otf", 40)
    joe2 = love.graphics.newFont("font.otf", 25)
    love.graphics.setFont(joe)

    gameFont = love.graphics.newFont(40)
    gameFontBigger = love.graphics.newFont(60)
    gameFontSmaller = love.graphics.newFont(25)
    gameFontDebug = love.graphics.newFont(20)

    --Game over screen
    mMenu = {}
    mMenu.x = 445
    mMenu.y = 400

    pAgain = {}
    pAgain.x = 95
    pAgain.y = mMenu.y

    GameButton = {}
    GameButton.w = 260
    GameButton.h = 100

end

function love.update(dt) --Functions that runs every frame of the game

end

function love.draw() --Draws everything to the screen
    if gameState ~=4 then
        love.graphics.draw(sprites.sky, 0, 0)
    end
    love.graphics.setColor(1,1,1)

    if gameState == 1 then
        love.graphics.setFont(joe)
        love.graphics.printf("Shiny Soft Reset Counter", 0, 100, love.graphics.getWidth(), "center" )
        love.graphics.printf(hsRead("hs.txt"), 0, 150, love.graphics.getWidth(), "center" )

        love.graphics.rectangle("fill", (love.graphics.getWidth()/2) - GameButton.w/2, (love.graphics.getHeight()/2)-GameButton.h/2, GameButton.w, GameButton.h, 5, 5) -- Add 1 button

        if hsRead("hs.txt") == 0 then
            love.graphics.setColor(178/255, 178/255, 178/255)
        end
        love.graphics.rectangle("fill", (love.graphics.getWidth()/2)+10 + GameButton.w/2, (love.graphics.getHeight()/2)+12-GameButton.h/2, 74, 74, 5, 5) -- Minus 1 button

        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", (love.graphics.getWidth()/2)+20 - GameButton.w/2, 375, GameButton.w - 40, GameButton.h, 5, 5) -- Reset button

        love.graphics.setFont(joe2)
        love.graphics.print( {{0, 0, 0}, "Add 1 Soft Reset"}, (love.graphics.getWidth()/2)+15 - GameButton.w/2, (love.graphics.getHeight()/2)+30-GameButton.h/2)
        love.graphics.print( {{0, 0, 0}, "Reset"}, (love.graphics.getWidth()/2)+90 - GameButton.w/2, 405)
        love.graphics.print( {{0, 0, 0}, "-1"}, (love.graphics.getWidth()/2)+35 + GameButton.w/2, (love.graphics.getHeight()/2)+27-GameButton.h/2)


    elseif gameState == 2 then
        love.graphics.setFont(joe)
        love.graphics.printf("Are you sure you want to reset the count?", 0, 120, love.graphics.getWidth(), "center" )

        love.graphics.setColor(0,1,0)
        love.graphics.rectangle("fill", (love.graphics.getWidth()/2)+20 - GameButton.w/2, 245, GameButton.w - 40, GameButton.h,5, 5)
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", (love.graphics.getWidth()/2)+20 - GameButton.w/2, 350, GameButton.w - 40, GameButton.h, 5 ,5)
        love.graphics.setColor(1,1,1)

        love.graphics.setFont(joe2)
        love.graphics.print( {{0, 0, 0}, "Yes"}, (love.graphics.getWidth()/2)+110 - GameButton.w/2, 275)
        love.graphics.print( {{0, 0, 0}, "No"}, (love.graphics.getWidth()/2)+112 - GameButton.w/2, 380)
    end
end

function love.mousepressed( x, y, button, istouch, presses)
    if button == 1 and gameState == 1 then
        if x > (love.graphics.getWidth()/2) - GameButton.w/2 and x < (love.graphics.getWidth()/2) - GameButton.w/2 +GameButton.w and y > (love.graphics.getHeight()/2)-GameButton.h/2 and y < (love.graphics.getHeight()/2)-GameButton.h/2 + GameButton.h then
            score = hsRead("hs.txt") +1
            hsReplace("hs.txt", score)

        elseif x > (love.graphics.getWidth()/2)+20 - GameButton.w/2 and x < (love.graphics.getWidth()/2)+20 - GameButton.w/2 + GameButton.w - 40 and y > 375 and y < 375 + GameButton.h then
            gameState = 2
        elseif x > (love.graphics.getWidth()/2)+10 + GameButton.w/2 and x < (love.graphics.getWidth()/2)+84 + GameButton.w/2 and y > (love.graphics.getHeight()/2)+12-GameButton.h/2 and y < (love.graphics.getHeight()/2)+86-GameButton.h/2 then
            if hsRead("hs.txt") > 0 then
                score = hsRead("hs.txt")
                score = score - 1
                hsReplace("hs.txt", score)
            else
                hsReplace("hs.txt", 0)
            end
        end

    elseif button == 1 and gameState == 2 then
        if x > (love.graphics.getWidth()/2)+20 - GameButton.w/2 and x < (love.graphics.getWidth()/2) - GameButton.w/2 + GameButton.w - 20 and y > 245 and y < 245 + GameButton.h then
            hsClearHs()
            gameState=1
        elseif x > (love.graphics.getWidth()/2)+20 - GameButton.w/2 and x < (love.graphics.getWidth()/2) - GameButton.w/2 + GameButton.w - 20 and y > 350 and y < 350 + GameButton.h then
            gameState = 1
        end
    end

end

--Functions relating to writing the highscore to a .txt file
function hsRead(file) --Reads the file and extracts all numbers
    local hsTxt = io.open(file, "r")
    local storedHs = hsTxt:read("*n")
    hsTxt:close()
    return storedHs
end

function hsReplace(file, newHs) -- Replaces the value in file by the value of the newHs parameter
    local hsTxt = io.open(file, "w")
    io.output(hsTxt)
    io.write(newHs)
    io.close(hsTxt)
end

function hsClearHs() --Debug Function to clear high score
    local hsTxt = io.open("hs.txt", "w")
    io.output(hsTxt)
    io.write(0)
    io.close(hsTxt)
end
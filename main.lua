local CELL_SIZE = 20
local GRID_WIDTH = 30
local GRID_HEIGHT = 20
local SCREEN_WIDTH = GRID_WIDTH * CELL_SIZE
local SCREEN_HEIGHT = GRID_HEIGHT * CELL_SIZE

local snake
local food
local direction
local nextDirection
local timer
local gameOver

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("Snake Game")
    resetGame()
end

function resetGame()
    snake = {
        {x = 5, y = 5},
        {x = 4, y = 5},
        {x = 3, y = 5}
    }
    direction = 'right'
    nextDirection = direction
    timer = 0
    gameOver = false
    spawnFood()
end

function spawnFood()
    food = {
        x = love.math.random(1, GRID_WIDTH),
        y = love.math.random(1, GRID_HEIGHT)
    }
    for _, segment in ipairs(snake) do
        if segment.x == food.x and segment.y == food.y then
            spawnFood()
            break
        end
    end
end

function love.update(dt)
    if gameOver then
        if love.keyboard.isDown("r") then
            resetGame()
        end
        return
    end

    timer = timer + dt
    if timer >= 0.1 then
        timer = timer - 0.1
        moveSnake()
    end

    if direction == 'right' then
        nextDirection = love.keyboard.isDown("up") and 'up' or (love.keyboard.isDown("down") and 'down' or 'right')
    elseif direction == 'left' then
        nextDirection = love.keyboard.isDown("up") and 'up' or (love.keyboard.isDown("down") and 'down' or 'left')
    elseif direction == 'up' then
        nextDirection = love.keyboard.isDown("left") and 'left' or (love.keyboard.isDown("right") and 'right' or 'up')
    elseif direction == 'down' then
        nextDirection = love.keyboard.isDown("left") and 'left' or (love.keyboard.isDown("right") and 'right' or 'down')
    end
end

function moveSnake()
    direction = nextDirection
    local head = snake[1]
    local newHead = {x = head.x, y = head.y}

    if direction == 'right' then
        newHead.x = newHead.x + 1
    elseif direction == 'left' then
        newHead.x = newHead.x - 1
    elseif direction == 'up' then
        newHead.y = newHead.y - 1
    elseif direction == 'down' then
        newHead.y = newHead.y + 1
    end

    if newHead.x < 1 or newHead.x > GRID_WIDTH or newHead.y < 1 or newHead.y > GRID_HEIGHT then
        gameOver = true
        return
    end

    for _, segment in ipairs(snake) do
        if segment.x == newHead.x and segment.y == newHead.y then
            gameOver = true
            return
        end
    end

    table.insert(snake, 1, newHead)

    if newHead.x == food.x and newHead.y == food.y then
        spawnFood()
    else
        table.remove(snake)
    end
end

function love.draw()
    for _, segment in ipairs(snake) do
        love.graphics.rectangle('fill', (segment.x - 1) * CELL_SIZE, (segment.y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', (food.x - 1) * CELL_SIZE, (food.y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    love.graphics.setColor(1, 1, 1)

    if gameOver then
        love.graphics.printf("Game Over! Press R to Restart", 0, SCREEN_HEIGHT / 2 - 10, SCREEN_WIDTH, "center")
    end
end

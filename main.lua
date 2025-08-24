-- Now renders a tiny retro "pixel alien" made from a grid of pixels.

local win = { w = 800, h = 600 }

-- Pixel-art pattern (8x8). Characters:
-- 'X' = bright green pixel, 'O' = eye (white), '.' = transparent / skip
local alienPattern = {
    "..XX..",
    ".XXXX.",
    "XXOOXX",  -- row with eyes (O)
    "XXXXXX",
    "XX..XX",
    "XXXXXX",
    ".X..X.",
    "X....X"
}

local scale = 8  -- size of each logical pixel in screen pixels

local colors = {
    X = {0, 1, 0, 1},  -- green body
    O = {1, 1, 1, 1}   -- white eyes
}

local sprite = {
    w = #alienPattern[1],
    h = #alienPattern
}

local origin = { x = 0, y = 0 } -- will be computed to center the alien
local baseY = 0 -- baseline centered Y (without animation offset)

-- Animation state
local t = 0           -- elapsed time (seconds)
local freq = 1.2      -- jump / bob frequency (cycles per second)
local amplitudeFactor = 1.8 -- multiplied by scale to get amplitude
local paused = false

function love.load()
    love.window.setTitle("Pixel Alien")
    origin.x = math.floor((win.w - sprite.w * scale) / 2)
    baseY = math.floor((win.h - sprite.h * scale) / 2)
    origin.y = baseY
    love.graphics.setBackgroundColor(0, 0, 0, 1)
end

local function drawAlien()
    for row = 1, sprite.h do
        local line = alienPattern[row]
        for col = 1, sprite.w do
            local ch = line:sub(col, col)
            if ch ~= '.' then
                local c = colors[ch] or colors.X
                love.graphics.setColor(c)
                love.graphics.rectangle('fill', origin.x + (col-1)*scale, origin.y + (row-1)*scale, scale, scale)
            end
        end
    end
end

function love.draw()
    drawAlien()
end

function love.update(dt)
    if paused then return end
    t = t + dt
    local amplitude = math.max(2, math.floor(scale * amplitudeFactor))
    -- Smooth bobbing (sinusoidal). Use full sine wave for continuous jump illusion.
    local offset = math.sin(t * freq * math.pi * 2) * amplitude
    origin.y = baseY + math.floor(offset)
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
    if key == '+' or key == '=' then
        scale = math.min(64, scale + 1)
        origin.x = math.floor((win.w - sprite.w * scale) / 2)
        baseY = math.floor((win.h - sprite.h * scale) / 2)
    elseif key == '-' then
        scale = math.max(1, scale - 1)
        origin.x = math.floor((win.w - sprite.w * scale) / 2)
        baseY = math.floor((win.h - sprite.h * scale) / 2)
    elseif key == 'space' then
        paused = not paused
        if not paused then
            -- Reset baseline so alien resumes centered path smoothly
            baseY = math.floor((win.h - sprite.h * scale) / 2)
        end
    end
end

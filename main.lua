-- main.lua
-- ===== Local aliases (micro-optimizations in hot paths) =====
local lg, lk, lt = love.graphics, love.keyboard, love.timer
local floor = math.floor

-- ====== Config you can tweak later or move to config.lua ======
local WORLD_W, WORLD_H = 320, 180  -- internal render size (great for pixel art)
local FIXED_DT = 1/60               -- fixed update step (deterministic)
local MAX_DT   = 1/10               -- clamp huge frame gaps
local SCALE_TO_WINDOW = true        -- render-to-canvas scaling

-- ====== Optional pixel-perfect canvas pipeline ======
local worldCanvas

-- ====== Minimal debug overlay ======
local showDebug = true

-- ====== Micro Input Mapper (expand later) ======
local Input = {
  pressed = {},
  down = {},
  map = {
    toggle_debug = "f3",
    quit = "escape",
    fullscreen = "f11",
  }
}
function Input.keypressed(k)
  Input.pressed[k] = true
  Input.down[k] = true
end
function Input.keyreleased(k)
  Input.down[k] = nil
end
function Input.get(action)       -- edge (just-pressed)
  local key = Input.map[action]; return key and Input.pressed[key]
end
function Input.isDown(action)    -- held
  local key = Input.map[action]; return key and Input.down[key]
end
function Input.update()          -- clear edge flags each frame
  for k in pairs(Input.pressed) do Input.pressed[k] = nil end
end

-- ====== Tiny Scene Stack (inline; later move to src/core/scene.lua) ======
local Scene = { stack = {} }
local function current() return Scene.stack[#Scene.stack] end
function Scene.push(s, ...)
  if s.enter then s:enter(...) end
  Scene.stack[#Scene.stack+1] = s
end
function Scene.pop(...)
  local top = table.remove(Scene.stack)
  if top and top.exit then top:exit(...) end
end
function Scene.swap(s, ...)
  Scene.pop()
  Scene.push(s, ...)
end
function Scene.update(dt) local c=current(); if c and c.update then c:update(dt) end end
function Scene.draw()     local c=current(); if c and c.draw   then c:draw()     end end
function Scene.keypressed(k)
  local c=current(); if c and c.keypressed then c:keypressed(k) end
end

-- ====== Example Scene so the game runs now ======
local TitleScene = {}
function TitleScene:enter()
  self.blink = 0
end
function TitleScene:update(dt)
  self.blink = self.blink + dt
  if Input.get("quit") then love.event.quit() end
  if Input.get("fullscreen") then
    local f = not lg.isFullscreen()
    lg.setMode(0, 0, { fullscreen = f, fullscreentype = "desktop", resizable = true })
  end
  if lk.isDown("return") or lk.isDown("space") then
    Scene.swap(require("play_scene_fallback")()) -- see fallback below
  end
end
function TitleScene:draw()
  local w, h = lg.getDimensions()
  lg.clear(0.08, 0.1, 0.12, 1)
  lg.printf("My LÖVE Game", 0, h*0.35, w, "center")
  if floor(self.blink*2)%2==0 then
    lg.printf("Press Enter/Space", 0, h*0.55, w, "center")
  end
end

-- ====== Fallback “play scene” if you haven't created modules yet ======
package.preload["play_scene_fallback"] = function()
  local S = { t = 0, x = 40, y = 90 }
  function S:update(dt)
    self.t = self.t + dt
    local speed = 60
    if lk.isDown("a") or lk.isDown("left")  then self.x = self.x - speed*dt end
    if lk.isDown("d") or lk.isDown("right") then self.x = self.x + speed*dt end
    if lk.isDown("w") or lk.isDown("up")    then self.y = self.y - speed*dt end
    if lk.isDown("s") or lk.isDown("down")  then self.y = self.y + speed*dt end
    if Input.get("quit") then love.event.quit() end
  end
  function S:draw()
    lg.clear(0.05, 0.06, 0.07, 1)
    lg.setColor(1,1,1,1)
    lg.print("Play Scene (fallback). Move with WASD/Arrows. Esc quits.", 8, 8)
    -- draw a bouncing square
    lg.rectangle("fill", self.x + math.sin(self.t)*20, self.y, 16, 16)
  end
  return function() return S end
end

-- ====== Fixed timestep accumulator ======
local acc = 0

-- ====== love.* callbacks ======
function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setTitle("My LÖVE Game")
  math.randomseed(os.time())

  if SCALE_TO_WINDOW then
    worldCanvas = lg.newCanvas(WORLD_W, WORLD_H)
  end

  Scene.push(TitleScene)
end

function love.update(dt)
  -- Clamp huge dt jumps (alt-tab, breakpoint) to avoid spiraling
  if dt > MAX_DT then dt = MAX_DT end

  -- Input edge tracking
  Input.update()

  -- Fixed update steps
  acc = acc + dt
  while acc >= FIXED_DT do
    Scene.update(FIXED_DT)
    acc = acc - FIXED_DT
  end

  -- Toggles not tied to fixed step
  if Input.get("toggle_debug") then showDebug = not showDebug end
end

function love.draw()
  if SCALE_TO_WINDOW then
    lg.setCanvas(worldCanvas)
    lg.clear(0,0,0,1)
  end

  Scene.draw()

  if SCALE_TO_WINDOW then
    lg.setCanvas()
    local ww, wh = lg.getDimensions()
    local sx, sy = ww / WORLD_W, wh / WORLD_H
    local scale = math.floor(math.min(sx, sy))  -- pixel-perfect integer scale
    if scale < 1 then scale = math.min(sx, sy) end
    local dw, dh = WORLD_W * scale, WORLD_H * scale
    local ox, oy = (ww - dw) * 0.5, (wh - dh) * 0.5
    lg.draw(worldCanvas, ox, oy, 0, scale, scale)
  end

  if showDebug then
    drawDebugOverlay()
  end
end

function love.keypressed(k, sc, rep)
  Input.keypressed(k)
  Scene.keypressed(k)
end

function love.keyreleased(k)
  Input.keyreleased(k)
end

-- ====== Debug Overlay ======
function drawDebugOverlay()
  local fps = lt.getFPS()
  local memKB = collectgarbage("count")
  lg.setColor(0,0,0,0.6)
  lg.rectangle("fill", 8, 8, 210, 60, 6, 6)
  lg.setColor(1,1,1,1)
  lg.print(("FPS: %d"):format(fps), 16, 16)
  lg.print(("Mem: %.1f MB"):format(memKB/1024), 16, 34)
  lg.print(("Scenes: %d"):format(#Scene.stack), 16, 52)
end

-- conf.lua
-- LÖVE configuration file

function love.conf(t)
    t.identity = nil            -- save directory (string)
    t.appendidentity = false
    t.version = "11.5"          -- specify LÖVE version
    t.console = false

    t.window.title = "Green Pixel"
    t.window.width = 800
    t.window.height = 600
    t.window.vsync = 1
    t.window.resizable = false
    t.window.highdpi = true

    t.modules.joystick = false
    t.modules.physics = false
end

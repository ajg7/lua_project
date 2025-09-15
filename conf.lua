function love.conf(t) 
  t.identity = "gloom_and_utter_darkness"
  t.appendidentity = false
  t.version = "11.4"

  --Window
  t.window.title = "Gloom and Utter Darkness"
  t.window.icon = nil
  t.window.width = 1280
  t.window.height = 720
  t.window.minwidth = 640
  t.window.minheight = 360
  t.window.resizable = true
  t.window.vsync = 1
  t.window.highdpi = true
  t.window.msaa = 0
  t.window.fullscreetype = "desktop"
  t.window.depth = nil
  t.window.stencil = true

  t.audio.mic = false
  t.audio.mixwithsystem = true

  t.console = true

  t.modules.physics = false
  t.modules.joystick = true
  t.modules.touch = true
  t.modules.video = false
end
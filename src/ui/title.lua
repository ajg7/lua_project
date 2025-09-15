local Title = {}

function Title:load() 
  self.message = "Gloom and Utter Darkness"
  self.prompt = "Press Enter to Start"
end

function Title:update(dt)
  if love.keyboard.isDown("return") then
    -- Switch to the main game scene
    return "game"
  end
  return "title"
end


function Title:draw()
    love.graphics.printf(self.message, 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf(self.prompt, 0, 300, love.graphics.getWidth(), "center")
end

return Title
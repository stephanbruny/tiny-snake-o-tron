local scene = {}
local onExit = nil;
local data = require "data"
local tween = require "tween"

local textColor, colorTween;

function scene.load(exit)
  onExit = exit;
  textColor = {r = 0, g = 0, b = 0}
  colorTween = tween.new(4, textColor, {r = 255, g = 255, b = 255}, "inQuad");
end

function scene.update(delta)
  if (colorTween:update(delta)) then
    love.timer.sleep(2);
    onExit();
  end
end

function scene.draw()
  love.graphics.setColor(255, 255, 0);  
  love.graphics.printf("Tiny Snake-O-Tron",0, 16, data.screenW,"center") -- center your text around x = 200/2 + 100 = 200

  love.graphics.setColor(textColor.r, textColor.g, textColor.b);
  love.graphics.printf("Franz Joy Games",0, data.screenH / 2 - 14, data.screenW,"center") -- center your text around x = 200/2 + 100 = 200
end

return scene;
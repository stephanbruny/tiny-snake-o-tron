local scene = {}
local onExit = nil;
local data = require "data"
local tween = require "tween"

local textColor, colorTween;

function scene.getResolution()
  return data.screenW, data.screenH;
end

function scene.load(exit)
  onExit = exit;
  textColor = {r = 0, g = 0, b = 0}
  colorTween = tween.new(4, textColor, {r = 255, g = 255, b = 255}, "inQuad");
end

function scene.update(delta)
  if (colorTween:update(delta)) then
    love.timer.sleep(2);
    onExit(require "title-scene");
  end
end

function scene.draw()
  r, g, b = love.graphics.getColor();
  love.graphics.setColor(textColor.r, textColor.g, textColor.b);
  love.graphics.printf("Franz Joy Games",0, data.screenH / 2 - 14, data.screenW,"center") -- center your text around x = 200/2 + 100 = 200
  love.graphics.setColor(r, g, b);
end

function scene.keypressed(key)
  onExit(require "title-scene");
end

return scene;
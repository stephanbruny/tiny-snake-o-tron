local data = require "data"

local splashScene = require "splash";
local gameScene = require "game-scene"

local currentScene = nil;

function loadSplashScene()
  splashScene.load(function()
    loadScene(gameScene, exitGameScene);
  end)
  currentScene = splashScene;
end

function love.load()
  love.graphics.setFont(data.gameFont);
  love.window.setTitle("Snake-O-Tron");
  loadSplashScene()
end

function exitGameScene()
  love.quit();
end

function exitScene(nextScene)
  if nextScene then loadScene(nextScne) else loadSplashScene() end
end

function loadScene(scene, exit)
  currentScene = scene;
  currentScene.load(exit);
end

function love.draw()
  if currentScene then currentScene.draw();
    local w, h = data.screenW, data.screenH;
    if (currentScene.getResolution) then
      w, h = currentScene.getResolution();
    end

    local canvas = love.graphics.newCanvas(w, h);
    love.graphics.setCanvas(canvas);
    
    love.graphics.setCanvas();

    return love.graphics.draw(canvas, 0, 0, 0, data.screenW / w, data.screenH / h);
  end
  love.graphics.printf("No scene loaded",0, data.screenH / 2 - 14, data.screenW,"center") -- center your text around x = 200/2 + 100 = 200
end

function love.update()
  local delta = love.timer.getDelta();
  if currentScene then currentScene.update(delta); end
end

function love.keypressed(key)
  if (currentScene and currentScene.keypressed) then
    currentScene.keypressed(key);
  end
end
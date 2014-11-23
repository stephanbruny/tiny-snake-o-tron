local data = require "data"

local splashScene = require "splash";
local gameScene = require "game-scene"
local titleScene = require "title-scene"

local currentScene = nil;

local sceneW, sceneH = data.screenW, data.screenH;
local sceneCanvas = love.graphics.newCanvas(sceneW, sceneH);

function love.load()
  love.window.setMode(data.screenW, data.screenH)
  love.graphics.setFont(data.gameFont);
  love.window.setTitle("Snake-O-Tron");
  loadScene(splashScene, exitScene);
end

function exitGameScene()
  love.quit();
end

function exitScene(nextScene)
  love.audio.stop();
  if nextScene then loadScene(nextScene, exitScene) else loadSplashScene() end
end

function loadScene(scene, exit)
  currentScene = scene;
  currentScene.load(exit);
  if (currentScene.getResolution) then
    sceneW, sceneH = currentScene.getResolution();
  end
  sceneCanvas = love.graphics.newCanvas(sceneW, sceneH);
end

function love.draw()
  if currentScene then
    sceneCanvas:clear();
    love.graphics.setCanvas(sceneCanvas);
    currentScene.draw();
    love.graphics.setCanvas();

    return love.graphics.draw(sceneCanvas, 0, 0, 0, data.screenW / sceneW,  data.screenH / sceneH);
  end
  love.graphics.printf("No scene loaded",0, data.screenH / 2 - 14, data.screenW,"center")
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

function love.quit()
  print ("Tiny Snake-O-Tron (C) 2014 Stephan Bruny")
end
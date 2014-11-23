local scene = {}
local onExit = nil;
local data = require "data"
local tween = require "tween"
local audio = require "audio"

local nextScene = nil;

local currentMenu, mainMenu, optionsMenu;

local currentMenuNode = 1;

local difficultyMenu = {
  {
    title = "Slow",
    onSelect = function()
      data.speed = data.difficulty.slow;
      onExit(require "game-scene");
    end
  },
  {
    title = "Normal",
    onSelect = function()
      data.speed = data.difficulty.normal;
      onExit(require "game-scene");
    end
  },
  {
    title = "Fast",
    onSelect = function()
      data.speed = data.difficulty.fast;
      onExit(require "game-scene");
    end
  },
  {
    title = "Extreme",
    onSelect = function()
      data.speed = data.difficulty.extreme;
      onExit(require "game-scene");
    end
  },
  {
    title = "Back",
    onSelect = function()
      currentMenu = mainMenu;
    end
  }
}

mainMenu = {
  {
    title = "Start Game",
    onSelect = function()
      currentMenu = difficultyMenu;
    end
  },
  {
    title = "Options",
    onSelect = function()
      currentMenu = optionsMenu;
    end
  },
  {
    title = "Exit",
    onSelect = function()
      love.event.quit();
    end
  }
}

optionsMenu = {
  {
    title = "Back",
    onSelect = function()
      currentMenu = mainMenu;
    end
  }
}

local textColor, colorTween;

function scene.getResolution()
  return data.screenW, data.screenH;
end

function scene.load(exit)
  onExit = exit;
  textColor = {r = 255, g = 255, b = 255}
  currentMenu = mainMenu;
  audio.load("title-music", "music/MainTheme.wav");
  audio.load("menu-move", "music/sfx/menu.wav");
  audio.load("menu-select", "music/sfx/select.wav");
  audio.play("title-music", true, data.musicVolume);
end

function scene.update(delta)

end

local function drawMenu(menu)
  for i, node in pairs(menu) do
    love.graphics.setColor(214, 214, 214);
    if i == currentMenuNode then
      love.graphics.setColor(255, 214, 0);
    end
    love.graphics.printf(node.title,0, data.screenH / 2 - 10 + i * 10, data.screenW,"center");
  end
end

--colorTween = tween.new(1, textColor, {r = 255, g = 255, b = 255}, "inQuad");
function scene.draw()
  r, g, b = love.graphics.getColor();
  love.graphics.setColor(255, 255, 0);  
  love.graphics.printf("Tiny Snake-O-Tron",0, 16, data.screenW,"center");
  drawMenu(currentMenu);
  love.graphics.setColor(r, g, b);
end

function scene.keypressed(key)
  if key == "down" then
    currentMenuNode = currentMenuNode + 1;
    audio.play("menu-move")
  end

  if key == "up" then
    currentMenuNode = currentMenuNode - 1;
    audio.play("menu-move")
  end

  if key == "return" then
    audio.play("menu-select")
    currentMenu[currentMenuNode].onSelect();
    currentMenuNode = 1;
  end

  if currentMenuNode > #currentMenu then currentMenuNode = 1; end
  if currentMenuNode < 1 then currentMenuNode = #currentMenu; end
end

return scene;
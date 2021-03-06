local data = require "data" -- only mutable global data
local audio = require "audio"

math.randomseed(os.time())

local scene = {};

local onExit = nil;

local score = 0;

local function createPoint(pointList, x, y)
  table.insert(pointList, {
    x = x,
    y = y
  });
end

function scene.getResolution()
  return 800, 600;
end

local pause = false;

local function drawDot(x, y, color)
  oldR, oldG, oldB = love.graphics.getColor();
  love.graphics.setColor(color.r, color.g, color.b, 255);
  love.graphics.arc("fill", x * data.rectSize + data.rectSize / 2, y * data.rectSize + data.rectSize / 2, data.rectSize / 2, 0, math.pi * 2);
  love.graphics.setColor(oldR, oldG, oldB, 255);
end

local function drawPoints(pointList)
  for k, v in pairs(pointList) do
    drawDot(v.x, v.y, {r = 255, g = 255, b = 0});
  end
end

local function updatePoints(pointList, delta) 
  data.pointTimer = data.pointTimer + delta;
  if data.pointTimer >= data.pointDelay then
    createPoint(pointList, math.random(0, data.mapW - 1), math.random(0, data.mapH - 1));
    data.pointTimer = 0;
  end
end

local function iteratePoints(pointList, callback)
  for k, v in pairs(pointList) do callback(k, v) end
end

local function removePoint(pointList, index)
  return table.remove(pointList, index);
end

function getSpeed()
  return data.speed;
end

function increaseSpeed()
  data.speed = data.speed * 0.95;
end

function makeSnakeHead(sn)
  table.insert(sn, {x = math.floor(data.mapW/2), y = math.floor(data.mapH/2), nx = 0, ny = 0});
  --table.insert(sn, {x = math.floor(mapW/2), y = math.floor(mapH/2), nx = 0, ny = 0});
end

function makeEnemySnakeHead(sn)
  table.insert(sn, {x = math.random(0, data.mapW), y = math.random(0, data.mapH), nx = 0, ny = 0});
  --table.insert(sn, {x = math.floor(mapW/2), y = math.floor(mapH/2), nx = 0, ny = 0});
end

function addSnakeTail(sn)
  table.insert(sn, {
    x = sn[#sn].x + sn[1].nx;
    y = sn[#sn].y + sn[1].ny;
    nx = 0,
    ny = 0
  });
  return #sn;
end

function iterateSnakeTail(sn, callback)
  for k, v in pairs(sn) do
    if k > 1 then callback(k, v); end
  end
end

function scene.load(exit)
  data.snake = {};
  data.enemy = {};
  data.points = {};
  score = 0;

  makeSnakeHead(data.snake);
  makeEnemySnakeHead(data.enemy);
  
  local gameMusic = "music/HappyLevel.wav";

  if data.speed == data.difficulty.normal then gameMusic = "music/SwingingLevel.wav" end
  if data.speed == data.difficulty.fast then gameMusic = "music/FranticLevel.wav" end
  if data.speed == data.difficulty.extreme then gameMusic = "music/8BitMetal.wav" end

  audio.load("game-music", gameMusic)
  audio.load("sfx-die", "music/sfx/die.wav")
  audio.load("sfx-coin", "music/sfx/coin.wav")

  audio.play("game-music", true, data.musicVolume);
  onExit = exit;
end

function createMap(width, height)
  local result = {}
  for y = 1, height + 1, 1 do
    result[y] = {}
    for x = 1, width + 1, 1 do
      result[y][x] = 0
    end
  end
  return result;
end

function drawGameMap(w, h, size)
  r, g, b = love.graphics.getColor();
  love.graphics.setColor(0, 0, 64, 255);
  love.graphics.rectangle("fill", 0, 0, w * size, h * size);
  love.graphics.setColor(r, g, b, 255);
end

function decreaseUntilZero(var, val)
  if (var > 1) then var = var - val; end
  return var;
end

function darkenColor(color, value) 
  color.r = decreaseUntilZero(color.r, value);
  color.g = decreaseUntilZero(color.g, value);
  color.b = decreaseUntilZero(color.b, value);
  return color;
end

function drawSnake(sn, snColor)
  snr, sng, snb = snColor.r, snColor.g, snColor.b;

  for i=1, #sn, 1 do
    if (sn[i].dead) then 
      snColor = {r = 255, g = 0, b = 0}
    end
    local newColor = darkenColor({r = snColor.r, g = snColor.g, b = snColor.b}, i);
    drawDot(sn[i].x, sn[i].y, newColor);

  end
end

function scene.draw()
  drawGameMap(data.mapW, data.mapH, data.rectSize);
  local w, h = scene.getResolution();
  love.graphics.printf("Score: " .. score,0, h -  40, w,"center")

  drawSnake(data.snake, {r = 0, g = 255, b = 0})
  drawSnake(data.enemy, {r = 255, g = 255, b = 255})
  drawPoints(data.points);

  if data.snake[1].dead then
    love.graphics.setColor(0, 0, 0, 128);
    love.graphics.rectangle("fill", 0, 0, w, h);
    love.graphics.setColor(255, 214, 0);
    love.graphics.printf("Your snake died to deadly death. Press ESC to quit game.",0, h/2 -  10, w,"center")
    love.graphics.setColor(255, 255, 255, 255);
  end

end

function updateSnakeElement(el, prev)
  el.oldX = el.x;
  el.oldY = el.y;
  el.x = prev.oldX;
  el.y = prev.oldY;
  if (prev.dead) then el.dead = true; end
  return el;
end

function updateSnake(sn)
  if (not sn[1].dead) then
    sn[1].oldX, sn[1].oldY = sn[1].x, sn[1].y;
    sn[1].x = sn[1].x + sn[1].nx;
    sn[1].y = sn[1].y + sn[1].ny;
  end

  if sn[1].x > data.mapW - 1 then sn[1].x = 0; end
  if sn[1].y > data.mapH - 1 then sn[1].y = 0; end
  if sn[1].x < 0 then sn[1].x = data.mapW - 1; end
  if sn[1].y < 0 then sn[1].y = data.mapH - 1; end

  for i=2, #sn, 1 do
    local currentElement = updateSnakeElement(sn[i], sn[i-1]);
    if currentElement.x == sn[1].x and currentElement.y == sn[1].y then
      sn[1].dead = true;
      audio.play("sfx-die", false, data.sfxVolume);
    end
  end
end

function updatePlayer(sn)
  iterateSnakeTail(data.enemy, function(index, e)
    if sn[1].x == e.x and sn[1].y == e.y then
      sn[1].dead = true;
      audio.play("sfx-die", false, data.sfxVolume);
    end
  end)
  if sn[1].dead then
    if #sn > 1 then 
      return table.remove(sn, #sn);
    else
      -- absolutely dead
    end
  end
  updateSnake(sn);
end

function scene.update(delta)
  if pause then return; end
  data.timer = data.timer + delta;
  if (data.timer >= getSpeed()) then
    updatePlayer(data.snake);
    updateEnemy(data.enemy, data.points);
    data.timer = 0;
  end

  updatePoints(data.points, delta);
  iteratePoints(data.points, function(index, point) 
    if point.x == data.snake[1].x and point.y == data.snake[1].y then
      addSnakeTail(data.snake);
      audio.play("sfx-coin", false, data.sfxVolume);
      score = score + data.coinValue;
      removePoint(data.points, index);
      createPoint(data.points, math.random(0, data.mapW - 1), math.random(0, data.mapH - 1));
    end
  end);

end

function findRandomPoint(pointList)
  r = math.random(1, #pointList);
  return pointList[r];
end

function setEnemyGoal(sn, point)
  sn[1].goal = point;
end

function preventSnakeSuicide(head, sn)
  for i, e in pairs(sn) do
    if i > 1 and head.x + head.nx == e.x and head.y + head.ny == e.y then -- collision ahead?
      if head.x + head.nx == e.x then head.nx = 0; end
      if head.y + head.ny == e.y then head.ny = 0; end
      if head.nx == 0 then
        if head.y + 1 == e.y then head.ny = -1; head.nx = 0; end
        if head.y - 1 == e.y then head.ny = 1; head.nx = 0; end
      end
      if head.ny == 0 then
        if head.x + 1 == e.x then head.nx = -1; head.ny = 0; end
        if head.x - 1 == e.x then head.nx = 1; head.ny = 0; end
      end
      -- preventSnakeSuicide(head, sn);
      head.goal = nil;
      break;
    end
  end
end

function findNearestPoint(head, pointList)
  result = pointList[1];
  compDist = nil;
  iteratePoints(pointList, function(index, p)
    dist = math.abs(head.x - p.x + head.y - p.y);
    if nil == compDist then compDist = dist; end
    if dist < compDist then
      result = p;
      compDist = dist;
    end
  end);
  return result;
end

function findPath(head)
  local distX = math.abs(head.goal.x - head.x);
  local distY = math.abs(head.goal.y - head.y);
  if distX > distY then
    head.ny = 0;
    if head.goal.x > head.x then head.nx = 1;
    elseif head.goal.x < head.x then head.nx = -1; end
    return;
  end
  if distX < distY then
    head.nx = 0;
    if head.goal.y > head.y then head.ny = 1;
    elseif head.goal.y < head.y then head.ny = -1; end
    return;
  end
end

function updateEnemy(sn, pointList)
  local goalExists = false;
  
  if sn[1].dead then 
    if #sn > 1 then
      return table.remove(sn, #sn);
    else
      sn[1].dead = false;
      iterateSnakeTail(data.snake, function(i, e) 
        if sn[1].x == e.x and sn[1].y == e.y then
          sn[1].dead = true;
        end
      end);
    end
  end

  iterateSnakeTail(data.snake, function(index, e)
    if sn[1].x == e.x and sn[1].y == e.y then
      
      if not sn[1].dead then 
        audio.play("sfx-die", false, data.sfxVolume);
        score = score + data.killEnemyValue
      end

      sn[1].dead = true;
    end
  end)

  iteratePoints(pointList, function(index, p) 
    if sn[1].goal and (p.x == sn[1].goal.x and p.y == sn[1].goal.y) then
      goalExists = true;
    end

    if sn[1].x == p.x and sn[1].y == p.y then
      addSnakeTail(sn);
      removePoint(pointList, index);
    end
  end) -- iterate points

  if not goalExists then sn[1].goal = nil; end

  if nil ~= sn[1].goal then
    findPath(sn[1])
  else
    sn[1].goal = findNearestPoint(sn[1], pointList);
  end
  -- if sn[1].nx ~= 0 then sn[1].ny = 0; end
  preventSnakeSuicide(sn[1], data.snake);
  preventSnakeSuicide(sn[1], sn);
  return updateSnake(sn); 
end

function scene.keypressed(key)
  
  if key == "left" then
    data.snake[1].nx = -1
    data.snake[1].ny = 0;
  end
  
  if key == "right" then
    data.snake[1].nx = 1
    data.snake[1].ny = 0;
  end
  
  if key == "down" then
    data.snake[1].nx = 0
    data.snake[1].ny = 1;
  end

  if key == "up" then
    data.snake[1].nx = 0
    data.snake[1].ny = -1;
  end

  if key == "s" then
    addSnakeTail(data.snake);
  end

  if key == "p" then
    pause = not pause;
  end

  if key == "escape" then
    onExit(require "splash");
  end
end

return scene;
return {
  speed = 0.15,
  difficulty = {
    slow = 0.2,
    normal = 0.15,
    fast = 0.08,
    extreme = 0.02
  },
  rectSize = 8,
  mapW = 100,
  mapH = 64,
  gameFont = love.graphics.newFont("8-bit.ttf", 16),
  snake = {},
  timer = 0,
  pointTimer = 0,
  pointDelay = 2,
  points = {},
  enemy = {},
  screenW = 800,
  screenH = 600
}
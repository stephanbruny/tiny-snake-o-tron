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
  screenW = 1280,
  screenH = 1024,
  musicVolume = 0.6,
  sfxVolume = 0.6,
  coinValue = 15,
  killEnemyValue = 1000
}
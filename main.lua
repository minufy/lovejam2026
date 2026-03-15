Class = require("modules.hump.class")

Physics = require("objects.physics")
Particle = require("objects.particle")
require("stuff.camera")
require("stuff.input")
require("stuff.res")
require("stuff.sm")
require("stuff.utils")
require("stuff.shaders")

function love.load()
    LogFont = love.graphics.newFont(20)
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 20)
    FontBold = love.graphics.newFont("assets/fonts/Galmuri11-Bold.ttf", 48)
    TILE_SIZE = 16

    COLOR = {}
    COLOR.TEXT = rgb(244, 229, 225)
    COLOR.BG = rgb(52, 42, 43)
    COLOR.WALL = rgb(202, 156, 141)
    COLOR.SCORE = rgb(75, 141, 173)
    COLOR.SPIKE = rgb(248, 108, 76)
    COLOR.PLAYER = rgb(244, 229, 225)

    -- NewAudio("jump")

    Res:init()
    
    SM:load("game.game")

    math.randomseed(love.timer.getTime())
end

function love.update(dt)
    dt = math.min(dt*60, 1.5)
    UpdateInputs()
    Camera:update(dt)
    SM:update(dt)
    ResetWheelInput()
    UpdateLog(dt)
end

function love.draw()
    Res:before()
    SM:draw()
    Res:after()
    DrawLog()
end
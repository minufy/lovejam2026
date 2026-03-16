Game = {}

Edit = require("scenes.game.edit")
Level = require("scenes.game.level")

local Wall = require("objects.wall")
local Spike = require("objects.spike")
local Score = require("objects.score")
local LaserWarning = require("objects.laser_warning")

local directions = {-1, 1}

function Game:add(Object, ...)
    local o = Object(...)
    local group_name = o.group_name
    if self.objects[group_name] == nil then
        self.objects[group_name] = {}
    end
    table.insert(self.objects[group_name], o)
    return o
end

function Game:init()
    self.objects = {}
    Edit:init()
    Level:init()
    self:reset()
    self.wall_spawner = {
        time = 40,
        timer = 0,
        queue = {}
    }
    self.spike_spawner = {
        time = 70,
        timer = 0,
        queue = {}
    }
    self.score_spawner = {
        time = 150,
        timer = 0,
        queue = {}
    }
    self.laser_spawner = {
        time = 400,
        timer = 0,
    }
end

function Game:update(dt)
    Edit:update(dt)

    if not Edit.editing then
        for group_name, _ in pairs(self.objects) do
            for i = #self.objects[group_name], 1, -1 do
                local object = self.objects[group_name][i]
                if object.update then
                    object:update(dt)
                end
                if object.remove then
                    table.remove(self.objects[group_name], i)
                end
            end
        end
    end

    self.score_scale = self.score_scale+(1-self.score_scale)*0.1*dt

    if self.dead and Input.restart.pressed then
        Level:reload()
        self:reset()
    end

    self.wall_spawner.timer = self.wall_spawner.timer+dt 
    if self.wall_spawner.timer > self.wall_spawner.time then
        self.wall_spawner.timer = 0
        if #self.wall_spawner.queue == 0 then
            for i = 2, Res.w/TILE_SIZE-3 do
                table.insert(self.wall_spawner.queue, i)
            end
        end
        local direction = directions[math.random(1, 2)]
        self:add(Wall, table.remove(self.wall_spawner.queue, math.random(1, #self.wall_spawner.queue))*TILE_SIZE, Res.h*(1-direction)/2, direction)
    end

    self.spike_spawner.timer = self.spike_spawner.timer+dt
    if self.spike_spawner.timer > self.spike_spawner.time then
        self.spike_spawner.timer = 0
        if #self.spike_spawner.queue == 0 then
            for i = 0, Res.w/TILE_SIZE-1 do
                table.insert(self.spike_spawner.queue, i)
            end
        end
        local direction = directions[math.random(1, 2)]
        self:add(Spike, table.remove(self.spike_spawner.queue, math.random(1, #self.spike_spawner.queue))*TILE_SIZE, Res.h*(1-direction)/2, direction)
    end

    self.score_spawner.timer = self.score_spawner.timer+dt
    if self.score_spawner.timer > self.score_spawner.time then
        self.score_spawner.timer = 0
        if #self.score_spawner.queue == 0 then
            for i = 0, Res.w/TILE_SIZE-1 do
                table.insert(self.score_spawner.queue, i)
            end
        end
        local direction = directions[math.random(1, 2)]
        self:add(Score, table.remove(self.score_spawner.queue, math.random(1, #self.score_spawner.queue))*TILE_SIZE, Res.h*(1-direction)/2, direction)
    end

    self.laser_spawner.timer = self.laser_spawner.timer+dt
    if self.laser_spawner.timer > self.laser_spawner.time then
        self.laser_spawner.timer = 0
        local y = math.random(0, Res.h)
        self:add(LaserWarning, y)
    end
end

function Game:add_score(s)
    s = s or 1
    self.score_scale = 1.5
    self.score = self.score+s
    Camera:shake(1.5)
end

function Game:reset()
    self.score = 0
    self.score_scale = 1
    Game.dead = false
end

local draw_order = {
    "tiles",
    "laser",
    "laser_warning",
    "particle",
    "wall",
    "spike",
    "score",
    "player",
}

function Game:draw()
    love.graphics.setColor(COLOR.BG)
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    ResetColor()

    Shaders:start()
    
    love.graphics.setColor(Alpha(COLOR.TEXT, 0.4))
    local s1 = "score"
    love.graphics.setFont(Font)
    love.graphics.print(s1, Res.w/2-Font:getWidth(s1)/2+Camera.shake_x, Res.h/2-45-(self.score_scale-1)*10+Camera.shake_y)
    local s2 = tostring(self.score)
    love.graphics.setFont(FontBold)
    love.graphics.print(s2, Res.w/2-FontBold:getWidth(s2)*self.score_scale/2+Camera.shake_x, Res.h/2-20*self.score_scale+Camera.shake_y, 0, self.score_scale, self.score_scale)
    ResetColor()
    
    Camera:start()
    
    for i, group_name in ipairs(draw_order) do
        if self.objects[group_name] ~= nil then
            for _, object in ipairs(self.objects[group_name]) do
                if object.draw then
                    object:draw()
                end
            end
        end
    end
    
    if Edit.editing then
        Edit:draw()
    end
    
    Camera:stop()
    
    if Edit.editing then
        Edit:draw_hud()
    end

    Shaders:stop()
end

return Game
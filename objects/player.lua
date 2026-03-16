local Player = Class()

local img = NewImage("player")

local gravity = 0.2
local spike_radius = TILE_SIZE*0.7
local score_radius = TILE_SIZE*1.1

function Player:init(x, y)
    self.group_name = "player"
    
    self.x = x
    self.y = y
    self.w = img:getWidth()
    self.h = img:getHeight()
    
    self.direction = 1
    self.speed = 1.1
    self.vy = 0
    self.gravity = gravity
    self.jump_force = 3

    self.anim_scale = 0
    
    if not Edit.editing then
        Camera:set(0, 0)
        for _ = 1, 4 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(3, 10))
        end
    end
end

function Player:update(dt)
    local found_spike = Physics.dist(self, {"spike"}, spike_radius)
    if #found_spike > 0 then
        self:die()
    end

    local found_laser = Physics.col(self, {"laser"})
    if #found_laser > 0 then
        self:die()
    end
    
    local found_score = Physics.dist(self, {"score"}, score_radius)
    if #found_score > 0 then
        Game:add_score(3)
        found_score[1].remove = true
        for _ = 1, 4 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(10, 15), COLOR.SCORE)
        end
    end

    local found_x = Physics.move_and_col(self, self.direction*self.speed*2*dt, 0)
    local found_wall_x = Physics.col(self, {"wall"})
    for _, wall in ipairs(found_wall_x) do
        table.insert(found_x, wall)
    end
    Physics.solve_x(self, self.direction, found_x[1])
    if #found_x > 0 then
        self.direction = -self.direction
        for _ = 1, 4 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(0, 20)*self.direction, math.random(-20, 20), math.random(3, 7))
        end
        Game:add_score()
        self.anim_scale = 0.4
    end
    self.vy = self.vy+self.gravity*dt
    local found_y = Physics.move_and_col(self, 0, self.vy*dt)
    local found_wall_y = Physics.col(self, {"wall"})
    for _, wall in ipairs(found_wall_y) do
        table.insert(found_y, wall)
    end
    Physics.solve_y(self, self.vy, found_y[1])
    if #found_y > 0 then
        for i, found in ipairs(found_y) do
            if found.group_name == "wall" then
                found:flip(self.vy)
            end
        end
        for _ = 1, 4 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(0, 20)*self.vy, math.random(3, 7))
        end
        self.vy = -self.vy
        Game:add_score()
        self.anim_scale = -0.4
    end

    if Input.jump.pressed then
        self.anim_scale = 0.4
        self.vy = -self.jump_force
        for _ = 1, 4 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(0, 20), math.random(3, 7))
        end
    end
    if Input.jump.down then
        self.gravity = gravity/2
    else
        self.gravity = gravity
    end
    
    if self.y < 0 or self.y+self.h > Res.h then
        self:die()
    end

    self.anim_scale = self.anim_scale-self.anim_scale*0.1*dt
end

function Player:die()
    self.remove = true
    Game.dead = true
    Camera:shake(4)
    for _ = 1, 4 do
        Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-20, 20), math.random(-20, 20), math.random(10, 15), COLOR.SPIKE)
    end
end

function Player:draw()
    love.graphics.draw(img, self.x+self.anim_scale*self.w/2, self.y-self.anim_scale*self.h/2, 0, 1-self.anim_scale, 1+self.anim_scale)
end

return Player
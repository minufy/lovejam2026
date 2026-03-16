local Laser = Class()

LASER_H = TILE_SIZE*5

function Laser:init(y)
    self.group_name = "laser"
    
    self.x = 0
    self.oy = y
    self.w = Res.w
    self.h = LASER_H
    self.y = self.oy-self.h/2
    for x = 0, Res.w/TILE_SIZE do
        Game:add(Particle, x*TILE_SIZE, y, math.random(-30, 30), math.random(-30, 30), math.random(10, 20))
    end
    Camera:shake(2)
end

function Laser:update(dt)
    self.h = self.h-self.h*0.15*dt
    self.y = self.oy-self.h/2
    if self.h/4 < 0.1 then
        self.remove = true
    end
end

function Laser:draw()
    love.graphics.setColor(COLOR.SPIKE)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    ResetColor()
    love.graphics.setLineWidth(self.h/4)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Laser
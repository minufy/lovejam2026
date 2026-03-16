local LaserWarning = Class()

local Laser = require("objects.laser")

local time = 90
function LaserWarning:init(y)
    self.group_name = "laser_warning"

    self.x = 0
    self.oy = y
    self.w = Res.w
    self.h = 0
    self.y = self.oy-self.h/2
    self.time = 0
end

function LaserWarning:update(dt)
    self.h = self.h+(LASER_H-self.h)*0.05*dt
    self.y = self.oy-self.h/2
    self.time = self.time+dt
    if self.time > time then
        self.remove = true
        Game:add(Laser, self.oy)
    end
end

function LaserWarning:draw()
    love.graphics.setColor(Alpha(COLOR.SPIKE, 0.3))
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    ResetColor()
end

return LaserWarning
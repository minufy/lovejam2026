local Spike = Class()

local img = NewImage("spike")

function Spike:init(x, y, direction)
    self.group_name = "spike"
    
    self.x = x
    self.y = y
    self.w = img:getWidth()
    self.h = img:getHeight()
    
    if direction == 1 then
        self.y = self.y-self.h
    end
    self.speed = math.random(6, 18)/10
    self.vy = self.speed*direction
end

function Spike:update(dt)
    self.y = self.y+self.vy*dt
    if self.y > Res.h or self.y+self.h < 0 then
        self.remove = true
    end
end

function Spike:draw()
    love.graphics.draw(img, self.x, self.y)
end

return Spike
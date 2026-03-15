local Score = Class()

local img = NewImage("score")

function Score:init(x, y, direction)
    self.group_name = "score"
    
    self.x = x
    self.y = y
    self.w = img:getWidth()
    self.h = img:getHeight()
    
    self.x = self.x+TILE_SIZE/2-self.w/2
    if direction == 1 then
        self.y = self.y-self.h
    end
    self.speed = math.random(12, 22)/10
    self.vy = self.speed*direction
end

function Score:update(dt)
    self.y = self.y+self.vy*dt
    if self.y > Res.h or self.y+self.h < 0 then
        self.remove = true
    end
end

function Score:draw()
    love.graphics.draw(img, self.x, self.y)
end

return Score
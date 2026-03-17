local DeadPos = Class()

function DeadPos:init(x, y)
    self.group_name = "dead_pos"
    self.x = math.floor(x)
    self.y = math.floor(y)
    self.size = TILE_SIZE/2
end

function DeadPos:draw()
    love.graphics.setColor(COLOR.PLAYER)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", self.x, self.y, TILE_SIZE/4+self.size)
    ResetColor()
end

function DeadPos:update(dt)
    self.size = self.size-self.size*0.2*dt
end

return DeadPos
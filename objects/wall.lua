local Wall = Class()

function Wall:init(x, y, direction)
    self.group_name = "wall"
    
    self.x = x
    self.y = y
    self.w = TILE_SIZE*0.75
    self.h = TILE_SIZE*3
    
    self.x = self.x+TILE_SIZE/2-self.w/2
    if direction == 1 then
        self.y = self.y-self.h
    end
    self.speed = math.random(10, 20)/10
    self.vy = self.speed*direction
end

function Wall:update(dt)
    local found_y = Physics.move_and_col(self, 0, self.vy*dt)
    local found_player_y = Physics.col(self, {"player"})
    for _, player in ipairs(found_player_y) do
        table.insert(found_y, player)
    end
    Physics.solve_y(self, self.vy, found_y[1])
    -- if #found_y > 0 then
    --     if found_y[1].group_name == "player" then
    --         self:flip(found_y[1].vy)
    --     end
    -- end
    if self.y > Res.h or self.y+self.h < 0 then
        self.remove = true
    end
end

function Wall:flip(vy)
    if Sign(self.vy) ~= Sign(vy) then
        self.vy = -self.vy
    end
end

function Wall:draw()
    love.graphics.setColor(COLOR.WALL)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 2)
    ResetColor()
end

return Wall
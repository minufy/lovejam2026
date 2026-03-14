local lume = require("modules.lume")

local Edit = {}

local Mouse = require("objects.mouse")

function Edit:init()
    self.editing = false
    self.mouse = Mouse()
    self.undo = {}
    self.undo_i = 1
end

function Edit:update(dt)
    if CONSOLE then
        if Input.toggle_editor.pressed then
            self.editing = not self.editing
            if not self.editing then
                Level:reload()
            end
        end
        if Input.ctrl.down then
            if Input.save.pressed then
                self:save()
            end
        end
    end
    
    if self.editing then
        self.mouse:update(dt)
        if Input.ctrl.down then
            if Input.undo.pressed then
                self.mouse:deselect_all()
                self:undo_undo()
            end
        end
        -- if Input.right.pressed then
        --     Level.level_index = Level.level_index+1
        --     if Level.level_index == 0 then
        --         Level.level_index = 1
        --     end
        --     self:load_level()
        -- end
        -- if Input.left.pressed then
        --     Level.level_index = Level.level_index-1
        --     self:load_level()
        -- end
    end
end

function Edit:draw()
    self.mouse:draw()
end

function Edit:draw_hud()
    self.mouse:draw_hud()
end

function Edit:add_object(x, y, type)
    local data = {
        x = x,
        y = y,
        type = type,
    }
    Level.level.objects[tostring(data):sub(8)] = data
    Level:reload()
end

function Edit:add_img_object(x, y, type)
    local data = {
        x = x,
        y = y,
        type = type,
    }
    Level.level.img_objects[tostring(data):sub(8)] = data
    Level:reload()
end

function Edit:remove_object(key)
    Level.level.objects[key] = nil
    Level:reload()
end

function Edit:remove_img_object(key)
    Level.level.img_objects[key] = nil
    Level:reload()
end

function Edit:remove_tile(x, y)
    Level.level.tiles[x..","..y] = nil
    Level:reload()
end

function Edit:add_tile(x, y, type)
    Level.level.tiles[x..","..y] = {
        x = x,
        y = y,
        type = type
    }
    Level:reload()
end

function Edit:move_object(x, y, key)
    Level.level.objects[key].x = x
    Level.level.objects[key].y = y
    Level:reload()
end

function Edit:move_img_object(x, y, key)
    Level.level.img_objects[key].x = x
    Level.level.img_objects[key].y = y
    Level:reload()
end

function Edit:undo_push()
    for i = #self.undo, self.undo_i+1, -1 do
        table.remove(self.undo, i)
    end
    table.insert(self.undo, lume.serialize(Level.level))
    self.undo_i = #self.undo
end

function Edit:undo_undo()
    if self.undo_i-1 >= 1 then
        self.undo_i = self.undo_i-1
        Level.level = lume.deserialize(self.undo[self.undo_i])
        Level:reload()
    end
end

function Edit:save()
    local data = "return "..lume.serialize(Level.level)
    local path = "assets/levels/"..Level.level_index.."/level.lua"
    local file, err = io.open(path, "w")
    if file then
        file:write(data)
        file:close()
        Log("saved to "..path)
    else
        Log(err)
    end
end

return Edit
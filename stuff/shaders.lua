Shaders = {
    shader = love.graphics.newShader("assets/shaders/shadow.glsl"),
    canvas = love.graphics.newCanvas(Res.w, Res.h)
}

function Shaders:start()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Shaders:stop()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setCanvas(Res.canvas)
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.canvas, 3, 3)
    love.graphics.setShader()
    love.graphics.draw(self.canvas)
    love.graphics.setBlendMode("alpha")
end
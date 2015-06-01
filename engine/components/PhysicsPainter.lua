local PhysicsPainter = BaseDrawable:extends()

function PhysicsPainter:initialize(path)
    self._color = {255, 255, 255, 255}
end

function PhysicsPainter:draw()
    love.graphics.setColor(unpack(self._color))

    -- Translate into the right coordinate system
    love.graphics.push()
    love.graphics.translate(self.object.x, self.object.y)
    
    for _, c in pairs(self.object:getComponent(PhysicsShape)) do
        local shape = c.shape
        if shape:typeOf("CircleShape") then
            love.graphics.circle("fill", 0, 0, shape:getRadius())
        elseif shape:typeOf("PolygonShape") then
            love.graphics.polygon("fill", shape:getPoints())
        else -- Can only be ChainShape or EdgeShape
            love.graphics.line(shape:getPoints())
        end
    end
    love.graphics.pop()
end

function PhysicsPainter:setColor(...)
    self._color = {Color(...)}
end

function PhysicsPainter:getColor()
    return self._color
end

PhysicsPainter:property("color", "getColor", "setColor")

return PhysicsPainter

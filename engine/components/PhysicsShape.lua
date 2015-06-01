local PhysicsShape = Component:extends()

PhysicsShape.unique = false

-- rectangle - width, height, angle
-- circle - radius
-- polygon - x1, y1, x2, y2, x3, y3, ...
function PhysicsShape:initialize(shape_type, ...)
    error_check(
        self.object:hasComponent(PhysicsBody),
        "Cannot add PhysicsShape to an object without a PhysicsBody"
    )
    
    local args = {...}
    if shape_type == "circle" then
        local radius = args[1] or 1
        self._shape = love.physics.newCircleShape(radius)
    elseif shape_type == "rectangle" then
        local width, height, angle = args[1] or 1, args[2] or args[1] or 1, args[3] or 0
        self._shape = love.physics.newRectangleShape(width, height, angle)
    elseif shape_type == "polygon" then
        self._shape = love.physics.newPolygonShape(unpack(args))
    end
    
    self._body = self.object:getComponent(PhysicsBody)
    self._fixture = love.physics.newFixture(self._body.body, self._shape, self._body.density)
end

function PhysicsShape:destroy()
    -- FIXME: This will crash if attempted during a collision callback
    self._fixture:destroy()
    self._shape:destroy()
end



PhysicsShape:property("fixture", function(self) return self._fixture end, nil)
PhysicsShape:property("shape", function(self) return self._shape end, nil)

return PhysicsShape
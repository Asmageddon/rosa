local PhysicsShape = BaseComponent:extends()

PhysicsShape.unique = false
PhysicsShape.type_id = "PhysicsShape"

-- square
--     size
--     size, angle
--     x, y, size
--     x, y, size, angle
-- rectangle
--     width, height
--     width, height, angle
--     x, y, width, height
--     x, y, width, height, angle
-- circle
--     radius
--     x, y, radius
-- polygon
--     x1, y1, x2, y2, x3, y3, ...
-- edge
--     x1, y1, x2, y2
-- edges
--     x1, y1, x2, y2, ...
--     loop, x1, y1, x2, y2, ...
function PhysicsShape:initialize(shape_type, ...)
    error_check(
        self.object:hasComponent(PhysicsBody),
        "Cannot add PhysicsShape to an object without a PhysicsBody"
    )
    
    local args = {...}
    if shape_type == "circle" then
        local x, y, angle = 0, 0, 1
        if #args == 3 then
            x, y, radius = args[1], args[2], args[3]
        else
            radius = args[1]
        end
        self._shape = love.physics.newCircleShape(x, y, radius)
    elseif shape_type == "square" then
        local x, y, size, angle = 0, 0, 1, 0
        if #args == 1 then
            size = args[1]
        elseif #args == 2 then
            size = args[1]
            angle = args[2]
        elseif #args == 3 then
            x, y = args[1], args[2]
            size = args[3]
        elseif #args == 4 then
            x, y = args[1], args[2]
            size = args[3]
            angle = args[4]
        end
        self._shape = love.physics.newRectangleShape(x, y, width, height, angle)
    elseif shape_type == "rectangle" then
        local x, y, width, height, angle = 0, 0, 1, 1, 0
        if #args == 2 then
            width, height = args[1], args[2]
        elseif #args == 3 then
            width, height = args[1], args[2]
            angle = args[3]
        elseif #args == 4 then
            x, y = args[1], args[2]
            width, height = args[3], args[4]
        elseif #args == 5 then
            x, y = args[1], args[2]
            width, height = args[3], args[4]
            angle = args[5]
        end
        self._shape = love.physics.newRectangleShape(x, y, width, height, angle)
    elseif shape_type == "polygon" then
        self._shape = love.physics.newPolygonShape(unpack(args))
    elseif shape_type == "edge" then
        self._shape = love.physics.newEdgeShape(unpack(args))
    elseif shape_type == "edges" then
        if type(args[1]) == "boolean" then
            self._shape = love.physics.newChainShape(unpack(args))
        else
            self._shape = love.physics.newChainShape(false, unpack(args, 2))
        end
    end
    
    self._body = self.object:getComponent(PhysicsBody)
    self._fixture = love.physics.newFixture(self._body.body, self._shape, self._body.density)
end

function PhysicsShape:destroy()
    -- FIXME: This will crash if attempted during a collision callback
    self._fixture:destroy()
    self._shape:destroy()
end



-- Returns points in world coordinates
function PhysicsShape:getPoints()
    --local result = {}
    --local points = self._shape:getPoints()
    --for i=0,#points/2-1 do
        --local x, y = points[i*2+1], points[i*2+2]
        --local wx, wy = 
    --end
    --return self._body:getWorldPoints(  )
    return self._body:getWorldPoints(self._shape:getPoints())
end


PhysicsShape:property("fixture", function(self) return self._fixture end, nil)
PhysicsShape:property("shape", function(self) return self._shape end, nil)

return PhysicsShape
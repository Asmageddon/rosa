local PhysicsBody = Component:extends()

PhysicsBody.unique = true

-- Those should be overwritten by objects with 
local function PB_getX(self) return self._x end
local function PB_setX(self, v) self._x = v end
local function PB_getY(self) return self._y end
local function PB_setY(self, v) self._y = v end


function PhysicsBody:initialize(body_type, density)
    body_type = body_type or "dynamic"
    self._density = density or 1
    -- TODO: Contemplate possibility of having multiple worlds
    local world = self.object.scene.systems[PhysicsSystem].world
    
    self._body = love.physics.newBody(world, self.object.x, self.object.y, body_type)
    
    -- Overwrite position getters/setters
    self.object.getX = function(obj)
        return self._body:getX()
    end
    self.object.setX = function(obj, value)
        return self._body:setX(value)
    end
    self.object.getY = function(obj)
        return self._body:getY()
    end
    self.object.setY = function(obj, value)
        return self._body:setY(value)
    end
end

function PhysicsBody:destroy()
    -- TODO: Destroy PhysicsShape components first
    self._body:destroy()
    
    -- Restore original SceneObject position getters/setters
    self.object.getX = nil
    self.object.setX = nil
    self.object.getY = nil
    self.object.setY = nil
end

PhysicsBody:property("body", function(self) return self._body end, nil)
PhysicsBody:property("density", function(self) return self._density end, nil)

return PhysicsBody
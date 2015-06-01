local PhysicsBody = BaseComponent:extends()

PhysicsBody.unique = true

function PhysicsBody:initialize(body_type, density)
    body_type = body_type or "dynamic"
    self._density = density or 1
    -- TODO: Contemplate possibility of having multiple worlds
    local world = self.object.scene.systems[PhysicsSystem.type_id].world
    
    self._body = love.physics.newBody(world, self.object.x, self.object.y, body_type)
    self._body:setAngle(self.object.angle)
    
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
    self.object.getAngle = function(obj)
        return self._body:getAngle()
    end
    self.object.setAngle = function(obj, value)
        return self._body:setAngle(value)
    end
end

function PhysicsBody:destroy()
    -- Restore original SceneObject position getters/setters
    self.object.getX = nil
    self.object.setX = nil
    self.object.getY = nil
    self.object.setY = nil
    self.object.getAngle = nil
    self.object.setAngle = nil
    
    -- Save position and angle
    self.object._x = self._body:getX()
    self.object._y = self._body:getY()
    self.object._angle = self._body:getAngle()
    
    -- TODO: Destroy PhysicsShape components first
    self._body:destroy()
end

PhysicsBody:property("body", function(self) return self._body end, nil)
PhysicsBody:property("density", function(self) return self._density end, nil)

return PhysicsBody
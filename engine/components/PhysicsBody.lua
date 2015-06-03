local PhysicsBody = BaseComponent:extends()

PhysicsBody.unique = true

function PhysicsBody:initialize(body_type, density)
    body_type = body_type or "dynamic"
    self._density = density or 1
    -- TODO: Contemplate possibility of having multiple worlds
    local world = self.object.scene.systems[PhysicsSystem.type_id].world
    local transform = self.object:getComponent(Transform)
    
    self._body = love.physics.newBody(world, transform.x, transform.y, body_type)
    self._body:setAngle(transform.rotation)
    
    -- Overwrite position getters/setters
    transform.getX = function(obj)
        return self._body:getX()
    end
    transform.setX = function(obj, value)
        return self._body:setX(value)
    end
    transform.getY = function(obj)
        return self._body:getY()
    end
    transform.setY = function(obj, value)
        return self._body:setY(value)
    end
    transform.getRotation = function(obj)
        return self._body:getAngle()
    end
    transform.setRotation = function(obj, value)
        return self._body:setAngle(value)
    end
    
    transform.getScaleX = function(obj) return 1.0 end
    transform.setScaleX = unimplemented
    transform.getScaleY = function(obj) return 1.0 end
    transform.setScaleY = unimplemented
end

function PhysicsBody:destroy()
    local transform = self.object:getComponent(Transform)
    
    -- Restore original Transform getters/setters
    transform.getX = nil
    transform.setX = nil
    transform.getY = nil
    transform.setY = nil
    transform.getAngle = nil
    transform.setAngle = nil
    
    -- Save position and angle
    transform.x = self._body:getX()
    transform.y = self._body:getY()
    transform.angle = self._body:getAngle()
    
    -- TODO: Destroy PhysicsShape components first
    self._body:destroy()
end

PhysicsBody:property("body", function(self) return self._body end, nil)
PhysicsBody:property("density", function(self) return self._density end, nil)

return PhysicsBody
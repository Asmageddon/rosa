local PhysicsSystem = System:extends()

-- TODO: Contemplate making this, and other systems, potentially non-unique

function PhysicsSystem:initialize(gravity_x, gravity_y)
    self._world = love.physics.newWorld(gravity_x or 0, gravity_y or 0, true)
end

function PhysicsSystem:destroy()
    -- TODO: Destroy all PhysicsBody and PhysicsShape components
    self._world:destroy()
end

PhysicsSystem:property("world", function(self) return self._world end, nil)


return PhysicsSystem
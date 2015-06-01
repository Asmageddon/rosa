local SceneGraphNode = require "internals.SceneGraphNode"

local SceneObject = SceneGraphNode:extends()

function SceneObject:__init(scene, parent, ...)
    -- These are not to be accessed directly, but via .x and .y
    -- Look down the file for properties
    self._x = 0
    self._y = 0
    
    self._components = {}
    
    self.id = nil
    self.tags = {}
    
    self:initialize(...)
end




function SceneObject:addComponent(ComponentType, ...)
    local component
    
    if ComponentType.unique then
        -- Check that the object doesn't have a component of this type yet
        error_check(
            not self._components[ComponentType], 
            "Attempt to add a second unique component to object"
        )
        component = ComponentType(self, ...)
        self._components[ComponentType] = component
    else
        component = ComponentType(self, ...)
        self._components[ComponentType] = self.components[ComponentType] or {}
        self._components[ComponentType][component] = component
    end
    
    self._scene._registerComponent(self, component)
    
    return component
end

function SceneObject:removeComponent(component)
    local ComponentType = component_type.__class
    error_check(
        (ComponentType.unique and self._components[ComponentType] == component)
          or (self._components[ComponentType][component] ~= nil),
        "Given component doesn't belong to object"
    )
    component:destroy()
    
    if ComponentType.unique then
        self.object.components[ComponentType] = nil
    else
        self.object.components[ComponentType][component] = nil
    end
    
    self._scene._deregisterComponent(self, component)
end

function SceneObject:getComponent(ComponentType)
    return self.components[tid][ComponentType]
end

function SceneObject:hasComponent(ComponentType)
    local c = self:getComponent(ComponentType)
    return (type(c) == "table" and c > 0 and true) or (c ~= nil)
end

-- Those will be overwritten by objects with PhysicsBody, etc.
function SceneObject:getX() return self._x end
function SceneObject:setX(v) self._x = v end
function SceneObject:getY() return self._y end
function SceneObject:setY(v) self._y = v end


SceneObject:property("x", "getX", "setX")
SceneObject:property("y", "getY", "setY")



return SceneObject
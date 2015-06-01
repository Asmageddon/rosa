local SceneGraphNode = require(rosa_prefix.."internals.SceneGraphNode")

local SceneObject = SceneGraphNode:extends()

function SceneObject:__init(scene, parent, ...)
    SceneGraphNode.__init(self, false, scene, parent)
    -- These are not to be accessed directly, but via .x and .y
    -- Look down the file for properties
    self._x = 0
    self._y = 0
    self._angle = 0
    
    self._components = {}
    
    self.id = nil
    self.tags = {}
    
    self:initialize(...)
end




function SceneObject:addComponent(ComponentType, ...)
    local component
    local tid = ComponentType.type_id
    
    if ComponentType.unique then
        -- Check that the object doesn't have a component of this type yet
        error_check(
            not self._components[tid], 
            "Attempt to add a second unique component to object"
        )
        component = ComponentType(self, ...)
        self._components[tid] = component
    else
        component = ComponentType(self, ...)
        self._components[tid] = self._components[tid] or {}
        self._components[tid][component] = component
    end
    
    self.scene:_registerComponent(component)
    
    return component
end

function SceneObject:removeComponent(component)
    local ComponentType = component_type.__class
    local tid = ComponentType.type_id
    error_check(
        (ComponentType.unique and self._components[tid] == component)
          or (self._components[tid][component] ~= nil),
        "Given component doesn't belong to object"
    )
    component:destroy()
    
    if ComponentType.unique then
        self.object.components[tid] = nil
    else
        self.object.components[tid][component] = nil
    end
    
    self._scene:_deregisterComponent(component)
end

function SceneObject:getComponent(ComponentType)
    local tid = ComponentType.type_id
    return self._components[tid]
end

function SceneObject:hasComponent(ComponentType)
    local c = self:getComponent(ComponentType)
    return (type(c) == "table" and #c > 0 and true) or (c ~= nil)
end

-- Those will be overwritten by objects with PhysicsBody, etc.
function SceneObject:getX() return self._x end
function SceneObject:setX(v) self._x = v end
function SceneObject:getY() return self._y end
function SceneObject:setY(v) self._y = v end
function SceneObject:getAngle() return self._angle end
function SceneObject:setAngle(v) self._angle = v end

-- TODO: Hierarchy-aware absolute position
-- TODO: Investigate making a Transform component

SceneObject:property("x", "getX", "setX")
SceneObject:property("y", "getY", "setY")
SceneObject:property("angle", "getAngle", "setAngle")



return SceneObject
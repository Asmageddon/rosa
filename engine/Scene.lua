local SceneGraphNode = require(rosa_prefix.."internals.SceneGraphNode")

local Scene = SceneGraphNode:extends()

function Scene:__init(...)
    SceneGraphNode.__init(self, true)
    self._layers = {"default"}
    
    self._systems = {}
    
    -- TODO: Optimize this to use an array-backed map
    self._components_index = {}
    
    self:initialize(...)
end

function Scene:addLayer(layer, index)
    if index then
        table.insert(self._layers, index, layer)
    else
        table.insert(self._layers, layer)
    end
end

function Scene:addLayerAbove(layer, reference_layer)
    local index = table.find(self._layers, reference_layer)
    error_check(index ~= nil, "Reference layer doesn't exist")
    
    self:addLayer(layer, index + 1)
end

function Scene:addLayerBelow(layer, reference_layer)
    local index = table.find(self._layers, reference_layer)
    error_check(index ~= nil, "Reference layer doesn't exist")
    
    self:addLayer(layer, index)
end


-- Register/unregister components
function Scene:_registerComponent(component)
    local tid = component.__class.type_id
    self._components_index[tid] = self._components_index[tid] or itable()
    self._components_index[tid][component] = component
end

-- User should never call this directly, so no error check is necessary
function Scene:_unregisterComponent(component)
    local tid = component.__class.type_id
    self._components_index[tid][component] = nil
end

function Scene:getComponents(ComponentType)
    local tid = ComponentType.type_id
    return self._components_index[tid] or {}
end




function Scene:addSystem(SystemType, ...)
    error_check(
        SystemType and BaseSystem.is(SystemType, BaseSystem),
        "No, or invalid system type passed"
    )
    local tid = SystemType.type_id
    error_check(
        not self._systems[tid], 
        "Attempt to add a second '" .. tid .. "' system to object"
    )
    local system = SystemType(self, ...)
    self._systems[tid] = system -- TODO: Possibility of having multiple systems
    return system
end

function Scene:removeSystem(system_or_type)
    local SystemType = system_or_type
    if not BaseSystem.is(system_or_type, BaseSystem) then
        SystemType = system_or_type.__class
    end
    local tid = SystemType.type_id
    error_check(
        self._systems[tid], 
        "Scene has no '" .. tid .. "' system to remove"
    )
    self._systems[tid]:destroy()
    self._systems[tid] = nil
end

function Scene:getSystem(SystemType)
    return self._systems[SystemType.type_id]
end

function Scene:hasSystem(SystemType)
    return (self._systems[SystemType.type_id] ~= nil)
end



Scene:property("systems", function(self) return self._systems end)

-- User-definable functions
function Scene:initialize() end
function Scene:start() end
function Scene:stop() end



return Scene
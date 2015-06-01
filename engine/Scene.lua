local SceneGraphNode = require "internals.SceneGraphNode"

local Scene = SceneGraphNode:extends()

function Scene:__init()
    self._initialized = false
    
    self._layers = {"default"}
    
    self._components_index = {}
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
    local ComponentType = component.__class
    self._components_index[ComponentType] = self._components_index[ComponentType] or {}
    self._components_index[ComponentType][component] = component
end

-- User should never call this directly, so no error check is necessary
function Scene:_unregisterComponent(component)
    local ComponentType = component.__class
    self._components_index[ComponentType][component] = nil
end

function Scene:getComponents(ComponentType)
    return self._components_index[ComponentType] or {}
end


function Scene:_update(dt)
    for obj, _ in ipairs(self._children.by_component.update) do
        obj:update(dt)
    end
end

function Scene:_draw()
    for obj, _ in ipairs(self._children.by_component.draw) do
        obj:draw()
    end
end

-- User-definable functions
function Scene:initialize() end
function Scene:update(dt) end
function Scene:draw() end
function Scene:start() end
function Scene:stop() end

function Scene:update(dt) end
function Scene:keypressed(key, isrepeat) end
function Scene:keyreleased(key) end
function Scene:mousepressed(button, x, y) end
function Scene:mousereleased(button, x, y) end
function Scene:mousemoved(x, y, dx, dy) end
function Scene:quit() end

function Scene:focus() end

return Scene
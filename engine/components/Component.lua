local Component = class()

Component.unique = true

function Component:__init(object, ...)
    self._object = object
    
    self:initialize(...)
end

function Component:initialize() error("Cannot instantiate base Component class") end
function Component:destroy() end

Component:property("object", function(self) return self._object end, nil)


return Component
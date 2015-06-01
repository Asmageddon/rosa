local BaseComponent = class()

BaseComponent.unique = false
BaseComponent.type_id = "BaseComponent"

function BaseComponent:__init(object, ...)
    self._object = object
    
    self:initialize(...)
end

function BaseComponent:initialize()
    error_check(self.__class ~= BaseComponent, "Cannot instantiate BaseComponent class")
end
function BaseComponent:destroy() end

BaseComponent:property("object", function(self) return self._object end, nil)


return BaseComponent
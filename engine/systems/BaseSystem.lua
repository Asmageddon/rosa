local BaseSystem = class()

BaseSystem.type_id = "BaseSystem"

function BaseSystem:__init(scene, ...)
    self._scene = scene
    
    self._enabled = false
    
    self:initialize(...)
    
    self:enable()
end

function BaseSystem:initialize() error_check(self.__class ~= BaseSystem, "Cannot instantiate BaseSystem class") end
function BaseSystem:enable() self._enabled = true end
function BaseSystem:disable() self._enabled = false end
function BaseSystem:destroy() end

BaseSystem:property("scene", function(self) return self._scene end, nil)
BaseSystem:property("enabled", function(self) return self._enabled end, nil)

function BaseSystem:update(dt) end
function BaseSystem:keypressed(key, isrepeat) end
function BaseSystem:keyreleased(key) end
function BaseSystem:mousepressed(button, x, y) end
function BaseSystem:mousereleased(button, x, y) end
function BaseSystem:mousemoved(x, y, dx, dy) end
function BaseSystem:quit() end

function BaseSystem:focus() end

return BaseSystem
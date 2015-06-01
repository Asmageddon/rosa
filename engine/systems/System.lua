local System = class()

function System:__init(scene, ...)
    self._scene = scene
    
    self:initialize(...)
end

function System:initialize() error_check(self.__class ~= System, "Cannot instantiate base System class") end
function System:destroy() end

System:property("scene", function(self) return self._scene end, nil)

function System:update(dt) end
function System:keypressed(key, isrepeat) end
function System:keyreleased(key) end
function System:mousepressed(button, x, y) end
function System:mousereleased(button, x, y) end
function System:mousemoved(x, y, dx, dy) end
function System:quit() end

function System:focus() end

return System
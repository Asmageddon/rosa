local Rendering = System:extends()

function Rendering:initialize() end

function Rendering:destroy() end

Rendering:property("world", function(self) return self._world end, nil)


return Rendering
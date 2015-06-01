local ExampleScene = Scene:extends()

Platform = require "Platform"
Apple = require "Apple"


function ExampleScene:initialize()
    self:addSystem(Rendering)
    self:addSystem(PhysicsSystem)
    
    self:addLayerBelow("background", "default")
    
    self.red_apple = self:addChild(Apple, 0, 0, "red")
    self.green_apple = self:addChild(Apple, 0, 0, "green")
    
    self.platform = self:addChild(Platform, 0, 200, 600, 20)
end

-- User-definable functions
function ExampleScene:update(dt) end
function ExampleScene:draw() end
function ExampleScene:start() end
function ExampleScene:stop() end

return ExampleScene
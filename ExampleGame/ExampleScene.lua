local ExampleScene = Scene:extends()

Platform = require "Platform"
Apple = require "Apple"


function ExampleScene:initialize()
    self.renderer = self:addSystem(RenderingSystem)
    self.physics = self:addSystem(PhysicsSystem)
    self.physics.world:setGravity(0, 300)
    
    self:addLayerBelow("background", "default")
    
    self.renderer.camera:move(-512, -384)
    
    self.red_apple = self:addChild(Apple, 0, -280, "red")
    self.green_apple = self:addChild(Apple, 20, -240, "green")
    
    self.apples = {}
    for i=1,20 do
        local x, y = math.random(-400, 400), math.random(-800, -400)
        table.insert(self.apples, self:addChild(Apple, x, y))
    end
    
    self:addChild(Platform, 0, 0)
    self:addChild(Platform, 100, 180, -0.4)
    self:addChild(Platform, -170, 140, 0.8)
    
end

-- User-definable functions
function ExampleScene:update(dt) end
function ExampleScene:draw() end
function ExampleScene:start() end
function ExampleScene:stop() end

return ExampleScene
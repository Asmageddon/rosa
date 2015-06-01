local RenderingSystem = BaseSystem:extends()

RenderingSystem.type_id = "RenderingSystem"

function RenderingSystem:initialize()
    self.camera = Camera(0, 0)
end

function RenderingSystem:draw()
    self.camera:set()
    for _, drawable in pairs(self.scene:getComponents(BaseDrawable)) do
        drawable:draw()
    end
    self.camera:unset()
end

return RenderingSystem
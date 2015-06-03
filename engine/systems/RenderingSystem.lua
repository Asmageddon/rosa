local RenderingSystem = BaseSystem:extends()

RenderingSystem.type_id = "RenderingSystem"

function RenderingSystem:initialize()
    self._camera = self.scene:addChild(Camera)
end

function RenderingSystem:draw()
    if self._camera then self.camera:set() end
    for _, drawable in ipairs(self.scene:getComponents(BaseDrawable)) do
        drawable:draw()
    end
    if self._camera then self.camera:unset() end
end

RenderingSystem:property("camera", function(self) return self._camera end, nil)

return RenderingSystem
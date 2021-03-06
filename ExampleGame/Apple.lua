local Apple = SceneObject:extends()

function Apple:initialize(x, y, color)
    self:addComponent(Transform, x, y)
    
    self:addComponent(Renderable)
    
    self.sprite = self:addComponent(ImageDrawable, "data/Apple.png")
    self.sprite.offset_x = 16
    self.sprite.offset_y = 16
    self.sprite:setColor(color or "white")
    
    self:addComponent(PhysicsBody, "dynamic", 5)
    
    self:addComponent(PhysicsShape, "circle", 0, 2, 14)
end

return Apple
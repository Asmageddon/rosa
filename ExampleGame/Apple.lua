local Apple = SceneObject:extends()

function Apple:initialize(x, y, color)
    self.x = x; self.y = y
    
    self:addComponent(Drawable)
    
    self.sprite = self:addComponent(Sprite, "data/Apple.png")
    self.sprite.offset_x = 16
    self.sprite.offset_y = 16
    self.sprite:setColor(color)
    
    self:addComponent(PhysicsBody, "dynamic", 5)
    
    self:addComponent(PhysicsShape, "circle", 0, 2, 14)
end

return Apple
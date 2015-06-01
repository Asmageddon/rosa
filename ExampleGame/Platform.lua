local Platform = SceneObject:extends()

function Platform:initialize(x, y, angle)
    self.x = x; self.y = y; self.angle = angle or 0
    
    self:addComponent(Drawable)
    
    self.sprite = self:addComponent(Sprite, "data/Platform.png")
    self.sprite.offset_x = 128
    self.sprite.offset_y = 44
    
    self:addComponent(PhysicsBody, "static", 10)
    
    self:addComponent(PhysicsShape, "rectangle", 0, 0, 256, 88)
end

return Platform
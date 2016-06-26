local InertApple = SceneObject:extends()

function InertApple:initialize(x, y, color)
    self:addComponent(Transform, x, y)
    
    self:addComponent(Renderable)
    
    self.sprite = self:addComponent(ImageDrawable, "data/Apple.png")
    self.sprite.offset_x = 16
    self.sprite.offset_y = 16
    self.sprite:setColor(color or "white")
end

return InertApple
local Sprite = BaseDrawable:extends()

function Sprite:initialize(path)
    self._path = path
    self._image = resman.getImage(path)
    self._color = {255, 255, 255, 255}
    self._transform = self.object:getComponent(Transform)
end

function Sprite:draw()
    love.graphics.setColor(unpack(self._color))
    local t = self._transform
    love.graphics.draw(self._image, 
        t.x, t.y,
        t.rotation + self.rotation,
        t.sx * self.sx, t.sy * self.sy,
        self.offset_x, self.offset_y
    )
end

function Sprite:setColor(...)
    self._color = {Color(...)}
end

function Sprite:getColor()
    return self._color
end

Sprite:property("image", function(self) return self._image end)
Sprite:property("color", "getColor", "setColor")
-- TODO: Change image by changing its path

return Sprite
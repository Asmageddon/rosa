local Sprite = BaseDrawable:extends()

function Sprite:initialize(path)
    self._path = path
    self._image = resman.getImage(path)
    self._color = {255, 255, 255, 255}
end

function Sprite:draw()
    love.graphics.setColor(unpack(self._color))
    love.graphics.draw(self._image, 
        self.object.x, self.object.y,
        self.object.angle + self.angle,
        self.scale_x, self.scale_y,
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
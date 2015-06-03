local Camera = SceneObject:extends()

function Camera:initialize(x, y, rotation, sx, sy, pixel_perfect)
    self.transform = self:addComponent(Transform, x, y, rotation, sx, sy)
    self.pixel_perfect = pixel_perfect or false
    
    self.id = "camera"
    self._target = self.transform
end

function Camera:follow(object)
    self._target = object:getComponent(Transform) or error("Object has no Transform component", 2)
end

function Camera:unfollow()
    self._target = self.transform
end

-- Push the camera onto the Love2D transformation stack
function Camera:set()
    local t = self._target
    love.graphics.push()
    love.graphics.scale(1 / t.sx, 1 / t.sy)
    love.graphics.rotate(-t.rotation)
    if self.pixel_perfect then
        love.graphics.translate(math.floor(-t.x), math.floor(-t.y))
    else
        love.graphics.translate(-t.x, -t.y)
    end
end

-- Pop the camera from the Love2D transformation stack
function Camera:unset()
    love.graphics.pop()
end

return Camera
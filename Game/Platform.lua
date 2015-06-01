local Platform = SceneObject:extends()

function Platform:initialize(x, y, width, height)
    self.x = x
    self.y = y
end

return Platform
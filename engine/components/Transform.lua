local Transform = BaseComponent:extends()

Transform.unique = true
Transform.type_id = "Transform"

function Transform:initialize(x, y, rotation, scale_x, scale_y)
    self._x = x or 0
    self._y = y or 0
    self._rotation = rotation or 0
    self._sx = scale_x or 1
    self._sy = scale_y or 1
end

-- These HAVE to be overriden, for physics, etc.
function Transform:getX() return self._x end
function Transform:setX(x) self._x = x end
function Transform:getY() return self._y end
function Transform:setY(y) self._y = y end

function Transform:getRotation() return self._rotation end
function Transform:setRotation(r) self._rotation = r end

function Transform:getScaleX() return self._sx end
function Transform:setScaleX(sx) self._sx = sy end
function Transform:getScaleY() return self._sy end
function Transform:setScaleY(sy) self._sy = sx end



-- These CAN be overriden but don't have to be
function Transform:getPosition()
    return self.x, self.y
end
function Transform:setPosition(x, y)
    self.x = x
    self.y = y
end

function Transform:getScale()
    return self.sx, self.sy
end
function Transform:setScale(sx, sy)
    self.sx = sx
    self.sy = sy
end



Transform:property("pos", "getPosition", "setPosition")
Transform:property("x", "getX", "setX")
Transform:property("y", "getY", "setY")

Transform:property("r", "getRotation", "setRotation")
Transform:property("rotation", "getRotation", "setRotation")

Transform:property("s", "getScale", "setScale")
Transform:property("sx", "getScaleX", "setScaleX")
Transform:property("sy", "getScaleX", "setScaleX")



function Transform:move(dx, dy)
    self:setPosition(self.x + dx, self.y + dy)
end

function Transform:rotate(dr)
    self.rotation = self.rotation + dr
end

-- TODO: Implement BaseTransform:rotateAround
-- function BaseTransform:rotateAround(x, y, dr) end

function Transform:scale(dsx, dsy)
    dsy = dsy or dsx
    self:setScale(self.sx * dsx, self.sy * dsy)
end

function Transform:scaleAround(x, y, dsx, dsy)
    dsy = dsy or dsx
    self:scale(dsx, dsy)
    self:setPosition(
        x + (self.x - x) * dsx,
        y + (self.y - y) * dsy
    )
end


-- Translate world coordinate into local coordinate
function Transform:getLocalPoint(world_x, world_y)
    if self.rotation == 0 then
        return world_x * self.sx + self.x, world_y * self.sy + self.y
    else
        error("Rotation not yet fully implemented. Trigonometry is hard >__>")
    end
end

-- Translate local coordinate into world coordinate
function Transform:getWorldPoint(local_x, local_y)
    if self.rotation == 0 then
        return local_x * self.sx - self.x, local_y / self.sy - self.y
    else
        error("Rotation not yet fully implemented. Trigonometry is hard <__<")
    end
end

function Transform:getLocalPoints(...)
    local result = {}
    local args = {...}
    for i=0,#args/2-1 do
        local x, y = args[i*2+1], args[i*2+2]
        table.extend(result, {self:getLocalPoint(x, y)})
    end
    return result
end

function Transform:getWorldPoints(...)
    local result = {}
    local args = {...}
    for i=0,#args/2-1 do
        local x, y = args[i*2+1], args[i*2+2]
        table.extend(result, {self:getWorldPoint(x, y)})
    end
    return result
end



return Transform
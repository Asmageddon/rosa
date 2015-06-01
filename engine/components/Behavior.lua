local Behavior = Component:extends()

Behavior.unique = false

function Behavior:initialize(func)
    self.func = func
    self.is_enabled = true
end

function Behavior:update(dt) end

function Behavior:enable() self.is_enabled = true end
function Behavior:disable() self.is_enabled = false end

return Behavior
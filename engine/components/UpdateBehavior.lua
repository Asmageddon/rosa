local UpdateBehavior = BaseComponent:extends()

UpdateBehavior.unique = false
UpdateBehavior.type_id = "BaseBehavior"

function UpdateBehavior:initialize(func, ...)
    self._func = func
    self._args = {...}
end

function UpdateBehavior:update(dt)
    if self.enabled then
        self.func(self.object, unpack(self._args))
    end
end

return UpdateBehavior
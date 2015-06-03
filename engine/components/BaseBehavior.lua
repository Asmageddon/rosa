local BaseBehavior = BaseComponent:extends()

BaseBehavior.unique = false
BaseBehavior.type_id = "BaseBehavior"

function BaseBehavior:__init(object)
    error_check(self.__class ~= BaseBehavior, "Cannot instantiate BaseBehavior class")
    BaseComponent.__init(self, object)
    self._enabled = false
    self:enable()
end

function BaseBehavior:onEnable() end
function BaseBehavior:onDisable() end

function BaseBehavior:enable()
    self:onEnable()
    self._enabled = true
end
function BaseBehavior:disable()
    self:onDisable()
    self._enabled = false
end

BaseBehavior:property("enabled", function(self) return self._enabled end, nil)

return BaseBehavior
local BaseDrawable = BaseBehavior:extends()

BaseDrawable.unique = false
BaseDrawable.type_id = "BaseDrawable"

function BaseDrawable:__init(object)
    error_check(self.__class ~= BaseDrawable, "Cannot instantiate BaseDrawable")
    BaseBehavior.__init(self, object)
    
    self.offset_x = 0
    self.offset_y = 0
    self.angle = 0
    self.scale_x = 1.0
    self.scale_y = 1.0
end

function BaseDrawable:draw() end

return BaseDrawable
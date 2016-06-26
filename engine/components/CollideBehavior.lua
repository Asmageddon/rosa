local CollideBehavior = BaseComponent:extends()

CollideBehavior.unique = false
CollideBehavior.type_id = "CollideBehavior"

function CollideBehavior:initialize()
    self.beginContact = nop
    self.endContact = nop
    self.preSolve = nop
    self.postSolve = nop
end

return CollideBehavior
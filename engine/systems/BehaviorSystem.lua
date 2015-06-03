local BehaviorSystem = BaseSystem:extends()

BehaviorSystem.type_id = "BehaviorSystem"

function BehaviorSystem:initialize()
    self.paused = false
end

function BehaviorSystem:update(dt)
    local behaviors = self.scene:getComponents(Behavior)
    for _, b in ipairs(behaviors) do
        if b.is_enabled then
            b:update(dt)
        end
    end
end

function BehaviorSystem:destroy() end


return BehaviorSystem
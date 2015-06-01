local BehaviorSystem = System:extends()

function BehaviorSystem:initialize()
    self.paused = false
end

function BehaviorSystem:update(dt)
    local behaviors = self.scene:getComponents(Behavior)
    for _, b in pairs(behaviors) do
        if b.is_enabled then
            b:update(dt)
        end
    end
end

function BehaviorSystem:destroy() end


return BehaviorSystem
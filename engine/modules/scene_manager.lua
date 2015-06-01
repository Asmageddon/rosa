local scene_manager = {}

-- The current scene
scene_manager._scene = nil

function scene_manager.setScene(new_scene)
    -- If there's a scene, stop it
    if scene_manager._scene then
        scene_manager._scene:stop()
    end
    
    scene_manager._scene = scene
    
    -- Call the load/start functions of the new scene, but only if it's not nil
    if new_scene then
        if not new_scene._initialized then
            new_scene:initialize()
            new_scene._initialized = true
        end
        scene_manager._scene:start()
    end
end

function scene_manager.getScene()
    return scene_manager._scene
end

function scene_manager.getScene()
    return scene_manager._scene
end


-- Propagate update events to the current scene
function scene_manager.update(dt)
    if scene_manager._scene then
        scene_manager._scene:_update(dt) -- Built-in function, for updating entities
        scene_manager._scene:update(dt)
    end
end

-- Draw the current scene, fill screen with black otherwise
function scene_manager.draw()
    if scene_manager._scene then
        scene_manager._scene:_draw() -- Built-in function, for drawing entities, etc.
        scene_manager._scene:draw()
    else
        love.graphics.setBackgroundColor(0, 0, 0)
        love.graphics.clean()
    end
end


return scene_manager
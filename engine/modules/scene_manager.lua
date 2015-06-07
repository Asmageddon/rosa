local scene_manager = {}

-- The current scene
scene_manager._scene = nil

function scene_manager.setScene(new_scene)
    -- If there's a scene, stop it
    if scene_manager._scene then
        scene_manager._scene:stop()
    end
    
    scene_manager._scene = new_scene
    
    -- Call the load/start functions of the new scene, but only if it's not nil
    if new_scene then
        scene_manager._scene:start()
    end
end

function scene_manager.getScene()
    return scene_manager._scene
end



function scene_manager.dispatchEvent(event, ...)
    if not scene_manager._scene then return end
    
    for _, system in ipairs(scene_manager._scene.systems) do
        if system[event] ~= nil then
            system[event](system, ...)
        end
    end
end



return scene_manager
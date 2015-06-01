local mouse_input = {}

mouse_input.button_mapping = {
    l = "lmb",
    m = "mmb",
    r = "rmb",
    -- wd
    -- wu
    -- x1
    -- x2
}

function mouse_input.mcode_to_name(button)
    return mouse_input.button_mapping[button] or button
end

-- tables saving states of keys, for private use
-- User should use the isPressed, justPressed, justReleased functions
mouse_input._pressed = {}
mouse_input._just_pressed = {}
mouse_input._just_released = {}

mouse_input.x = 0
mouse_input.y = 0
mouse_input.dy = 0
mouse_input.dy = 0


-- Those map to Love2D events, we're counting on them being sent to us
function mouse_input.mousepressed(x, y, button)
    button = mouse_input.mcode_to_name(button)
    mouse_input._pressed[button] = true
    mouse_input._just_pressed[button] = true
    
    mouse_input.x = x; mouse_input.y = y
end

function mouse_input.mousereleased(x, y, button)
    button = mouse_input.mcode_to_name(button)
    mouse_input._pressed[button] = false
    mouse_input._just_released[button] = true
    
    mouse_input.x = x; mouse_input.y = y
end


function mouse_input.mousemoved(x, y, dx, dy)
    mouse_input.x = x; mouse_input.y = y
    mouse_input.dx = dx; mouse_input.dy = dy
end

function mouse_input.update(dt)
    -- Reset the just pressed/released states from last frame
    mouse_input._just_pressed = {}
    mouse_input._just_released = {}
end



-- Functions for the user to ask us the state of keyboard stuff

function mouse_input.isPressed(key)
    return mouse_input._pressed[key] or false
end

function mouse_input.justPressed(key)
    return mouse_input._just_pressed[key] or false
end

function mouse_input.justReleased(key)
    return mouse_input._just_released[key] or false
end

function mouse_input.getPosition()
    return {mouse_input.x, mouse_input.y}
end

function mouse_input.getDelta()
    return {mouse_input.dx, mouse_input.dy}
end



return mouse_input
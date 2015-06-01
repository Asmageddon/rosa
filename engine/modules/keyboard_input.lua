local keyboard_input = {}

-- This just wraps around love.keyboard functionality for the most part
-- In the future might include combinations like shift+k, ctrl+space, etc.

-- Some simple translations
keyboard_input.key_mapping = {
    rctrl = "ctrl",
    lctrl = "ctrl",
    
    rshift = "shift",
    lshift = "shift",
    
    ralt = "alt",
    lalt = "alt",
    
    rgui = "meta",
    lgui = "meta",
    
    [" "] = "space",
    ["-"] = "minus"
}
function keyboard_input.kcode_to_name(key)
    return keyboard_input.key_mapping[key] or key
end

-- tables saving states of keys, for private use
-- User should use the isPressed, justPressed, justReleased functions
keyboard_input._pressed = {}
keyboard_input._just_pressed = {}
keyboard_input._just_released = {}

-- Those map to Love2D events, we're counting on them being sent to us
function keyboard_input.keypressed(key, isrepeat)
    key = keyboard_input.kcode_to_name(key)
    keyboard_input._pressed[key] = true
    keyboard_input._just_pressed[key] = true
end

function keyboard_input.keyreleased(key)
    key = keyboard_input.kcode_to_name(key)
    keyboard_input._pressed[key] = false
    keyboard_input._just_released[key] = true
end

function keyboard_input.update(dt)
    -- Reset the just pressed/released states from the last frame
    keyboard_input._just_pressed = {}
    keyboard_input._just_released = {}
end



-- Functions for the user to ask us the state of keyboard stuff

function keyboard_input.isPressed(key)
    return keyboard_input._pressed[key] or false
end

function keyboard_input.justPressed(key)
    return keyboard_input._just_pressed[key] or false
end

function keyboard_input.justReleased(key)
    return keyboard_input._just_released[key] or false
end


return keyboard_input
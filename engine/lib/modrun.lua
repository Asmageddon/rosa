local modrun = {}

function modrun.shutdown()
    -- Stop audio
    if love.audio then
        love.audio.stop()
    end
end

local nop = function() end

modrun.dt = 0
modrun.running = false

modrun.known_events = {
    "visible", "focus", "resize",

    "joystickadded", "joystickremoved",
    "joystickhat", "joystickaxis", "joystickpressed", "joystickreleased",
    "gamepadpressed", "gamepadreleased", "gamepadaxis",

    "mousepressed", "mousereleased", "mousemoved", "mousefocus",
    "keypressed", "keyreleased",
    "textedit", "textinput",

    "threaderror",
    "quit",

    "pre_quit", "update", "draw", "dispatch", -- NOT love events
}

modrun.base_handlers = {
    visible = love.handlers.visible,
    resize = love.handlers.resize,
    focus = love.handlers.focus,

    joystickadded = love.handlers.joystickadded,
    joystickremoved = love.handlers.joystickremoved,
    joystickhat = love.handlers.joystickhat,
    joystickaxis = love.handlers.joystickaxis,
    joystickpressed = love.handlers.joystickpressed,
    joystickreleased = love.handlers.joystickreleased,

    gamepadpressed = love.handlers.gamepadpressed,
    gamepadreleased = love.handlers.gamepadreleased,
    gamepadaxis = love.handlers.gamepadaxis,

    mousepressed = love.handlers.mousepressed,
    mousereleased = love.handlers.mousereleased,
    mousemoved = love.handlers.mousemoved,
    mousefocus = love.handlers.mousefocus,

    keypressed = love.handlers.keypressed,
    keyreleased = love.handlers.keyreleased,

    textedit = love.handlers.textedit,
    textinput = love.handlers.textinput,

    threaderror = love.handlers.threaderror,
    pre_quit = nop,
    quit = love.handlers.quit,

    dispatch = nop,
    load = function(arg)
        if love.load then love.load(arg) end
    end,
    draw = function()
        if love.draw then love.draw() end
    end,
    update = function(dt)
        if love.update then love.update(dt) end
    end,
}

modrun.callbacks = { } --{ callback, on_error, self_obj, enabled }


-- Register a new event type
function modrun.registerEventType(event)
    if not modrun.known_events[event] then
        table.insert(modrun.known_events, event)
    end
    modrun.known_events[event] = true
    modrun.callbacks[event] = modrun.callbacks[event] or {}
    modrun.base_handlers[event] = nop
end

function modrun.addCallback(event, callback, self_obj, on_error)
    modrun.callbacks[event] = modrun.callbacks[event] or {}
    modrun.callbacks[event][callback] = {callback, on_error, self_obj, true }
end

function modrun.removeCallback(event, callback)
    modrun.callbacks[event][callback] = nil
end

function modrun.enableCallback(callback)
    modrun.callbacks[callback] = true
end
function modrun.disableCallback(callback)
    modrun.callbacks[callback] = false
end


-- Dispatches events to base handlers, and calls callbacks
function modrun.dispatch(event, ...)
    local args = {...}
    local cancel = false

    cancel = modrun.base_handlers[event](...)
    if cancel then return true end

    if event ~= "dispatch" then
        cancel = modrun.dispatch("dispatch", event, ...)
    end
    if cancel then return true end

    for _, entry in pairs(modrun.callbacks[event] or {}) do
        local cb, err_handler, self_obj, enabled = unpack(entry)

        if enabled then
            if err_handler ~= nil then
                -- If an error handler was passed, handle any potential errors via it
                local success, result
                if self_obj ~= nil then
                    success, result = xpcall(cb, function(err) debug.traceback(err) end, self_obj, ...)
                    if not success then
                        err_handler(self_obj, {event, ...}, result) -- Pass traceback as well
                    end
                else
                    success, result = xpcall(cb, function(err) debug.traceback(err) end, ...)
                    if not success then
                        err_handler({event, ...}, result) -- Pass traceback as well
                    end
                end
                if success then cancel = result end
            else
                if self_obj ~= nil then
                    cancel = cb(self_obj, ...)
                else
                    cancel = cb(...)
                end
            end
        end
        if cancel then return true end
    end

    return false
end

function modrun.run()
    -- Seed the random number generator
    if love.math then
        love.math.setRandomSeed(os.time())
        for i=1,3 do love.math.random() end
    end

    if love.event then love.event.pump() end
    modrun.dispatch("load", arg)
    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    modrun.running = true
    modrun.dt = 0
    -- Main loop time.
    while modrun.running do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                -- Quit has to be handled as a special case
                if e == "quit" then
                    local cancel = modrun.dispatch("pre_quit", a, b, c, d)
                    if not cancel then
                        cancel = modrun.dispatch(e, a, b, c, d)
                    end
                    if not cancel then modrun.shutdown(); return end
                end
                -- The rest of events can be handled normally
                modrun.dispatch(e,a,b,c,d) -- Does not include update or draw
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            modrun.dt = love.timer.getDelta()
        end

        -- Call update and draw
        modrun.dispatch("update", modrun.dt) -- will pass 0 if love.timer is disabled

        if love.window and love.graphics and love.window.isCreated() then
            love.graphics.clear()
            love.graphics.origin()
            modrun.dispatch("draw")
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end

function modrun.setup()
    love.run = modrun.run
    return modrun
end

return modrun
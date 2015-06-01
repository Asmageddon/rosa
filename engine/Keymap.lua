local Keymap = class()

function Keymap:__init()
    self._pads = {}
    self._keys = {}
end

function Keymap:addKey(key_name, ...)
    local args = {...}
    self._keys[key_name] = self._keys[key_name] or {}
    table.extend(self._keys[key_name], args)
end

-- This is for adding a keyboard-based direction pad
function Keymap:addKeyPad(pad_name, up, down, left, right)
    speed = speed or 1
    self._pads[pad_name] = {"keyboard", up, down, left, right, speed}
end

function Keymap:isPressed(key_name)
    error_check(self._keys[key_name] ~= nil, "Given key name is not registered in this keypad")
    for _, key in ipairs(self._keys[key_name]) do
        if keyboard:isPressed(key) then return true end
    end
end

function Keymap:justPressed(key_name)
    error_check(self._keys[key_name] ~= nil, "Given key name is not registered in this keypad")
    for _, key in ipairs(self._keys[key_name]) do
        if keyboard:justPressed(key) then return true end
    end
end

function Keymap:justReleased(key_name)
    error_check(self._keys[key_name] ~= nil, "Given key name is not registered in this keymap")
    for _, key in ipairs(self._keys[key_name]) do
        if keyboard:justReleased(key) then return true end
    end
end

function Keyamp:getPadDirection(pad_name)
    error_check(self._pads[pad_name] ~= nil, "Given direction pad name is not registered in this keymap")
    local pad = self._pads[pad_name]
    
    if pad[1] == "keyboard" then
        local x, y = 0, 0
        if self:isPressed(pad[2]) then
            y -= 1
        elseif self:isPressed(pad[3]) then
            y += 1
        end
        if self:isPressed(pad[4]) then
            x -= 1
        elseif self:isPressed(pad[5]) then
            x += 1
        end
        return x * pad[6], y * pad[6]
    else
        error("Invalid direction pad type")
    end
end

-- TODO: 

--defineKey(key_name)
--definePad(pad_name)

--bindKey(key_name, ...)
--bindKeypad(pad_name, up, down, left, right)

--bindTrigger(key_name, ...)
--bindGamepad(pad_name, ...)

--bindButton(key_name, ...) - for binding mouse buttons
--bindMouse(pad_name, ...)

return Keymap
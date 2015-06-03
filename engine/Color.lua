local color_by_name = {
    red = {255, 0, 0, 255},
    green = {0, 255, 0, 255},
    blue = {0, 0, 255, 255},
    white = {255, 255, 255, 255}
}

local function Color(color, ...)
    local args
    if type(color) == "table" then
        args = color
    else
        args = {color, ...}
    end
    
    if #args == 1 then
        local arg = args[1]
        if string.startswith(arg, "#") then
            error("Hex color codes not yet implemented: " .. arg, 2)
        else
            return color_by_name[arg] or error("Unknown color name", 2)
        end
    elseif #args == 3 then
        return unpack(args) -- Can(should) only be RGB
    elseif #args == 4 then
        if type(args[1]) == "string" then
            error("Other color spaces not yet implemented: " .. args[1], 2)
        else
            return unpack(args) -- Can(should) only be RGBA
        end
    elseif #args == 5 then
        error("Other color spaces not yet implemented: " .. args[1], 2)
    end
end

return Color
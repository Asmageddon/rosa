local utils_prefix = ({...})[1] .. "."
local up = utils_prefix

require(up.."lua52-compat")

require(up.."math-mixins")
require(up.."string-mixins")
require(up.."table-mixins")

require(up.."collections")

Color = require(up.."Color")

-- Check if condition is true, and if not, throw an error from the calling function
--     condition: any - if it evaluates to true, error will be thrown
--     message: string - error message that will be thrown
--     level: number - 
function error_check(condition, message, level)
    return condition or error(message, (level or 1) + 1)
end


-- Convert an object to a robust string representation
-- @param
function str(obj, pretty_mode, max_depth, _depth, _visited)
    max_depth = max_depth or 2
    _depth = _depth or 1
    _visited = _visited and setmetatable({}, {__index = _visited}) or {}
    pretty_mode = pretty_mode or false
 
    local obj_type = type(obj)
 
    if obj_type == "string" then
        return '"' .. obj .. '"'
    elseif obj_type == "table" and _visited[obj] ~= nil and _visited[obj] ~= _depth then
        return "<loop>"
    elseif obj_type == "table" and (max_depth < 0 or _depth <= max_depth) then
        _visited[obj] = true
        local result = "{"
        if pretty_mode then result = result .. "\n"; end
 
        local indent = pretty_mode and string.rep("    ", _depth) or ""
        local prev_indent = pretty_mode and string.rep("    ", _depth-1) or ""
        
        for k, v in ipairs(obj) do
            result = result .. indent .. str(v, pretty_mode, max_depth, _depth + 1, _visited) .. ", "
            if pretty_mode then result = result .. "\n"; end
        end
        for k, v in pairs(obj) do
            if type(k) ~= "number" or not (k >= 1 and k <= #obj) then
                result = result .. indent .. tostring(k) .. " = " .. str(v, pretty_mode, max_depth, _depth + 1, _visited) .. ", "
                if pretty_mode then result = result .. "\n"; end
            end
        end
        result = result .. prev_indent .. "}"
 
        return result
    elseif obj_type == "number" or obj_type == "nil" or obj_type == "boolean" then
        return tostring(obj)
    else 
        return "<" .. (tostring(obj) or "userdata/unknown") .. ">"
    end
end

pprint = function(...)
    local r = {}
    for _, v in ipairs({...}) do
        table.insert(r, str(v))
    end
    print(unpack(r))
end

-- A function that throws an error
function unimplemented() error("Unimplemented function called", 2) end
function string.startswith(str, start)
   return string.sub(str,1,string.len(start)) == start
end

function string.endswith(str, _end)
   return _end=='' or string.sub(str,-string.len(_end)) == _end
end

-- Split a string on character(s)
function string.split(str, sep)
    sep = sep or "%s"
    local t = {}
    for substring in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(t, substring)
    end
    return t
end

-- Split a string on a pattern, optionally store the match
function string.gsplit(str, sep, store_separator)
    sep = sep or "%s"
    store_separator = store_separator or false
    local t={}

    while true do
        local s_start, s_end = string.find(str, sep)

        if s_start == nil then return t end
        table.insert(t, string.sub(str, 1, s_start - 1))
        if store_separator then table.insert(t, string.sub(str, s_start, s_end))
        str = string.sub(str, s_end + 1)
    end
end



function table.find(_table, element)
    for k, v in pairs(_table) do
        if v == element then return k end
    end
end

function table.update(table1, table2)
    for k, v in pairs(table2) do
        table1[k] = v
    end
end

function table.extend(table1, table2)
    for i, v in ipairs(table2) do
        table.insert(table1, v)
    end
end



function math.dist(x1, y1, x2, y2)
    x2 = x2 or 0; y2 = y2 or 0
    return math.sqrt(
        math.pow(x1 - x2, 2) +
        math.pow(y1 - y2, 2)
    )
end

function math.angle(x1, y1, x2, y2)
    x2 = x2 or 0; y2 = y2 or 0
    return math.atan2( x1 - x2,  y1 - y2 )
end

-- Not sure why I'd even need this but here it is
function math.polar(x, y)
    return math.dist(x, y), math.angle(x, y)
end

function math.cartesian(magnitude, angle)
    return math.sin(angle) * magnitude, math.cos(angle) * magnitude
end


-- Check if condition is true, and if not, throw an error with message at given level(defaults to 1)
function error_check(condition, message, level)
    return condition or error(message, level or 1)
end


-- Convert an object to a robust string representation
function str(obj, pretty_mode, max_depth, _depth, _visited)
    max_depth = max_depth or -1
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



-- A table where non-present keys are a value other than nil
function defaultdict(default_value_factory)
    local mt = {
        __index = function(t, key)
            if not rawget(t, key) then
                rawset(t, key, default_value_factory())
            end
            return rawget(t, key)
        end
    }
    return setmetatable({}, mt)
end
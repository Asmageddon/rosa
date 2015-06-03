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

-- An associative table that you ipairs() instead of pairs() for greater performance
function itable()
    local _real_table = {} -- key, index
    local mt = {
        __index = function(t, key)
            return rawget(t, _real_table[key])
        end,
        __newindex = function(t, key, value)
            local i = _real_table[key] or (#t + 1)
            if value == nil then
                table.remove(t, i)
                _real_table[key] = nil
            else
                rawset(t, i, value)
                _real_table[key] = i
            end
        end
    }
    return setmetatable({}, mt)
end
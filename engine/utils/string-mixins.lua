-- Check if a string starts with given substring
function string.startswith(str, start)
   return string.sub(str,1,string.len(start)) == start
end

-- Check if a string ends with given substring
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
        if store_separator then table.insert(t, string.sub(str, s_start, s_end)) end
        str = string.sub(str, s_end + 1)
    end
end

-- String interpolation, e.g. print out values from a table, example:
--     string.interp("Point(%{x}, %{y})", {x=3, y=4}) => "Point(3, 4)"
--     "Point(%{x}, %{y})" % {x=3, y=4} => "Point(3, 4)"
function string.interp(str, _table)
    return(str:gsub('($%b{})', function(w) return tostring(_table[w:sub(3, -2)]) end))
end
getmetatable("").__mod = string.interp
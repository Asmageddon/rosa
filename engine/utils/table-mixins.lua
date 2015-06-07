function table.find(tbl, element)
    for k, v in pairs(tbl) do
        if v == element then return k end
    end
end

function table.update(tbl1, tbl2)
    for k, v in pairs(tbl2) do
        tbl1[k] = v
    end
end

function table.extend(tbl1, tbl2)
    for i, v in ipairs(tbl2) do
        table.insert(tbl1, v)
    end
end

function table.count(tbl)
    local c = 0
    for _,_ in pairs(tbl) do
        c = c + 1
    end
    return c
end



local orig_sort = table.sort
rawsort = orig_sort
local std_rev_cmp = function(a, b) return a > b end
local function cmp_by_key(key, reverse)
    if reverse then
        return function(a, b) return a[key] > b[key] end
    else
        return function(a, b) return a[key] < b[key] end
    end
end

-- @param tbl - The table to be sorted
-- @param compare - comparison function or key.
--      If non-function argument is passed, it will be used as element key(e.g. a[key] > b[key])
-- @param reverse - reverse the sorting order
function table.sort(tbl, compare, reverse)
    reverse = reverse or false
    local t = type(compare)

    if t == "nil" and not reverse then
        return orig_sort(tbl)
    elseif t == "nil" and reverse then
        return orig_sort(tbl, std_rev_cmp)
    elseif t == "function" and not reverse then
        return orig_sort(tbl, compare)
    elseif t == "function" and reverse then
        return orig_sort(tbl, function(a, b) return not compare end)
    else
        return orig_sort(tbl, cmp_by_key(compare, reverse))
    end
end
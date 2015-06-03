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
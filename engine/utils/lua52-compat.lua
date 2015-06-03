local function setup_pairs()
    -- If pairs already work, we'll return and do nothing
    local t = setmetatable({}, {
        __pairs=function(t)
            return pairs({x = 4, y = 6})
        end
    })
    for k,v in pairs(t) do return end

    rawpairs = pairs
    function pairs(t)
        local mt = getmetatable(t)
        return (mt and mt.__pairs or rawpairs)(t)
    end
end

local function setup_ipairs()
    -- If ipairs already work, we'll return and do nothing
    local t = setmetatable({}, {
        __ipairs=function(t)
            return pairs({x = 4, y = 6})
        end
    })
    for k,v in ipairs(t) do return end

    rawipairs = ipairs
    function ipairs(t)
        local mt = getmetatable(t)
        return (mt and mt.__ipairs or rawipairs)(t)
    end
end

setup_pairs()
setup_ipairs()
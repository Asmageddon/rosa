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
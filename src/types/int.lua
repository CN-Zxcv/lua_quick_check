module('luatype', package.seeall)

local INT_NEG = -2^63
local INT_POS = -INT_NEG + 1

Int = newdata('Int')

Int.is = function(self, x)
    return type(x) == 'number'
        and math.floor(x) == x
        and INT_NEG < x and x < INT_POS
end

Int.gen = function(self, n)
    local val = math.abs(n) * math.abs(n)
    return math.random(-val, val)
end

Int.show = function(self, x)
    return tostring(x)
end

Int.shrink = function(self, x, f)
    local m = math.abs(x)

    if x < 0 then
        if f(m) then return true end
    end
    local n = x
    while math.abs(n) > 0 do
        if f(x - n) then return true end
        n = n > 0 and math.floor(n / 2) or math.ceil( n / 2)
    end
end

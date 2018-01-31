module('luatype', package.seeall)

Bool = newdata('Bool')

Bool.is = function(self, x)
    return type(x) == 'boolean'
end

Bool.gen = function(self, _)
    return math.random(2) > 1
end

Bool.show = function(self, x)
    return tostring(x)
end

Bool.shrink = function(self, x, f)
    if x then return f(false) end
end

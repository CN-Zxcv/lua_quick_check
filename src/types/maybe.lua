module('luatype', package.seeall)

Maybe = newtype('Maybe')
Maybe.is = function(self, x)
    if x == nil then return true end
    return self.cons[1]:is(x)
end
Maybe.gen = function(self, n)
    if math.random(2) > 1 then
        return nil
    else
        return self.cons[1]:gen(n)
    end
end

Maybe.show = function(self, x)
    if x == nil then
        return 'nil'
    else
        return self.cons[1]:show(x)
    end
end

Maybe.shrink = function(self, x, f)
    if f(nil) then return true end
    if x ~= nil then
        return self.cons[1]:shrink(x, f)
    end
end

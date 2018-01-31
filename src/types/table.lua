
module('luatype', package.seeall)

Table = newtype('Table')
Table.is = function(self, x)
    if type(x) ~= 'table' then return false end

    local watched = {}
    for k, v in pairs(self.cons[1]) do
        if not v:is(x[k]) then return false end
        watched[k] = true
    end
    for k, v in pairs(x) do
        if not watched then return false end
    end

    return true
end
Table.gen = function(self, n)
    local t = {}
    for k, v in pairs(self.cons[1]) do
        t[k] = v:gen(n)
    end
    return t
end

Table.show = function(self, x)
    local s = '{'
    for k, v in pairs(self.cons[1]) do
        s = s .. string.format("['%s'] = %s, ", k, v:show(x[k]))
    end
    s = s .. '}'
    return s
end

Table.shrink = function(self, x, f)
    for k, v in pairs(self.cons[1]) do
        if v:shrink(x[k], function(n)
            local t = table.copy(x)
            t[k] = n
            return f(t)
        end) then return true end
    end
end

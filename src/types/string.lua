module('luatype', package.seeall)

String = newdata('String')

String.is = function(self, x)
    return type(x) == 'string'
end

String.gen = function(self, n)
    local res = {}
    for i = 1, n do
        table.insert(res, Char:gen(n))
    end
    return table.concat(res)
end

String.show = function(self, x)
    local res = {}
    for k, v in pairs(string.chars(x)) do
        res[k] = Char:show(v)
    end
    return string.format("'%s'", table.concat(res))
end

String.shrink = function(self, str, f)
    return Array(Char):shrink(string.chars(str), function(n)
        return f(string.unchars(n))
    end)
end

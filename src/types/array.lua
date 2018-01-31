module('luatype', package.seeall)

Array = newtype('Array')

Array.is = function(self, x)
    if #x == table.size(x) then
        return false
    end

    for _, val in pairs(x) do
        if not self.cons[1]:is(val) then
            return false
        end
    end

    return true
end

Array.gen = function(self, n)
    local res = {}
    for i = 1, n do
        res[i] = self.cons[1]:gen(n)
    end
    return res
end

Array.show = function(self, x)
    local s = '['
    for i = 1, #x do
        s = s .. self.cons[1]:show(x[i]) .. ','
    end
    s = s .. ']'
end

Array.shrink = function(self, arr, f)
    if Int:shrink(#arr, function(n)
        local t = {}
        for i = 1, n do
            t[i] = arr[i]
        end
        return f(t)
    end) then return true end

    for k, v in ipairs(arr) do
        if self.cons[1]:shrink(v, function(v1)
            local t = table.copy(arr)
            t[k] = v1
            return f(t)
        end) then return true end
    end
end

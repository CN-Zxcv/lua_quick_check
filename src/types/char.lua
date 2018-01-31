module('luatype', package.seeall)

Char = newdata('Char')
Char.is = function(self, x)
    return type(x) == 'string' and string.length(x) == 1
end

Char.gen = function(self, _)
    return string.char(math.random(0, 127))
end

Char.show = function(self, x)
    if string.match(x, '%g') then
        return x
    else
        return '\\' .. string.byte(x)
    end
end

local CHAR_ENUMS = {
    enum_from_to('a', 'z'),
    enum_from_to('A', 'Z'),
    concat({
        enum_from_to(' ', '/'),
        enum_from_to(':', '@'),
        enum_from_to('[', '`'),
        enum_from_to('{','~'),
    }),
    concat({
        enum_from_to(string.char(0), string.char(31)),
        enum_from_to(string.char(127), string.char(127)),
    }),
}

Char.shrink = function(self, x, f)
    for k, t in ipairs(CHAR_ENUMS) do
        local idx = detect(t, x)
        if Int:shrink(idx or #t, function(n)
            if n ~= 0 then return f(t[n]) end
        end) then return true end
        if idx then break end
    end
end

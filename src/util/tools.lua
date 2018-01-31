require('./util/std')
require('./util/debug')
require('./util/fp')

function doload(mname)
    local M = package.loaded[mname] or {}
    setmetatable(M, {__index = _ENV});
    local fun, e = loadfile(mname.. ".lua", nil, M)
    if e then print(e) return end
    fun()
    _ENV[M._NAME] = M
    package.loaded[mname] = M
end

function basename(path)
    if type(path) ~= "string" then
        INFO("basename: %s not a string")
        return nil
    end

    return ((path):gsub(".*[\\/]", ""))
end

function handler(obj, method)
    assert(obj)
    assert(method)
    return function(...)
        method(obj, ...)
    end
end
function format(str, ...)
    if type(str) ~= 'string' then str = stringify(str) end

    local args = {...}
    for i = 1, select('#', ...) do
        args[i] = stringify(args[i])
    end
    return string.format(str, table.unpack(args))
end

stringify = function(t)
    local str = ''
    if type(t) == 'table' then
        str = str .. '{'
        for k, v in pairs(t) do
            str = str .. string.format('[%s]=%s,', stringify(k), stringify(v))
        end
        str = str .. '}'
    elseif type(t) == 'string' then
        str = str .. string.format('\'%s\'', t)
    elseif type(t) == 'userdata' or type(t) == 'function' then
        str = str .. string.format('(%s)', t)
    else
        str = str .. tostring(t)
    end
    return str
end

function enum_from_to(l, r)
    local res = {}
    for i = string.byte(l), string.byte(r) do
        table.insert(res, string.char(i))
    end
    return res
end

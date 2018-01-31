module('luatype', package.seeall)

stdArgs = {
    maxSuccess = 100,   -- 最大测试次数
    maxSize = 100,      -- 数据最大长度
}

function data(t, ...)
    local t_meta = getmetatable(t)
    local meta = setmetatable({}, {__index = t_meta.__index})
    local o = {type=t.type, cons={...}}
    --debug.dump(o)
    setmetatable(o, {
        __index = meta,
        --__index = function(t, k)
        --    assert(meta[k], format('no index named=%s in data=%s', k, rawget(t, 'type')))
        --end,
        __newindex = meta,
    })
    return o
end

function newdata(name)
    return newtype(name)()
end

function newtype(name, ...)
    local o = {type=name, cons={...}}
    local meta = {}
    setmetatable(o, {
        --__index = function(t, k)
        --    assert(meta[k], format('no index named=%s in type=%s', k, rawget(t, 'type')))
        --    return meta[k]
        --end,
        __index = meta,
        __newindex = meta,
        __call = function(self, ...)
            --debug.dump({...})
            return data(self, ...)
        end,
    })
    return o
end

function div(a, b)
    return math.floor(a / b)
end

function compute_size(option, n, d)
    local max_size, max_success = option.maxSize, option.maxSuccess

    local round_to = div(n, max_size) * max_size

    if round_to + max_size <= max_success
        or n >= max_success
        or max_success % max_size == 0
        then
        return math.min(n % max_size + div(d, 10), max_size)
    else
        return math.min((n % max_size) * div(max_size, max_success % max_size), max_size)
    end
end

--function genWith(option, type, prop)
--    math.randomseed(os.time())
--    for i = 1, option.maxSuccess do
--        local v = type:gen(compute_size(option, i, 0))
--        print(type:show(v))
--    end
--end

function sample(what)
    local res = {}
    for i = 1, 10 do
        res[i] = what:show(what:gen(i))
    end
    return res
end

-- 因为生成测试用例的时候很多，所以希望是用一个生成一个，遇到失败后就停止了
-- 关键就在怎么等效实现lazyness,
-- 试过协程。但是协程不好写重入
-- 这里使用回调的方式来做，callback返回true则终止生成
function check(what, val, property)
    if property(table.unpack(val)) then return nil end
    local counter = val
    what:shrink(val, function(n)
        local c = check(what, n, property)
        if c then
            counter = c
            return true
        end
    end)
    return counter
end

function quick_check_with(arg, property, input)
    math.randomseed(os.time())
    for i = 1, arg.maxSize do
        local val = {}
        for k, v in pairs(input) do
            val[k] = v:gen(i)
        end
        local counter = check(Table(input), val, property)
        if counter then
            return format('Failure %s', counter)
        end
    end
    return 'Success'
end

function shrink(what, val)
    local res = {}
    local k = 1
    what:shrink(val, function(n)
        res[k] = n
        k = k + 1
    end)
    return res
end

function quick_check(property, input)
    return quick_check_with(stdArgs, property, input)
end

function type_check(property, input, output)
    return quick_check(function(...)
        local t = {property(...)}
        for k, v in pairs(output) do
            if not v:is(t[k]) then return false end
        end
        return true
    end, input)
end

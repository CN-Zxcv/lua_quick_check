-- --.-----------------------------------------------------------------------.--
-- Hx@2017-08-10: simple functional programing part
-- --'-----------------------------------------------------------------------'--
--module('tool', package.seeall)

function id(t)
    return t
end

function any(t, f, ...)
    for k, v in pairs(t) do
        if f(v, ...) then return true end
    end
    return false
end

function all(t, f, ...)
    for k, v in pairs(t) do
        if not f(v, ...) then return false end
    end
    return true
end

function map(t, f, ...)
    local res = {}
    for k, v in pairs(t) do
        res[k] = f(v, ...)
    end
    return res
end

function reduce(dftVal, t, f, ...)
    local val = dftVal
    for k, v in pairs(t) do
        val = val + f(v, ...)
    end
    return val
end

function foldr(t, cnt, f)
    local res = cnt
    for i = #t, 1, -1 do
        res = f(t[i], res)
    end
    return res
end

function foldl(t, cnt, f)
    local res = cnt
    for i = 1, #t do
        res = f(res, t[i])
    end
    return res
end

function foldrT(t, cnt, f)
    local res = cnt
    for _, v in pairs(t) do
        res = f(v, res)
    end
    return res
end

function foldlT(t, cnt, f)
    local res = cnt
    for _, v in pairs(t) do
        res = f(res, v)
    end
    return res
end

-- Hx@2017-08-10: not a correct group func
function group(t, f)
    local res = {}
    for _, r in pairs(t) do
        for _, l in pairs(res) do
            if f(l[1], r) then
                table.insert(l, r)
                break
            end
        end
        table.insert(res, {r})
    end
    return res
end

function group(t, f)
    local res = {}

    local idx = 1
    for i = 1, #t do
        if t[i + 1] == nil then
            if idx <= i then
                table.insert(res, take(t, idx, i - idx + 1))
                idx = i + 1
            end
        elseif not f(t[i], t[i + 1]) then
            table.insert(res, take(t, idx, i - idx + 1))
            idx = i + 1
        end
    end

    return res
end

-- [[a]] -> [a]
function concat(t)
    return foldl(t, {}, appendM)
end

function each(t, f, ...)
    for k, v in pairs(t) do
        f(v, ...)
    end
end

function merge(t1, t2)
    local res = {}
    for k, v in pairs(t1) do res[k] = v end
    for k, v in pairs(t2) do res[k] = v end
    return res
end

function mergeM(t1, t2)
   for k, v in pairs(t2 or {}) do t1[k] = v end
    return t1
end

function append(t1, t2)
    local t = {}
    for _,v in pairs(t1 or {}) do t[#t+1] = v end
    for _,v in pairs(t2 or {}) do t[#t+1] = v end
    return t
end

function appendM(t1, t2)
    for _,v in pairs(t2 or {}) do t1[#t1+1] = v end
    return t1
end

function detect(t, value, ...)
    if is_function(value) then
        for k, v in pairs(t) do
            if value(v, ...) then return k end
        end
    else
        for k, v in pairs(t) do
            if is_equal(v, value) then return k end
        end
    end
end

function find(t, value, ...)
    local k = detect(t, value, ...)
    return k and t[k]
end

function filter(t, f, ...)
    local res = {}
    for k, v in pairs(t) do
        if f(v, ...) then table.insert(res, v) end
    end
    return res
end

function filterT(t, f, ...)
    local res = {}
    for k, v in pairs(t) do
        if f(v, ...) then res[k] = v end
    end
    return res
end

-- 数组抽取一段
function take(t, idx, len)
    local res = {}
    local start = idx < 0 and #t + idx + 1 or idx
    local tail = idx < 0 and start - len + 1 or start + len - 1
    local step = idx < 0 and -1 or 1
    for i = start, tail, step do
        if not t[i] then
            break
        end
        res[#res+1] = t[i]
    end
    return res
end

-- Hx@2017-08-16: not a correct span func
function span(t, f, ...)
    local t1 = {}
    local t2 = {}
    for k, v in pairs(t) do
        if f(v, ...) then
            table.insert(t1, v)
        else
            table.insert(t2, v)
        end
    end
    return {t1, t2}
end

function snd(t)
    return t[2]
end

function fst(t)
    return t[1]
end

-- helpers

function is_equal(a, b)
    return a == b
end

function not_equal(a, b)
    return a ~= b
end

function is_function(t)
    return type(t) == "function"
end

function is_number(data)
    return type(data) == "number"
end

function is_string(data)
    return type(data) == "string"
end

function is_table(data)
    return type(data) == "table"
end

function is_nil(data)
    return data == nil
end

function is_numbers(data)
    if #data == 0 then return false end
    for _, v in ipairs(data) do
        if not is_number(v) then return false end
    end
    return true
end

function negate(x)
    return (-x)
end

function get(t, k, d)
    local v = t and t[k]
    if v ~= nil then return v end
    return d
end

function mul(a, b)
    return a * b
end

function add(a, b)
    return a + b
end

-- Hx@2016-11-18: 数组/序对转换
-- {{a, b}} => {a=b}
list2pair = function(t)
    local res = {}
    for k, v in pairs(t) do
        if res[v[1]] then
            ERROR("[tool] list2pair: unexcepted same key")
            return
        end
        res[v[1]] = v[2]
    end
    return res
end

-- {a=b} => {{a, b}}
pair2list = function(t)
    local res = {}
    for k, v in pairs(t) do
        table.insert(res, {k, v})
    end
    return res
end

-- Hx@2016-11-18: key值列表
-- {a=b} => {a}
get_keys = function(t)
    local res = {}
    for k, v in pairs(t) do
        table.insert(res, k)
    end
    return res
end

-- {a=b} => {b}
get_values = function(t)
    local res = {}
    for k, v in pairs(t) do
        table.insert(res, v)
    end
    return res
end

-- 从v中提取值作为k
alter_key_uniq = function(t, f, ...)
    local res = {}
    for _, v in pairs(t) do
        local k = f(v, ...)
        if res[k] then return end
        res[k] = v
    end
    return res
end

alter_key_cover = function(t, f, ...)
    local res = {}
    for _, v in pairs(t) do
        local k = f(v, ...)
        res[k] = v
    end
    return res
end

alter_key_uncover = function(t, f, ...)
    local res = {}
    for _, v in pairs(t) do
        local k = f(v, ...)
        res[k] = res[k] or v
    end
    return res
end

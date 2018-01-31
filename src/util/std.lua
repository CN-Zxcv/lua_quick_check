function table.copy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end  -- if
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end  -- for
        return new_table
        --return setmetatable(new_table, getmetatable(object))
    end  -- function _copy
    return _copy(object)
end  -- function deepcopy


function table.size(t)
    local num = 0
    if t then
        for _, v in pairs(t) do
            num=num+1
        end
    end
    return num
end

local function go_inject(t, k, v, tail, ...)
    if tail == nil then
        t[k] = v
    else
        if not t[k] then t[k] = {} end
        go_inject(t[k], v, tail, ...)
    end
end

table.inject = function(t, ...)
    local args = {...}
    assert(#args == table.size(args))
    go_inject(t, ...)
    return t
end

table.find = function(t, ...)
    local args = {...}
    assert(#args == table.size(args))
    local node = t
    for _, idx in ipairs(args) do
        if not node[idx] then return nil end
        node = node[idx]
    end
    return node
end

local function go_clear(t, k, tail, ...)
    if not t[k] then return end
    if not tail then t[k] = nil return end

    go_clear(t[k], tail, ...)
    if is_table_empty(t[k]) then t[k] = nil end
end

table.clear = function(t, ...)
    local args = {...}
    assert(#args == table.size(args))
    go_clear(t, ...)
    return t
end

string.chars = function(str)
    local res = {}
    for i = 1, #str do
        table.insert(res, str:sub(i, i))
    end
    return res
end

string.unchars = function(t)
    return table.concat(t)
end

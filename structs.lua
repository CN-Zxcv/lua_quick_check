module('luatype', package.seeall)

Player = Table({
    id=Int,
    name = String,
    quote = Maybe(String),
    extra = Maybe(Table({
        lv = Int,
        league = Maybe(Int),
    })),
    online = Bool,
})

debug.dump(sample(Player), 'sample :: Player')

function prop_test(a, b)
    local x = a
    if 40 < a and a < 100 then x = a + 1 end
    return a + b == x + b
end

print('type_check, wrong type', type_check(prop_test, {Int, Int}, {Int}))
print('type_check, right type', type_check(prop_test, {Int, Int}, {Bool}))

print('quick_check, wrong', quick_check(prop_test, {Int, Int}))

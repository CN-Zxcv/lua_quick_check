# lua_quick_check
simple implement inspired by Test.QuickCheck(Haskell)

simple demo, welcomed to change anything.

# Example
```lua
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
```
# output
```lua
^ sample :: Player
table: 0x8bffe0
{
    1 = {['extra'] = nil, ['id'] = 0, ['online'] = true, ['quote'] = nil, ['name'] = 't', }
    2 = {['extra'] = {['lv'] = -1, ['league'] = nil, }, ['id'] = -2, ['online'] = true, ['quote'] = 'P.', ['name'] = 'Ay', }
    3 = {['extra'] = nil, ['id'] = 3, ['online'] = true, ['quote'] = 'M\2\31', ['name'] = '\17f\20', }
    4 = {['extra'] = {['lv'] = -12, ['league'] = 16, }, ['id'] = -9, ['online'] = true, ['quote'] = nil, ['name'] = 'N%QC', }
    5 = {['extra'] = {['lv'] = 24, ['league'] = 14, }, ['id'] = 1, ['online'] = true, ['quote'] = 'r$-gu', ['name'] = '\8yC\11\24', }
    6 = {['extra'] = nil, ['id'] = 28, ['online'] = false, ['quote'] = '\2:\8\30|s', ['name'] = 'l"E0aA', }
    7 = {['extra'] = nil, ['id'] = 3, ['online'] = false, ['quote'] = 'ww\$^Q-', ['name'] = 'X\218pj*\29', }
    8 = {['extra'] = nil, ['id'] = -19, ['online'] = true, ['quote'] = nil, ['name'] = 'KTm8v2hW', }
    9 = {['extra'] = nil, ['id'] = -3, ['online'] = false, ['quote'] = nil, ['name'] = 'u\18pR7O#d'', }
    10 = {['extra'] = {['lv'] = -55, ['league'] = -45, }, ['id'] = 11, ['online'] = false, ['quote'] = 't\13\16?a~wW1_', ['name'] = '/%\29J\31\19]\16e\21', }
}
$ sample :: Player

type_check, wrong type  Failure {[1]=0,[2]=0,}

type_check, right type  Success

quick_check, wrong      Failure {[1]=41,[2]=0,}

```

module('luatype', package.seeall)

package.path = package.path .. ';src/?.lua'

require('util.debug')
require('util.tools')
require('util.fp')
require('util.std')

require('base')

require('types.array')
require('types.bool')
require('types.char')
require('types.int')
require('types.maybe')
require('types.string')
require('types.table')

require('structs')

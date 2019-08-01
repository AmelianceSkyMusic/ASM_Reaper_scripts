--[[
 * ReaScript Name: ASM [_LIBRARY] math.lua
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.1
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-03-16)
  + Initial release
 * v1.0.1 (2019-08-01) 
  + Update code
--]]

asm_math={}function asm_math.cutFloatTo(a,b)b=10^b;intNum,remNum=math.modf(a)remNum=math.modf(remNum*b)/b;newNum=intNum+remNum;return newNum end;function asm_math.roundFloatTo(a,b)local c=10^(b or 0)return math.floor(a*c+0.5)/c end
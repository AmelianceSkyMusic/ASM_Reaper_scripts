--[[
 * ReaScript Name: ASM [LIBRARY] math.lua
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.0
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-03-16)
  + Initial release
--]]

asm_math = {}
----------------------------------------------------------------------
------------------------------ MATH ----------------------------------
----------------------------------------------------------------------

function asm_math.cutFloatTo(num, idp) --function that does not round a but truncates fractional numbers
  idp = (10^idp)
  intNum,remNum = math.modf(num)
  remNum = math.modf(remNum*idp)/idp
  newNum = intNum + remNum
  return newNum
end

function asm_math.roundFloatTo(num, idp) --function that round a but truncates fractional numbers
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
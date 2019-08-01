--[[
 * ReaScript Name: ASM [_LIBRARY] table.lua
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

asm_table={}function asm_table.copy(a)local b={}for c,d in pairs(a)do b[c]=d end;return b end
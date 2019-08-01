--[[
 * ReaScript Name: ASM [_LIBRARY] io.lua
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.2
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-03-16)
  + Initial release
 * v1.0.1 (2019-04-10)
  + Update code
 * v1.0.2 (2019-08-01) 
  + Update code
--]]
asm_io={}function asm_io.fileExists(a)local b=io.open(a,"r")if b~=nil then io.close(b)return true else return false end end
--[[
 * ReaScript Name: ASM [_LIBRARY] other.lua
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

----------------------------------------------------------------------
------------------------------ OTHER ---------------------------------
----------------------------------------------------------------------

function Msg(a)reaper.ShowConsoleMsg(tostring(a).."\n")end;reaper.ShowConsoleMsg("")
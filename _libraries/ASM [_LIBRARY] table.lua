--[[
 * ReaScript Name: ASM [_LIBRARY] table.lua
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

asm_table = {}
----------------------------------------------------------------------
------------------------------ TABLE ---------------------------------
----------------------------------------------------------------------
function asm_table.copy(table)
  local copy_table = {}
  for k, v in pairs(table) do
    copy_table[k] = v
  end
  return copy_table
end
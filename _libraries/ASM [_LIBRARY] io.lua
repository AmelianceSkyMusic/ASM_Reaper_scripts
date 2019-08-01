--[[
 * ReaScript Name: ASM [_LIBRARY] io.lua
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
 * v1.0.1 (2019-04-10)
  + Update code
--]]
asm_io = {}
----------------------------------------------------------------------
-------------------------- INPUT-OUTPUT ------------------------------
----------------------------------------------------------------------
function asm_io.fileExists(file_path) -- check file exists

	local file = io.open(file_path, "r")
	if file ~= nil then io.close(file)
		return true
	else
		return false
	end
end
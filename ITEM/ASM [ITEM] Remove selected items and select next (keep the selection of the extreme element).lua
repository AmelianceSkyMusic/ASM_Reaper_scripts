--[[
 * ReaScript Name: ASM [ITEM] Remove selected items and select next (keep the selection of the extreme element)
 * Instructions:  Select items and run the script
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.0
 * Description: Remove selected items and select next (keep the selection of the extreme element)
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-03-30)
  + Initial release
--]]


script_title = "ASM [ITEM] Remove selected items and select next (keep the selection of the extreme element)"

local proj = 0

local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."asm"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."io"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."math"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."other"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."table"..".lua")

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
function remove_item(temp_item, temp_track)
  reaper.DeleteTrackMediaItem(temp_track, temp_item)
end

function select_item(temp_item, temp_track)
  reaper.SetMediaItemSelected(temp_item, true)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local function MAIN()
  
  asm.doItems(_idx, 'SEL_ITEM', remove_item, _2, _3, _4, _5, _6, _8, select_item, _9, _10, _11, _12)
  
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

MAIN()

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

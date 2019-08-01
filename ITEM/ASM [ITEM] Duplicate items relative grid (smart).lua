--[[
 * ReaScript Name: ASM [ITEM] Duplicate items relative grid (smart)
 * Instructions:  Select items and run the script
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.0
 * Description: Duplication of items relative to the grid
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-04-01)
  + Initial release
--]]


script_title = "ASM [ITEM] Duplicate items relative grid (smart)"

local proj = 0

local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."asm"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."io"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."math"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."other"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."table"..".lua")

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local min_position = math.huge
local max_position = 0
function get_min_max_position(temp_item, temp_track)
  item_lenght = reaper.GetMediaItemInfo_Value(temp_item, 'D_LENGTH')
  item_start_position = reaper.GetMediaItemInfo_Value(temp_item, 'D_POSITION')
  item_end = item_start_position + item_lenght
  min_position = math.min(min_position, item_start_position)
  max_position = math.max(max_position, item_end) 
end


----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local function MAIN()
  asm.doItems(_idx, 'SEL_ITEM', get_min_max_position, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12)
  
  if min_position ~= math.huge and max_position ~= math.huge then -- checker for potencial BUG BR_ function

    items_diff_length = max_position - min_position
    
    p_min = asm_math.cutFloatTo(min_position, 2)
    p_max = asm_math.cutFloatTo(max_position, 2)
    
    closest_grid_division_min = reaper.BR_GetClosestGridDivision(p_min)
    prev_grid_division = reaper.BR_GetPrevGridDivision(p_min)
    
    closest_grid_division_max = reaper.BR_GetClosestGridDivision(p_max)
    next_grid_division = reaper.BR_GetNextGridDivision(p_max)
    
    c_min = asm_math.cutFloatTo(closest_grid_division_min, 2)
    c_max = asm_math.cutFloatTo(closest_grid_division_max, 2)
  
    if c_min == p_min and c_max == p_max then
      nudge_length = items_diff_length
    elseif c_min == p_min  and c_max ~= p_max then
      nudge_length = items_diff_length + (next_grid_division - max_position)
    elseif c_min ~= p_min  and c_max == p_max then
      nudge_length = items_diff_length + (min_position - prev_grid_division)
    else
      nudge_length = items_diff_length + (next_grid_division - max_position) + (min_position - prev_grid_division) --(min_position - prev_grid_division)
    end
    
    reaper.ApplyNudge(0, 0, 5, 1, nudge_length , 0, 1)
  end
  
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

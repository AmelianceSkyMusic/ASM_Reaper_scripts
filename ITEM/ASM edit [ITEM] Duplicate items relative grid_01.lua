--[[
 * ReaScript Name: ASM [ITEM] Duplicate items relative grid
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


script_title = "ASM [ITEM] Duplicate items relative grid"

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
--local min_position = nil
--local max_position = nil
local min_position = math.huge
local max_position = 0
function remove_item(temp_item, temp_track)
  item_lenght = reaper.GetMediaItemInfo_Value(temp_item, 'D_LENGTH')
  item_start_position = reaper.GetMediaItemInfo_Value(temp_item, 'D_POSITION')
  item_end = item_start_position + item_lenght
  min_position = math.min(min_position, item_start_position)
  max_position = math.max(max_position, item_end)
  
  --if min_position == nil or min_position > item_start_position then
  --  min_position = item_start_position
  --end
  
  --if max_position == nil or max_position < item_end then
  --  max_position = item_end
  --end
  
end


----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local function get_smart_next_grid_division_F(next_grid_division)

  --next_grid_division_cut = asm_math.cutFloatTo(next_grid_division, cut_c)
    count_next_grid_division = 0
    cicle = 0
  
  while next_grid_division < max_position do
    next_grid_division = reaper.BR_GetNextGridDivision(next_grid_division)
    --next_grid_division_cut = asm_math.cutFloatTo(next_grid_division, cut_c)
    count_next_grid_division = count_next_grid_division + 1
  end
  
    --next_grid_division = reaper.BR_GetPrevGridDivision(next_grid_division)
  
  
  Msg(count_next_grid_division)
  if count_next_grid_division >= 4 then
    cicle_i =  math.fmod (count_next_grid_division, 4)
    if cicle_i ~= 0 then
      cicle = 4 - cicle_i
    else
      cicle = 0
    end
  elseif count_next_grid_division >= 2 then
    cicle_i =  math.fmod (count_next_grid_division, 2)
    if cicle_i ~= 0 then
      cicle = 2 - cicle_i
    else
      cicle = 0
    end
  elseif count_next_grid_division >= 1 then
    cicle = 0
  end
  
  for i = 1, cicle do
    next_grid_division = reaper.BR_GetNextGridDivision(next_grid_division)
  end 
  
  return next_grid_division
end

----------------------------------------------------------------------
local function MAIN()

  cut_c = 3

  asm.doItems(_idx, 'SEL_ITEM', remove_item, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12)
 
  if min_position ~= math.huge and max_position ~= math.huge then
    
    items_diff_length = max_position - min_position --
    items_diff_length_cut = asm_math.cutFloatTo(items_diff_length, cut_c)
    
    min_p_cut = asm_math.cutFloatTo(min_position, cut_c)
    max_p_cut = asm_math.cutFloatTo(max_position, cut_c)
    
    closest_grid_division_min = reaper.BR_GetClosestGridDivision(min_position) --
    closest_grid_division_max = reaper.BR_GetClosestGridDivision(max_position)
    
    c_min_d_cut = asm_math.cutFloatTo(closest_grid_division_min, cut_c)
    c_max_d_cut = asm_math.cutFloatTo(closest_grid_division_max, cut_c)
    
    prev_grid_division = reaper.BR_GetPrevGridDivision(min_position)
    next_grid_division = reaper.BR_GetNextGridDivision(max_position)
    
    prev_grid_division_cut = asm_math.cutFloatTo(prev_grid_division, cut_c)
    next_grid_division_cut = asm_math.cutFloatTo(next_grid_division, cut_c)
    
    Msg('items_diff_length: '..items_diff_length)
    Msg('min_position: '..min_position)
    Msg('closest_grid_division_min: '..closest_grid_division_min)
    Msg('min_position: '..max_position)
    Msg('closest_grid_division_min: '..closest_grid_division_max)
    if min_position == closest_grid_division_min then
      prev_grid_division = min_p_cut
    else
      prev_grid_division = prev_grid_division_cut
    end
    
    if max_position == closest_grid_division_max then
      next_grid_division = max_p_cut
    else
      next_grid_division = next_grid_division_cut
    end

    
    
    ----------------------------------------------------------------------   
    if closest_grid_division_min == min_position and closest_grid_division_max == max_position then          Msg('-01-')
    
      --next_grid_division = reaper.BR_GetNextGridDivision(c_min_d_cut)
      --next_grid_division = reaper.BR_GetNextGridDivision(next_grid_division)
      next_grid_division = get_smart_next_grid_division_F(next_grid_division)
      --next_grid_division_cut = asm_math.cutFloatTo(next_grid_division, cut_c)
      
      nudge_length = items_diff_length_cut + (min_p_cut - prev_grid_division) + (max_p_cut - max_position)
      end
      
    ----------------------------------------------------------------------  
    --[[elseif c_min_d_cut == min_p_cut  and c_max_d_cut ~= max_p_cut then      Msg('-02-')
    
      next_grid_division = reaper.BR_GetNextGridDivision(c_min_d_cut)
      next_grid_division = get_smart_next_grid_division_F(next_grid_division)
      
      --next_grid_division = get_smart_next_grid_division_F(min_position, max_position, closest_grid_division_min, closest_grid_division_max, next_grid_division) 
      nudge_length = items_diff_length + (next_grid_division - max_position)
      
    ----------------------------------------------------------------------  
    elseif c_min_d_cut ~= min_p_cut  and c_max_d_cut == max_p_cut then      Msg('-03-')
    
      next_grid_division = reaper.BR_GetPrevGridDivision(c_min_d_cut)
      next_grid_division = reaper.BR_GetPrevGridDivision(next_grid_division)
      next_grid_division = get_smart_next_grid_division_F(next_grid_division)
      
      nudge_length = items_diff_length + (min_position - prev_grid_division) + (next_grid_division - max_position)
        
    ----------------------------------------------------------------------  
    elseif c_min_d_cut ~= min_p_cut  and c_max_d_cut ~= max_p_cut then      Msg('-04-')
    
      state = 4
      next_grid_division = reaper.BR_GetPrevGridDivision(c_min_d_cut)
      next_grid_division = reaper.BR_GetPrevGridDivision(next_grid_division)
      next_grid_division = get_smart_next_grid_division_F(next_grid_division)
      
      --nudge_length = items_diff_length + (min_position - prev_grid_division) + (next_grid_division - max_position)
      nudge_length = items_diff_length + (next_grid_division - max_position) + (min_position - prev_grid_division) --(min_position - prev_grid_division)
        
    end
    
    --reaper.ApplyNudge(0, 0, 5, 1, nudge_length , 0, 1)]]--
    --nudge_length = items_diff_length + (min_position - prev_grid_division) + (next_grid_division - max_position)
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



    --_, divisionIn, _, _ = reaper.GetSetProjectGrid(proj, false)
    --Msg(retval)
    --Msg(divisionIn)
    --Msg('\n')
    
   --[[ if count_next_grid_division == 1 then
      cicle = 0
    elseif count_next_grid_division == 2 then
      cicle = 0
    elseif count_next_grid_division == 3 then
      cicle = 1
    elseif count_next_grid_division == 4 then
      cicle = 0
    elseif count_next_grid_division >= 5 then
      cicle = 3
    elseif count_next_grid_division == 6 then
      cicle = 2
    elseif count_next_grid_division == 7 then
      cicle = 1
    elseif count_next_grid_division == 8 then
      cicle = 0
    elseif count_next_grid_division == 9 then
      cicle = 3
    elseif count_next_grid_division == 10 then
      cicle = 2
    elseif count_next_grid_division == 11 then
      cicle = 1
    end]]-- 

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
  local item_lenght = reaper.GetMediaItemInfo_Value(temp_item, 'D_LENGTH')
  local item_start_position = reaper.GetMediaItemInfo_Value(temp_item, 'D_POSITION')
  local item_end = item_start_position + item_lenght
  min_position = math.min(min_position, item_start_position)
  max_position = math.max(max_position, item_end) 
end
















----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
--[[function get_smart_next_grid_division_02_F(state, prev_grid_division_temp, min_position)

    count_next_grid_division = 0
    cicle = 0
    
    if prev_grid_division_temp ~= 0 then
      prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
    end
    
    while prev_grid_division_temp < max_position do
      prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
      
      count_next_grid_division = count_next_grid_division + 1
    end

  
  if count_next_grid_division >= 4 then Msg('---------- >= 4')
    cicle_i =  math.fmod (count_next_grid_division, 4)
    if cicle_i ~= 0 then
      cicle = 4 - cicle_i
    else
      cicle = 0
    end
   
  elseif count_next_grid_division >= 2 then Msg('---------- >= 2')
    cicle_i =  math.fmod (count_next_grid_division, 2)
    if cicle_i ~= 0 then
      cicle = 2 - cicle_i
    else
      cicle = 0
    end
   
  elseif count_next_grid_division <= 1 then Msg('---------- >= 1')
    cicle = 0
  end
   
  
  for i = 1, cicle do
    prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
  end 
  next_grid_division = prev_grid_division_temp

  return next_grid_division
end]]--














function get_smart_next_grid_division_02_F(state, prev_grid_division_temp, p_max)
    Msg('prev_grid_division_temp: '..prev_grid_division_temp)
    grid_up_number = 4

    
    local prev_grid_division_temp_cut = asm_math.cutFloatTo(prev_grid_division_temp, 2)
    local next_grid_division_temp = prev_grid_division_temp
    local prev_grid_division_temp = prev_grid_division_temp

    local count_next_grid_division = 0

    local cicle = 0
    
    --if prev_grid_division_temp ~= 0 then
    --  prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
    --end
    
    --[[while prev_grid_division_temp < max_position do
      prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
      
      count_next_grid_division = count_next_grid_division + 1
    end]]--

  
  --[[if count_next_grid_division >= 4 then Msg('---------- >= 4')
    cicle_i =  math.fmod (count_next_grid_division, 4)
    Msg('i_1: '..cicle_i)
    if cicle_i ~= 0 then
      cicle = 9 - cicle_i
    else
      cicle = 4
    end
   
  elseif count_next_grid_division >= 2 then Msg('---------- >= 2')
    cicle_i =  math.fmod (count_next_grid_division, 2)
    Msg('i_2: '..cicle_i)
    if cicle_i ~= 0 then
      cicle = 5 - cicle_i
    else
      cicle = 2
    end
   
  elseif count_next_grid_division <= 1 then Msg('---------- >= 1')
    cicle = 1
  end]]--
  
    --[[if count_next_grid_division == 1 then
      cicle = 1
    elseif count_next_grid_division == 2 then
      cicle = 2
    elseif count_next_grid_division == 3 then
      cicle = 4
    elseif count_next_grid_division == 4 then
      cicle = 4
    elseif count_next_grid_division == 5 then
      cicle = 8
    elseif count_next_grid_division == 6 then
      cicle = 8
    elseif count_next_grid_division == 7 then
      cicle = 8
    elseif count_next_grid_division == 8 then
      cicle = 8
    elseif count_next_grid_division == 9 then
      cicle = 12
    elseif count_next_grid_division == 10 then
      cicle = 12
    elseif count_next_grid_division == 11 then
      cicle = 12
    elseif count_next_grid_division == 12 then
      cicle = 12
    elseif count_next_grid_division == 13 then
      cicle = 16
    elseif count_next_grid_division == 14 then
      cicle = 16
    elseif count_next_grid_division == 15 then
      cicle = 16
    end]]--
    
    while p_max > prev_grid_division_temp_cut do
      
      prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
      prev_grid_division_temp_cut = asm_math.cutFloatTo(prev_grid_division_temp, cut_c)
    
      count_next_grid_division = count_next_grid_division + 1
    
    end
    
    
    if count_next_grid_division >= (grid_up_number*1) + 1 then
      cicle_i =  math.fmod (count_next_grid_division, (grid_up_number*1))
      if cicle_i ~= 0 then
         cicle_i = (grid_up_number*1) - cicle_i
      end
      cicle = count_next_grid_division + cicle_i
    
    elseif count_next_grid_division >= (grid_up_number*0.5) + 1 then
      cicle_i =  math.fmod (count_next_grid_division, (grid_up_number*1))
      if cicle_i ~= 0 then
         cicle_i = (grid_up_number*1) - cicle_i
      end
      cicle = count_next_grid_division + cicle_i
    
    elseif count_next_grid_division >= (grid_up_number*0.25) + 1 then
      cicle_i =  math.fmod (count_next_grid_division, (grid_up_number*0.25))
      if cicle_i ~= 0 then
         cicle_i = (grid_up_number*0.25) - cicle_i
      end
      cicle = count_next_grid_division + cicle_i
    else
      cicle = 1
    end
    
   
  
  for i = 1, cicle do
    next_grid_division_temp = reaper.BR_GetNextGridDivision(next_grid_division_temp)
  end 
  next_grid_division = next_grid_division_temp
  Msg('count_next_grid_division: '..count_next_grid_division)
  Msg('cicle: '..cicle)
  Msg('next_grid_division: '..next_grid_division)
  return next_grid_division
end
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
--[[function get_smart_next_grid_division_F(state, prev_grid_division_temp, p_max)
    local prev_grid_division_temp_cut = asm_math.cutFloatTo(prev_grid_division_temp, 2)
    local next_grid_division_temp = prev_grid_division_temp
    local prev_grid_division_temp = prev_grid_division_temp
    Msg('prev_grid_division_temp: '..prev_grid_division_temp)
    local count_next_grid_division = 0
    --Msg(count_next_grid_division)
    local cicle = 0
    --Msg(next_grid_division)
    --Msg(max_position)
    --if prev_grid_division_temp ~= 0 then
     --prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
    --else
      --if state == 1 then
      --  Msg(1111)
      --  prev_grid_division_temp = reaper.BR_GetPrevGridDivision(prev_grid_division_temp)
      --end
    --end
    Msg('\n')
    while p_max > prev_grid_division_temp_cut do
      Msg('prev_grid_division_temp_cut: '..prev_grid_division_temp_cut)
      Msg('p_max: '..p_max)
      
      --prev_grid_division_temp_cut_temp = prev_grid_division_temp_cut
      
      prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
      prev_grid_division_temp_cut = asm_math.cutFloatTo(prev_grid_division_temp, cut_c)
      Msg('-prev_grid_division_temp_cut: '..prev_grid_division_temp_cut)
      Msg('-p_max: '..p_max)
    
      count_next_grid_division = count_next_grid_division + 1

    end
    Msg('\n')
   

  
  -if count_next_grid_division >= 4 then Msg('---------- >= 4')
     cicle_i =  math.fmod (count_next_grid_division, 4)
     Msg('i_1: '..cicle_i)
     if cicle_i ~= 0 then
       cicle = 9 - cicle_i
     else
       cicle = 4
     end
     
   elseif count_next_grid_division >= 2 then Msg('---------- >= 2')
     cicle_i =  math.fmod (count_next_grid_division, 2)
     Msg('i_2: '..cicle_i)
     if cicle_i ~= 0 then
       cicle = 5 - cicle_i
     else
       cicle = 2
     end
   elseif count_next_grid_division <= 1 then Msg('---------- >= 1')
     cicle = 1
   end
   
  
  for i = 1, cicle do
     next_grid_division_temp = reaper.BR_GetNextGridDivision(next_grid_division_temp)
   end 
   next_grid_division = next_grid_division_temp
   Msg('count_next_grid_division: '..count_next_grid_division)
  Msg('cicle: '..cicle)
  Msg('next_grid_division: '..next_grid_division)
  return next_grid_division
end]]--
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

function get_smart_next_grid_division_F(state, prev_grid_division_temp, p_max)
    Msg('prev_grid_division_temp: '..prev_grid_division_temp)
    grid_up_number = 4

    
    local prev_grid_division_temp_cut = asm_math.cutFloatTo(prev_grid_division_temp, 2)
    local next_grid_division_temp = prev_grid_division_temp
    local prev_grid_division_temp = prev_grid_division_temp

    local count_next_grid_division = 0
    local cicle = 0
    
    while p_max > prev_grid_division_temp_cut do
      
      prev_grid_division_temp = reaper.BR_GetNextGridDivision(prev_grid_division_temp)
      prev_grid_division_temp_cut = asm_math.cutFloatTo(prev_grid_division_temp, cut_c)
    
      count_next_grid_division = count_next_grid_division + 1
    
    end
    
    
    if count_next_grid_division >= (grid_up_number*1) + 1 then
      cicle_i =  math.fmod (count_next_grid_division, (grid_up_number*1))
      if cicle_i ~= 0 then
         cicle_i = (grid_up_number*1) - cicle_i
      end
      cicle = count_next_grid_division + cicle_i
    
    elseif count_next_grid_division >= (grid_up_number*0.5) + 1 then
      cicle_i =  math.fmod (count_next_grid_division, (grid_up_number*1))
      if cicle_i ~= 0 then
         cicle_i = (grid_up_number*1) - cicle_i
      end
      cicle = count_next_grid_division + cicle_i
    
    elseif count_next_grid_division >= (grid_up_number*0.25) + 1 then
      cicle_i =  math.fmod (count_next_grid_division, (grid_up_number*0.25))
      if cicle_i ~= 0 then
         cicle_i = (grid_up_number*0.25) - cicle_i
      end
      cicle = count_next_grid_division + cicle_i
    else
      cicle = 1
    end
    
   
  
  for i = 1, cicle do
    next_grid_division_temp = reaper.BR_GetNextGridDivision(next_grid_division_temp)
  end 
  next_grid_division = next_grid_division_temp
  Msg('count_next_grid_division: '..count_next_grid_division)
  Msg('cicle: '..cicle)
  Msg('next_grid_division: '..next_grid_division)
  return next_grid_division
end






----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local function MAIN()
  --Msg(reaper.GetCursorPosition())
  cut_c = 3
  asm.doItems(_idx, 'SEL_ITEM', get_min_max_position, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12)
  
  if min_position ~= math.huge and max_position ~= math.huge then -- checker for potencial BUG BR_ function
    
    local items_diff_length = max_position - min_position
    local nudge_length
    
    local p_min = asm_math.cutFloatTo(min_position, cut_c)
    local p_max = asm_math.cutFloatTo(max_position, cut_c)
    
    local closest_grid_division_min = reaper.BR_GetClosestGridDivision(p_min)
    local prev_grid_division = reaper.BR_GetPrevGridDivision(p_min)
    --prev_grid_division_temp = prev_grid_division
    
    local closest_grid_division_max = reaper.BR_GetClosestGridDivision(p_max)
    local next_grid_division = reaper.BR_GetNextGridDivision(p_max)
    
    local c_min = asm_math.cutFloatTo(closest_grid_division_min, cut_c)
    local c_max = asm_math.cutFloatTo(closest_grid_division_max, cut_c)
    local next_grid_division_temp
    local prev_grid_division_temp
    
     --or (p_min == c_min and p_min == 0) then
    if p_max == c_max then
      next_grid_division_temp = max_position
    else
      next_grid_division_temp = next_grid_division
    end
    
    if p_min == c_min then --or (p_min == c_min and p_min == 0) then
      prev_grid_division_temp = min_position
    else
      prev_grid_division_temp = prev_grid_division
    end
    Msg('p_min: '..p_min)
    Msg('c_min: '..c_min)
    Msg('\n')
    
    Msg(next_grid_division)
    Msg(max_position)
    Msg(min_position)
    Msg(prev_grid_division)
    Msg(prev_grid_division_temp)
    Msg('\n')
    
    
    ----------------------------------------------------------------------
    if c_min == p_min and c_max == p_max then Msg('-01-')
      local state = 1
      --next_grid_division = next_grid_division_temp
      prev_grid_division = prev_grid_division_temp
      next_grid_division = get_smart_next_grid_division_F(state, prev_grid_division_temp, p_max)
      Msg('\n')
      --Msg(prev_grid_division)
      --[[Msg(next_grid_division)
      Msg(max_position)
      Msg(min_position)
      Msg(prev_grid_division)
      Msg('\n')]]
     -- next_grid_division = get_smart_next_grid_division_F(prev_grid_division_temp, state)
      nudge_length = items_diff_length + (next_grid_division - max_position) + (min_position - prev_grid_division)
      
      ----------------------------------------------------------------------
    elseif c_min == p_min  and c_max ~= p_max then Msg('-02-')
      local state = 2
      next_grid_division = get_smart_next_grid_division_F(state, prev_grid_division_temp, p_max)
      nudge_length = items_diff_length + (next_grid_division - max_position)
      
      
      ----------------------------------------------------------------------
    elseif c_min ~= p_min  and c_max == p_max then Msg('-03-')
      nudge_length = items_diff_length + (min_position - prev_grid_division)
      
      ----------------------------------------------------------------------     
    elseif c_min ~= p_min and c_max ~= p_max then Msg('-04-')
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

--[[
 * ReaScript Name: ASM [TRACK] FX (VSTi only) online on selected tracks
 * Instructions:  Select track and run
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.0
 * Description: FX (VSTi only) online on selected tracks
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-05-13)
  + Initial release
--]]

script_title = "ASM [TRACK] FX (VSTi only) online on selected tracks"

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
local count_tracks_sel =  reaper.CountSelectedTracks(0)--get selected tracks
if not count_tracks_sel then cheker() end --Cheker

local function MAIN()

  for i = 0, count_tracks_sel-1 do --do for all selected tracks
    
    track_sel = reaper.GetSelectedTrack(0 ,i)
    count_FX = reaper.TrackFX_GetCount(track_sel)
    
    for j = 0, count_FX-1 do --do for all FX on track
    
      _is_VSTi, buf = reaper.TrackFX_GetFXName(track_sel, j, "") --is track VSTi
      _is_VST3i, buf = reaper.TrackFX_GetFXName(track_sel, j, "") --is track VST3i
      
      if buf:match('VSTi') or buf:match('VST3i') then --if '' is in name then
        is_VSTi = true else is_VSTi = false
      end
      
      if is_VSTi then --is VSTi do this
        is_offline = reaper.TrackFX_GetOffline(track_sel, j)
        if is_offline then
          reaper.TrackFX_SetOffline(track_sel, j, 0) --set online
        end
      end
      
    end 
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

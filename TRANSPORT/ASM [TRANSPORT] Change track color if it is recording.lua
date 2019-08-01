--[[
 * ReaScript Name: ASM [TRANSPORT] Change track color if it is recording
 * Instructions:  Add this script in custom action after "record" action. DON'T USE "TERMINATE INSTANCE". https://youtu.be/KRfccMzH6ZI
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.0
 * Description: Change track color if it is recording
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-05-13)
  + Initial release
--]]

script_title = "ASM [TRANSPORT] Change track color if it is recording"

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

local color_R, color_G, color_B = 0, 255, 0

local count_tracks_all =  reaper.CountTracks(0)
if not count_tracks_all then asm.cheker() return end --Cheker

local start_color_tab = {}
local start_track_tab = {}

function saveTrackColors()
  for i=0, count_tracks_all-1 do
    start_track = reaper.GetTrack(0, i)
    start_track_int_col = reaper.GetTrackColor(start_track)

    if start_track_int_col <= 0 then --backup default color
      start_track_int_col = 24672376
    end

    start_track_tab[i] = start_track
    start_color_tab[i] = start_track_int_col
  end
end

function restoreTrackscolors()
  for i=0, count_tracks_all-1 do
    reaper.SetTrackColor(start_track_tab[i], start_color_tab[i])
  end
end

local first_cycle = true
function changeTrackColor()
  
    --[[if (reaper.GetPlayState() & 4) == 4 then
    
      count = 0
      local rec_tracks = asm.countTracksState('I_RECARM', 1)
      if rec_tracks then
        for k, tr in pairs(rec_tracks) do
          count = count + 1
        end
      end
      
      if first_cycle then
      
        for i=0, count_tracks_all-1 do
                    track = reaper.GetTrack(0, i)
                    is_arm = reaper.GetMediaTrackInfo_Value(track, 'I_RECARM')
                    if is_arm == 1 then
                      count = count + 1
                      new_track_color = reaper.ColorToNative(color_R, color_G, color_B)
                      reaper.SetTrackColor(track, new_track_color)
                    else
                      reaper.SetTrackColor(start_track_tab[i], start_color_tab[i])
                    end
                  end
        
        old_count = count
        first_cycle = false
      else
        if old_count ~= count then
          
          for i=0, count_tracks_all-1 do
            track = reaper.GetTrack(0, i)
            is_arm = reaper.GetMediaTrackInfo_Value(track, 'I_RECARM')
            if is_arm == 1 then
              count = count + 1
              new_track_color = reaper.ColorToNative(color_R, color_G, color_B)
              reaper.SetTrackColor(track, new_track_color)
            else
              reaper.SetTrackColor(start_track_tab[i], start_color_tab[i])
            end
          end
          
        end
        old_count = count
      end]]--

     
    
  --  track30 = reaper.GetTrack(0, 30)
  --    is_arm = reaper.GetMediaTrackInfo_Value(track, 'I_RECARM')
  --   if is_arm == 1 then
  --   Msg(retval01)
  --   Msg(flags01)
    
    if (reaper.GetPlayState() & 4) == 4 then
        --for i=0, count_tracks_sel-1 do
        --for i = 0, count_tracks_all-1 do
        --end
        
   --[[trackAt = reaper.BR_TrackAtMouseCursor()
   if trackAt then
     is_arm = reaper.GetMediaTrackInfo_Value(trackAt, 'I_RECARM')
     if is_arm == 1 then
       new_track_color = reaper.ColorToNative(color_R, color_G, color_B)
       reaper.SetTrackColor(track, new_track_color)
     else
     trackAt_in = reaper.GetNumTracks(trackAt)
     Msg(trackAt_in)
       reaper.SetTrackColor(start_track_tab[trackAt_in-1], start_color_tab[trackAt_in-1])
     end
   end
        
        
        if first_cycle then]]--
        local rec_tracks = asm.countTracksState('I_RECARM', 1)
      --  Msg(sel_tracks)
        count = 0
        if rec_tracks then
          --restoreTrackscolors()
          for k, tr in pairs(rec_tracks) do
            count = count + 1
            --if track_numb == tr and tr then
              --for k2, tr2 in pairs(sel_tracks) do
                track = reaper.GetTrack(0, tr)
                new_track_color = reaper.ColorToNative(color_R, color_G, color_B)
                reaper.SetTrackColor(track, new_track_color)
              --end
            --end
          end
        end
        if first_cycle then
          old_count = count
          first_cycle = false
        else
          if old_count ~= count then
            --[[for i=0, count_tracks_all-1 do
              rec_tracks2 = asm.countTracksState('I_RECARM', 1)
              if rec_tracks then
                for k2, tr2 in pairs(rec_tracks2) do
                  if i ~= tr2 then
                    reaper.SetTrackColor(start_track_tab[i], start_color_tab[i])
                  end
                end
              else
                reaper.SetTrackColor(start_track_tab[i], start_color_tab[i])
              end
            end]]
            restoreTrackscolors()
          end
          old_count = count
        end
        --Msg(count)
          

    else
      asm.cheker()
      return
    end
    
end

saveTrackColors()
local function MAIN()

    
  
  local loopcount=0
  
  function runInfLoop()
  
    --loopcount=loopcount+1
    --if loopcount >= 1 then
    --  loopcount=1
      changeTrackColor()    
    --end
  
    if (reaper.GetPlayState() & 4) == 4 then
      reaper.defer(runInfLoop)
       else
      restoreTrackscolors()
      asm.cheker()
      return
    end
     
  end 
  
    runInfLoop() 
  
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

--reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

MAIN()

reaper.PreventUIRefresh(-1)
--reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()






--[[
 * ReaScript Name: ASM [TRACK] Toggle mute tracks (solo others) _normal solo
 * Instructions: Select track(s) and Run.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: Muting of selected tracks and automatic soloing of other tracks (for visual perception). Toggle
--]]

--[[
 * Changelog:
 * v1.0 (2018-04-26)
  + Initial release
--]]

--Solo type:
s_value = 1 -- 1=solo, 2=soloed in place

script_title = "ASM [TRACK] Toggle mute tracks (solo others) _normal solo"
  
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

count_track_all =  reaper.CountTracks(0)

check_S = 0
check_M = 0
for i = 0, count_track_all - 1 do

    checkpoint = 0

    track_ud = reaper.GetTrack(0, i)
    track_isSel = reaper.IsTrackSelected(track_ud)
    track_isSolo = reaper.GetMediaTrackInfo_Value(track_ud,"I_SOLO")
    track_isMute = reaper.GetMediaTrackInfo_Value(track_ud,"B_MUTE")
    
   
    -- add S
    if not track_isSel and track_isMute == 0 or (track_isSolo ~= 0 and track_isMute == 1) and checkpoint == 0 then
        reaper.SetMediaTrackInfo_Value(track_ud, "I_SOLO", s_value)
        reaper.SetMediaTrackInfo_Value(track_ud, "B_MUTE", 0)
        checkpoint = 1
    -- add M
    elseif not track_isSel and track_isMute == 1 and track_isSolo == 0 and checkpoint == 0 then
        reaper.SetMediaTrackInfo_Value(track_ud, "I_SOLO", 0)
        reaper.SetMediaTrackInfo_Value(track_ud, "B_MUTE", 1)
        checkpoint = 1
    end
 
    
 
    -- +M +S
    if track_isSel and track_isMute == 1 and track_isSolo ~= 0 and checkpoint == 0 then
        reaper.SetMediaTrackInfo_Value(track_ud, "I_SOLO", 0)
        reaper.SetMediaTrackInfo_Value(track_ud, "B_MUTE", 1)
        checkpoint = 1
    end
    
    -- -M -S
    if track_isSel and track_isMute ~= 1 and track_isSolo == 0 and checkpoint == 0 then
        reaper.SetMediaTrackInfo_Value(track_ud, "I_SOLO", 0)
        reaper.SetMediaTrackInfo_Value(track_ud, "B_MUTE", 1)
        checkpoint = 1
    end   
    
    -- -M +S
    if track_isSel and track_isMute ~= 1 and track_isSolo ~= 0 and checkpoint == 0 then
        reaper.SetMediaTrackInfo_Value(track_ud, "I_SOLO", 0)
        reaper.SetMediaTrackInfo_Value(track_ud, "B_MUTE", 1)
        checkpoint = 1
    end
    
    -- +M -S
    if track_isSel and track_isMute == 1 and track_isSolo == 0 and checkpoint == 0 then
        reaper.SetMediaTrackInfo_Value(track_ud, "I_SOLO", s_value)
        reaper.SetMediaTrackInfo_Value(track_ud, "B_MUTE", 0)
        checkpoint = 1
    end
  
    track_isSolo_check = reaper.GetMediaTrackInfo_Value(track_ud,"I_SOLO")
    if track_isSolo_check == 1 or track_isSolo_check == 2 then
        check_S = check_S + 1
    else
        check_M = check_M + 1
    end
    
    if check_S == count_track_all then
        for S = 0, count_track_all - 1 do
            track_ud_S = reaper.GetTrack(0, S)
            reaper.SetMediaTrackInfo_Value(track_ud_S, "I_SOLO", 0)
        end
    end

    if check_M == count_track_all then
        for M = 0, count_track_all - 1 do
            track_ud_SM = reaper.GetTrack(0, M)
            reaper.SetMediaTrackInfo_Value(track_ud_SM, "B_MUTE", 0)
        end
    end

end


reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

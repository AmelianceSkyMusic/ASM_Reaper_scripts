--[[
 * ReaScript Name: ASM [_LIBRARY] asm.lua
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.7
--]]

--[[
 * Changelog:
 * v1.0 (2019-03-16)
  + Initial release
 * v1.0.1 (2019-03-30)
  + Add new functions for work with items
 * v1.0.2 (2019-05-12)
  + Add new functions for work with color
 * v1.0.3 (2019-08-01) 
  + Update code
 * v1.0.4 (2020-04-01)
  + Add new functions for work with window state
 * v1.0.5 (2020-04-02)
  + Update
 * v1.0.6 (2020-04-04)
  + Some fixes
 * v1.0.7 (2020-04-16)
  + Some fixes
--]]

asm = {
  getRGBA = function (rgbR, rgbG, rgbB, rgbA) -- Convert RGB to float numbers
    local rgbR, rgbG, rgbB, rgbA = rgbR/255, rgbG/255, rgbB/255, rgbA/255
    return rgbR, rgbG, rgbB, rgbA
  end,
  
	cheker_nothing = function() end,
	cheker = function() reaper.defer(asm.cheker_nothing) end,
  --nativeToRGB = function(native_color) -- Convert RGB to float numbers
  --  local num_R, num_G, num_B = reaper.ColorFromNative(native_color)
  --  local rgbR, rgbG, rgbB = num_R, num_G, num_B
  --  return rgbR, rgbG, rgbB
  --end,
  
  setColor = function(r, g, b, a)--set (and return) convertetd RGBA color
    gfx.r, gfx.g, gfx.b, gfx.a = asm.getRGBA(r, g, b, a)
    return r, g, b, a
  end,
  
  setXY = function(x, y) --set x, y coordinates
    gfx.x, gfx.y = x, y
  end,
  
  getMouseXY = function() --get mouse x, y coordinates
    x, y = gfx.mouse_x, gfx.mouse_y
    return x, y
  end,
  
  doCmdID = function(cID_input, type) --commandID, type: 'MAIN' - Main , 'MIDI' - MIDI )
    if cID_input ~= nil and type ~= nil and (type == 'MAIN' or type == 'MIDI') then
      if type == 'MAIN' then
        local commandID = reaper.NamedCommandLookup(cID_input)
        reaper.Main_OnCommand(commandID, 0)
      elseif type == 'MIDI' then
        --- open midi editor before apply actions from MIDI selection ---
        local main_commandID = reaper.NamedCommandLookup("40153") --View: Toggle show MIDI editor windows
        reaper.Main_OnCommand(main_commandID, 0)
        ---
        activeMidiEditor = reaper.MIDIEditor_GetActive()
        local commandID = reaper.NamedCommandLookup(cID_input)
        reaper.MIDIEditor_OnCommand(activeMidiEditor, commandID)

      end
    else
      Msg('commandID or type value is missed or wrong')
    end
  end,
  
	getWindowState = function(script_win_title) --get active window srate form title
	  local window_HWND =  reaper.JS_Window_Find(script_win_title, 1)
	  local retval, window_state_w, window_state_h = reaper.JS_Window_GetClientSize(window_HWND)
    local retval, window_state_left, window_state_top, window_state_right, window_state_bottom = reaper.JS_Window_GetRect(window_HWND)
	  return retval, window_HWND, window_state_w, window_state_h, window_state_left, window_state_top, window_state_right, window_state_bottom
	end
  
}
function asm.msg(message)
  reaper.ShowConsoleMsg(tostring(message).."\n")
  --reaper.ShowConsoleMsg("")
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function asm.tableJoin(table_1, table_2) -- join two tables
  if table_1 and table_2 then
    new_concat_table_2 = table_2
    new_concat_table_1 = table_1
    local i = #table_2 + 1
    for k_2, v_2 in pairs(table_2) do
      for k_1, v_1 in pairs(table_1) do
        v_1_str = tostring(v_1)
        v_2_str = tostring(v_2)
        --asm.msg(v_1_str)
        --asm.msg(v_2_str)
        if v_2_str == v_1_str then
          table.remove (new_concat_table_1, k_1)
        break
        end
      end
    end
    for k, v in pairs(new_concat_table_1) do
      new_concat_table_2[i] = v
      i = i + 1
    end
    table.sort (new_concat_table_2)
  end
  return new_concat_table_2
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function asm.countTracksState(STATE, PARAM) -- count tracks with the STATE

  count_tracks_all =  reaper.CountTracks(0)
  if not count_tracks_all then cheker() end --Cheker
  
  selected_tracks_numb = {}
  local n = 1
  for i = 0, count_tracks_all-1 do
    local track = reaper.GetTrack(0, i)
    is_selected = reaper.GetMediaTrackInfo_Value(track, STATE) == PARAM
    if is_selected then
      selected_tracks_numb[n] = i
      n = n + 1
    end
  end
  
  if #selected_tracks_numb < 1 then
    selected_tracks_numb = false
  end
  
  return selected_tracks_numb
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function asm.getCountTrackMediaItems(track_num)

  local count_tracks = reaper.CountTracks()
  local count_track_item_tab = {}
  
  for i = 1, count_tracks do
    get_track_userdata = reaper.GetTrack(0, i-1)
    count_get_track_items = reaper.CountTrackMediaItems(get_track_userdata)
    count_track_item_tab[i] = count_get_track_items
  end
  
  return count_track_item_tab[track_num]
  
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function asm.countTrackAndItem(proj)
  if proj == nil then proj = 0 end
  
  count_tracks = reaper.CountTracks(proj)
  count_items = reaper.CountMediaItems(proj)
  count_sel_tracks = reaper.CountSelectedTracks(proj)
  count_sel_items = reaper.CountSelectedMediaItems(proj)
  
  return   count_tracks,
      count_items,
      count_sel_tracks,
      count_sel_items
  
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function asm.getItemType(item_data)

  local item_take = reaper.GetMediaItemInfo_Value(item_data, 'I_CURTAKE')
  local item_take_data = reaper.GetMediaItemTake(item_data, item_take)
  local isMidi = reaper.TakeIsMIDI(item_take_data)
  
  if isMidi == true then
    itemIs = 'MIDI'
  else
    local PCM_sourse = reaper.GetMediaItemTake_Source(item_take_data)
    local isSub, _ = reaper.CF_GetMediaSourceRPP(PCM_sourse, 'subproject')
  
    if isSub == false then
      itemIs = 'AUDIO'
    else
      itemIs = 'SUBPROJECT'
    end
  
  end
  
  return itemIs
  
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function asm.getTrackItemsUserdata(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
 
    local temp_last_item = nil
    local count_item_sel_i = 1
    local count_item_unsel_i = 1
    local track_before_item_sel_i = 1
    local track_after_item_sel_i = 1
    local track_first_prev_sel_item_smart_back_temp = nil
    local track_next_last_sel_item_smart_back_temp = nil
    
    track_selected_items_userdata_table = {}
    track_unselected_items_userdata_table = {}
    
    track_before_selected_items_userdata_table = {}
    track_after_selected_items_userdata_table = {}
    
    track_next_last_sel_item = nil
    track_first_prev_sel_item = nil

    track_first_prev_sel_item_smart_back = nil
    track_next_last_sel_item_smart_back = nil
    
    first_selected_item = nil
    last_selected_item = nil
    
    first_track_item = nil
    last_track_item = nil
  
    ----- userdata of first and last items in track
    if count_track_items == 1 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    elseif count_track_items >= 2 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, count_track_items-1)
    end
    -----
    
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of selected items
      if is_item_selected then
        track_selected_items_userdata_table[count_item_sel_i] = item
        count_item_sel_i = count_item_sel_i + 1
        
        ----- userdata of first selected item
        if first_selected_item == nil then
          first_selected_item = item
        end
        -----
        
        ----- userdata of last selected item
        last_selected_item = item
        -----
      -----
      ----- table userdata of unselected items  
      else
        track_unselected_items_userdata_table[count_item_unsel_i] = item
        count_item_unsel_i = count_item_unsel_i + 1
      end
      -----
      
      ----- table userdata of items before selected items
      if temp_last_item ~= nil then
        temp_last_item_selected = reaper.IsMediaItemSelected(temp_last_item)
        if is_item_selected and temp_last_item_selected == false then
          track_before_selected_items_userdata_table[track_before_item_sel_i] = temp_last_item
          track_before_item_sel_i = track_before_item_sel_i + 1
          
          ----- userdata first prev item before first selected
          if track_first_prev_sel_item == nil then
            track_first_prev_sel_item = temp_last_item
          end
          -----
          ----- for smart_back prev
          if track_first_prev_sel_item_smart_back == nil then
            track_first_prev_sel_item_smart_back = temp_last_item
          end
          ----- for smart_back next
          track_next_last_sel_item_smart_back_temp = temp_last_item  
          -----
        end
      end
      temp_last_item = item
      -----
      
      ----- table userdata of items after selected items
      next_item = reaper.GetTrackMediaItem(tracks_userdata, i+1)
      if next_item ~= nil then
        is_next_item_selected = reaper.IsMediaItemSelected(next_item)
        if is_item_selected and is_next_item_selected ~= true then
          track_after_selected_items_userdata_table[track_after_item_sel_i] = next_item
          track_after_item_sel_i = track_after_item_sel_i + 1

          ----- userdata last next item after last selected
          track_next_last_sel_item = next_item
          -----
          ----- for smart_back prev
          if track_first_prev_sel_item_smart_back_temp == nil then
            track_first_prev_sel_item_smart_back_temp = next_item
          end
          ----- for smart_back next
          track_next_last_sel_item_smart_back = next_item
          ---
        end
      end
      ------
      
      ----- set nil for first prev item if first item is selected
      is_first_item_selected = reaper.IsMediaItemSelected(first_track_item)
      if is_first_item_selected then
        track_first_prev_sel_item = nil
        track_first_prev_sel_item_smart_back = track_first_prev_sel_item_smart_back_temp
      end
      -----
      ----- set nil for last next item if first item is selected
      is_last_item_selected = reaper.IsMediaItemSelected(last_track_item)
      if is_last_item_selected then
        track_next_last_sel_item = nil
        track_next_last_sel_item_smart_back  = track_next_last_sel_item_smart_back_temp        
      end
      -----
      
    end
  -----
  
  end
  
  return  track_selected_items_userdata_table, track_unselected_items_userdata_table,
          track_before_selected_items_userdata_table, track_after_selected_items_userdata_table,
          track_first_prev_sel_item, track_next_last_sel_item,
          track_first_prev_sel_item_smart_back, track_next_last_sel_item_smart_back,
          first_selected_item, last_selected_item,
          first_track_item, last_track_item
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function asm.doItems(  import_idx,                             -- track idx foe 'ONE_TRACK'
            track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
            do_function_all_sel_items,                  -- all selected items in track
            do_function_all_unsel_items,                -- all unselected items in track
            do_function_before_sel_items,               -- all items before even selected in track
            do_function_after_sel_items,                -- all items after even selected in track
            do_function_first_prev_sel_item,            -- one first item before first selected items in track
            do_function_next_last_sel_item,             -- one last item after last selected items in track
            do_function_first_prev_sel_item_smart_back, --
            do_function_next_last_sel_item_smart_back,  --
            do_function_first_selected_item,            -- one first selected item
            do_function_last_selected_item,             -- one last selected item
            do_function_first_item,                     -- first item in track
            do_function_last_item,                      -- last item in track
            proj)                                   -- xcvxcvxcv
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_selected_items_userdata_table = {}
  TB_track_unselected_items_userdata_table = {}
  
  TB_track_before_selected_items_userdata_table = {}
  TB_track_after_selected_items_userdata_table = {}
  
  TB_track_first_prev_sel_item = {}
  TB_track_next_last_sel_item = {}

  TB_track_first_prev_sel_item_smart_back = {}
  TB_track_next_last_sel_item_smart_back = {}
  
  TB_first_selected_item = {}
  TB_last_selected_item = {}
  
  TB_first_track_item = {}
  TB_last_track_item = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_selected_items_userdata_table, get_track_unselected_items_userdata_table,
    get_track_before_selected_items_userdata_table, get_track_after_selected_items_userdata_table,
    get_track_first_prev_sel_item, get_track_next_last_sel_item,
    get_track_first_prev_sel_item_smart_back, get_track_next_last_sel_item_smart_back,
    get_first_selected_item, get_last_selected_item,
    get_first_track_item, get_last_track_item
    = asm.getTrackItemsUserdata(idx_track_sel_track)

    -----  -----  -----  1
    if get_track_selected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_selected_items_userdata_table) do
        TB_track_selected_items_userdata_table[#TB_track_selected_items_userdata_table+1] = v
      end
    end
    if get_track_unselected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_unselected_items_userdata_table) do
        TB_track_unselected_items_userdata_table[#TB_track_unselected_items_userdata_table+1] = v
      end
    end

    -----  -----  -----  3
    if get_track_before_selected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_before_selected_items_userdata_table) do
        TB_track_before_selected_items_userdata_table[#TB_track_before_selected_items_userdata_table+1] = v
      end
    end
    if get_track_after_selected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_after_selected_items_userdata_table) do
        TB_track_after_selected_items_userdata_table[#TB_track_after_selected_items_userdata_table+1] = v
      end
    end

    -----  -----  -----  5
    if get_track_first_prev_sel_item ~= nil then
      TB_track_first_prev_sel_item[#TB_track_first_prev_sel_item+1] = get_track_first_prev_sel_item
    end
    if get_track_next_last_sel_item ~= nil then
      TB_track_next_last_sel_item[#TB_track_next_last_sel_item+1] = get_track_next_last_sel_item
    end

    -----  -----  -----  7
    if get_track_first_prev_sel_item_smart_back ~= nil then
    TB_track_first_prev_sel_item_smart_back[#TB_track_first_prev_sel_item_smart_back+1] = get_track_first_prev_sel_item_smart_back
    end
    if get_track_next_last_sel_item_smart_back ~= nil then
    TB_track_next_last_sel_item_smart_back[#TB_track_next_last_sel_item_smart_back+1] = get_track_next_last_sel_item_smart_back
    end
    
    -----  -----  -----  9
    if get_first_selected_item ~= nil then
      TB_first_selected_item[#TB_first_selected_item+1] = get_first_selected_item
    end
    if get_last_selected_item ~= nil then
      TB_last_selected_item[#TB_last_selected_item+1] = get_last_selected_item
    end

    -----  -----  -----  11
    if get_first_track_item ~= nil then
      TB_first_track_item[#TB_first_track_item+1] = get_first_track_item
    end
    if get_last_track_item ~= nil then
      TB_last_track_item[#TB_last_track_item+1] = get_last_track_item
    end

  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  1
  if do_function_all_sel_items ~= nil and TB_track_selected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_selected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_all_sel_items(v, v_item_track)
      end
    end
  end
  
  if do_function_all_unsel_items ~= nil and TB_track_unselected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_unselected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_all_unsel_items(v, v_item_track)
      end
    end
  end
  
  -----  -----  -----  3
  if do_function_before_sel_items ~= nil and TB_track_before_selected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_before_selected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_before_sel_items(v, v_item_track)
      end
    end
  end
  
  if do_function_after_sel_items ~= nil and TB_track_after_selected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_after_selected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_after_sel_items(v, v_item_track)
      end
    end
  end
  
  -----  -----  -----  5
  if do_function_first_prev_sel_item ~= nil and TB_track_first_prev_sel_item ~= nil then
    for k, v in pairs(TB_track_first_prev_sel_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_prev_sel_item(v, v_item_track)
      end
    end
  end
  
  if do_function_next_last_sel_item ~= nil and TB_track_next_last_sel_item ~= nil then
    for k, v in pairs(TB_track_next_last_sel_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_next_last_sel_item(v, v_item_track)
      end
    end
  end

    -----  -----  -----  7
    if do_function_first_prev_sel_item_smart_back ~= nil and TB_track_first_prev_sel_item_smart_back ~= nil then
    for k, v in pairs(TB_track_first_prev_sel_item_smart_back) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_prev_sel_item_smart_back(v, v_item_track)
      end
    end
  end
  
  if do_function_next_last_sel_item_smart_back ~= nil and TB_track_next_last_sel_item_smart_back ~= nil then
    for k, v in pairs(TB_track_next_last_sel_item_smart_back) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_next_last_sel_item_smart_back(v, v_item_track)
      end
    end
  end
  
  -----  -----  -----  9
  if do_function_first_selected_item ~= nil and TB_first_selected_item ~= nil then
    for k, v in pairs(TB_first_selected_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_selected_item(v, v_item_track)
      end
    end
  end
  
  if do_function_last_selected_item ~= nil and TB_last_selected_item ~= nil then
    for k, v in pairs(TB_last_selected_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_last_selected_item(v, v_item_track)
      end
    end
  end

  -----  -----  -----  11
  if do_function_first_item ~= nil and TB_first_track_item ~= nil then
    for k, v in pairs(TB_first_track_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_item(v, v_item_track)
      end
    end
  end
  
  if do_function_last_item ~= nil and TB_last_track_item ~= nil then
    for k, v in pairs(TB_last_track_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_last_item(v, v_item_track)
      end
    end
  end
  
  ----------------------------------------------------------------------------------
  return  TB_track_selected_items_userdata_table, TB_track_unselected_items_userdata_table,
          TB_track_before_selected_items_userdata_table, TB_track_after_selected_items_userdata_table,
          TB_track_next_last_sel_item, TB_track_first_prev_sel_item,
          TB_first_selected_item, TB_last_selected_item,
          TB_first_track_item, TB_last_track_item
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
asm.getMediaItemsUserdata = {}

----------------------------------------------------------------------------------
-- • 1 • --
-----------
function asm.getMediaItemsUserdata.allSelItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
 
    local count_item_sel_i = 1
    track_selected_items_userdata_table = {}
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      ----- table userdata of selected items
      if is_item_selected then
        track_selected_items_userdata_table[count_item_sel_i] = item
        count_item_sel_i = count_item_sel_i + 1
      end
      -----
    end

  
  end
  
  return  track_selected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 2 • --
-----------
function asm.getMediaItemsUserdata.allUnselItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then

    local count_item_unsel_i = 1
    track_unselected_items_userdata_table = {}
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of selected items
      if is_item_selected ~= true then
        track_unselected_items_userdata_table[count_item_unsel_i] = item
        count_item_unsel_i = count_item_unsel_i + 1
      end
      -----
      
    end
  end
  return track_unselected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 3 • --
-----------
function asm.getMediaItemsUserdata.beforeSelItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then

    local temp_last_item = nil
    local track_before_item_sel_i = 1
    track_before_selected_items_userdata_table = {}
 
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of items before selected items
      if temp_last_item ~= nil then
        temp_last_item_selected = reaper.IsMediaItemSelected(temp_last_item)
        if is_item_selected and temp_last_item_selected == false then
          track_before_selected_items_userdata_table[track_before_item_sel_i] = temp_last_item
          track_before_item_sel_i = track_before_item_sel_i + 1
        end
      end
      temp_last_item = item
      -----
    end
  end
  return track_before_selected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 4 • --
-----------
function asm.getMediaItemsUserdata.afterSelItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then

    local track_after_item_sel_i = 1
    track_after_selected_items_userdata_table = {}

    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of items after selected items
      next_item = reaper.GetTrackMediaItem(tracks_userdata, i+1)
      if next_item ~= nil then
        is_next_item_selected = reaper.IsMediaItemSelected(next_item)
        if is_item_selected and is_next_item_selected ~= true then
          track_after_selected_items_userdata_table[track_after_item_sel_i] = next_item
          track_after_item_sel_i = track_after_item_sel_i + 1
        end
      end
      ------
    end
  end
  return track_after_selected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 5 • --
-----------
function asm.getMediaItemsUserdata.firstPrevSelItem(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
    
    track_first_prev_sel_item = nil
    first_track_item = nil

    ----- userdata of first items in track
    if count_track_items == 1 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    elseif count_track_items >=2 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    end
    -----
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of items before selected items
      if temp_last_item ~= nil then
        temp_last_item_selected = reaper.IsMediaItemSelected(temp_last_item)
        if is_item_selected and temp_last_item_selected == false then
          ----- userdata first prev item before first selected
          if track_first_prev_sel_item == nil then
            track_first_prev_sel_item = temp_last_item
          end
          -----
        end
      end
      temp_last_item = item
      -----
      
      ----- set nil for first prev item if first item is selected
      is_first_item_selected = reaper.IsMediaItemSelected(first_track_item)
      if is_first_item_selected then
        track_first_prev_sel_item = nil
      end
      -----
    end
  end
  return track_first_prev_sel_item
end

----------------------------------------------------------------------------------
-- • 6 • --
-----------
function asm.getMediaItemsUserdata.nextLastSelItem(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
  
    track_next_last_sel_item = nil
    last_track_item = nil
  
    ----- userdata of last items in track
    if count_track_items == 1 then
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    elseif count_track_items >=2 then
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, count_track_items-1)
    end
    -----
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of items before selected items
      next_item = reaper.GetTrackMediaItem(tracks_userdata, i+1)
      if next_item ~= nil then
        is_next_item_selected = reaper.IsMediaItemSelected(next_item)
        if is_item_selected and is_next_item_selected ~= true then
          ----- userdata last next item after last selected
          track_next_last_sel_item = next_item
          -----
        end
      end
      ------
      
      ----- set nil for last next item if first item is selected
      is_last_item_selected = reaper.IsMediaItemSelected(last_track_item)
      if is_last_item_selected then
        track_next_last_sel_item = nil
      end
      -----
    end
  end
  return track_next_last_sel_item
end

----------------------------------------------------------------------------------
-- • 7 • --
-----------
function asm.getMediaItemsUserdata.firstPrevSelItemSmartBack(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
    
    track_first_prev_sel_item_smart_back = nil
    first_track_item = nil

    track_next_last_sel_item = nil
    last_track_item = nil

    ----- userdata of first items in track
    if count_track_items == 1 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    elseif count_track_items >= 2 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, count_track_items-1)
    end
    -----
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of items before selected items
      if temp_last_item ~= nil then
        temp_last_item_selected = reaper.IsMediaItemSelected(temp_last_item)
        if is_item_selected and temp_last_item_selected == false then
          ----- userdata first prev item before first selected
          if track_first_prev_sel_item_smart_back == nil then
            track_first_prev_sel_item_smart_back = temp_last_item
          end
          -----
        end
      end
      temp_last_item = item
      -----
      
      ----- set nil for first prev item if first item is selected
      is_first_item_selected = reaper.IsMediaItemSelected(first_track_item)
      if is_first_item_selected then

        ----- table userdata of items after selected items
        next_item = reaper.GetTrackMediaItem(tracks_userdata, i+1)
        if next_item ~= nil then
          is_next_item_selected = reaper.IsMediaItemSelected(next_item)
          if is_item_selected and is_next_item_selected ~= true then
            ----- userdata last next item after last selected
            if track_next_last_sel_item == nil then
              track_next_last_sel_item = next_item
            end
            -----
          end
        end
        ------
        
        ----- set nil for last next item if first item is selected
        --[[is_last_item_selected = reaper.IsMediaItemSelected(last_track_item)
        if is_last_item_selected then
          track_next_last_sel_item = nil
        end]]
        -----

        track_first_prev_sel_item_smart_back = track_next_last_sel_item
      end
      -----
    end
  end
  return track_first_prev_sel_item_smart_back
end

----------------------------------------------------------------------------------
-- • 8 • --
-----------
function asm.getMediaItemsUserdata.nextLastSelItemSmartBack(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
  
    track_next_last_sel_item_smart_back = nil
    last_track_item = nil

    track_first_prev_sel_item = nil
    first_track_item = nil
  
    ----- userdata of last items in track
    if count_track_items == 1 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    elseif count_track_items >=2 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, count_track_items-1)
    end
    -----
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      ----- table userdata of items after selected items
      next_item = reaper.GetTrackMediaItem(tracks_userdata, i+1)
      if next_item ~= nil then
        is_next_item_selected = reaper.IsMediaItemSelected(next_item)
        if is_item_selected and is_next_item_selected ~= true then
          ----- userdata last next item after last selected
          track_next_last_sel_item_smart_back = next_item
          -----
        end
      end
      ------
      
      ----- set nil for last next item if first item is selected
      is_last_item_selected = reaper.IsMediaItemSelected(last_track_item)
      if is_last_item_selected then

        ----- table userdata of items before selected items
        if temp_last_item ~= nil then
          temp_last_item_selected = reaper.IsMediaItemSelected(temp_last_item)
          if is_item_selected and temp_last_item_selected == false then
            ----- userdata first prev item before first selected
              track_first_prev_sel_item = temp_last_item
            -----
          end
        end
        temp_last_item = item
        -----
      
          track_next_last_sel_item_smart_back = track_first_prev_sel_item
      end
      -----

    end
  end
  return track_next_last_sel_item_smart_back
end

----------------------------------------------------------------------------------
-- • 9 • --
-----------
function asm.getMediaItemsUserdata.firstSelItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts

  if count_track_items >= 1 then

    first_selected_item = nil
  
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      if is_item_selected then
        ----- userdata of first selected item
        if first_selected_item == nil then
          first_selected_item = item
        end
        -----
      end
    end
  end
  return first_selected_item
end

----------------------------------------------------------------------------------
-- • 10 • --
-----------
function asm.getMediaItemsUserdata.lastSelItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
    
    last_selected_item = nil
    
    for i = 0, count_track_items-1 do
      item = reaper.GetTrackMediaItem(tracks_userdata, i)
      is_item_selected = reaper.IsMediaItemSelected(item)
      
      if is_item_selected then
        ----- userdata of last selected item
        last_selected_item = item
        -----
      end
    end
  end
  return last_selected_item
end

----------------------------------------------------------------------------------
-- • 11 • --
-----------
function asm.getMediaItemsUserdata.firsItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then

    first_track_item = nil
  
    ----- userdata of first items in track
    if count_track_items == 1 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    elseif count_track_items >=2 then
      first_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    end
    -----
  end
  return first_track_item
end

----------------------------------------------------------------------------------
-- • 12 • --
-----------
function asm.getMediaItemsUserdata.lastItems(track_idx, proj)
  if proj == nil then proj = 0 end
  
  tracks_userdata = reaper.GetTrack(proj, track_idx-1) -- track userdata
  count_track_items = reaper.CountTrackMediaItems(tracks_userdata) -- track item counts
  
  if count_track_items >= 1 then
    
    last_track_item = nil
  
    ----- userdata of last items in track
    if count_track_items == 1 then
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, 0)
    elseif count_track_items >=2 then
      last_track_item = reaper.GetTrackMediaItem(tracks_userdata, count_track_items-1)
    end
    -----
  end
  return last_track_item
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
asm.doMediaItems = {}

----------------------------------------------------------------------------------
-- • 1 • --
-----------
function asm.doMediaItems.allSelItems(import_idx,                             -- track idx foe 'ONE_TRACK'
                                      track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                      do_function_all_sel_items,              -- all selected items in track
                                      proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_selected_items_userdata_table = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_selected_items_userdata_table = asm.getMediaItemsUserdata.allSelItems(idx_track_sel_track)
    
    -----  -----  -----  1
    if get_track_selected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_selected_items_userdata_table) do
        TB_track_selected_items_userdata_table[#TB_track_selected_items_userdata_table+1] = v
      end
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  1
  if do_function_all_sel_items ~= nil and TB_track_selected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_selected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_all_sel_items(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_selected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 2 • --
-----------
function asm.doMediaItems.allUnselItems(import_idx,                             -- track idx foe 'ONE_TRACK'
                                        track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                        do_function_all_unsel_items,            -- all unselected items in track
                                        proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_unselected_items_userdata_table = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_unselected_items_userdata_table = asm.getMediaItemsUserdata.allUnselItems(idx_track_sel_track)
    
    -----  -----  -----  2
    if get_track_unselected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_unselected_items_userdata_table) do
      TB_track_unselected_items_userdata_table[#TB_track_unselected_items_userdata_table+1] = v
      end
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  2
  if do_function_all_unsel_items ~= nil and TB_track_unselected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_unselected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_all_unsel_items(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_unselected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 3 • --
-----------
function asm.doMediaItems.beforeSelItems( import_idx,                             -- track idx foe 'ONE_TRACK'
                                          track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                          do_function_before_sel_items,           -- all items before even selected in track                                    
                                          proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_before_selected_items_userdata_table = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_before_selected_items_userdata_table = asm.getMediaItemsUserdata.beforeSelItems(idx_track_sel_track)
    
    -----  -----  -----  3
    if get_track_before_selected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_before_selected_items_userdata_table) do
      TB_track_before_selected_items_userdata_table[#TB_track_before_selected_items_userdata_table+1] = v
      end
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  3
  if do_function_before_sel_items ~= nil and TB_track_before_selected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_before_selected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_before_sel_items(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_before_selected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 4 • --
-----------
function asm.doMediaItems.afterSelItems(import_idx,                             -- track idx foe 'ONE_TRACK'
                                        track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                        do_function_after_sel_items,            -- all items after even selected in track
                                        proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_after_selected_items_userdata_table = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_after_selected_items_userdata_table = asm.getMediaItemsUserdata.afterSelItems(idx_track_sel_track)
    -----  -----  -----  4
    if get_track_after_selected_items_userdata_table ~= nil then
      for k, v in pairs(get_track_after_selected_items_userdata_table) do
        TB_track_after_selected_items_userdata_table[#TB_track_after_selected_items_userdata_table+1] = v
      end
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  4
  if do_function_after_sel_items ~= nil and TB_track_after_selected_items_userdata_table ~= nil then
    for k, v in pairs(TB_track_after_selected_items_userdata_table) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_after_sel_items(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_after_selected_items_userdata_table
end

----------------------------------------------------------------------------------
-- • 5 • --
-----------
function asm.doMediaItems.firstPrevSelItem(import_idx,                             -- track idx foe 'ONE_TRACK'
                                          track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                          do_function_first_prev_sel_item,        -- one first item before first selected items in track
                                          proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_first_prev_sel_item = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_first_prev_sel_item = asm.getMediaItemsUserdata.firstPrevSelItem(idx_track_sel_track)
    -----  -----  -----  5
    if get_track_first_prev_sel_item ~= nil then
      TB_track_first_prev_sel_item[#TB_track_first_prev_sel_item+1] = get_track_first_prev_sel_item
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  5
  if do_function_first_prev_sel_item ~= nil and TB_track_first_prev_sel_item ~= nil then
    for k, v in pairs(TB_track_first_prev_sel_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_prev_sel_item(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_first_prev_sel_item
end

----------------------------------------------------------------------------------
-- • 6 • --
-----------
function asm.doMediaItems.nextLastSelItem(import_idx,                             -- track idx foe 'ONE_TRACK'
                                          track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                          do_function_next_last_sel_item,         -- one last item after last selected items in track
                                          proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_next_last_sel_item = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_next_last_sel_item = asm.getMediaItemsUserdata.nextLastSelItem(idx_track_sel_track)
    
    -----  -----  -----  6
    if get_track_next_last_sel_item ~= nil then
      TB_track_next_last_sel_item[#TB_track_next_last_sel_item+1] = get_track_next_last_sel_item
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  6
  if do_function_next_last_sel_item ~= nil and TB_track_next_last_sel_item ~= nil then
    for k, v in pairs(TB_track_next_last_sel_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_next_last_sel_item(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_next_last_sel_item
end

----------------------------------------------------------------------------------
-- • 7 • --
-----------
function asm.doMediaItems.firstPrevSelItemSmartBack(import_idx,                             -- track idx foe 'ONE_TRACK'
                                                    track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                                    do_function_first_prev_sel_item_smart_back,        -- one first item before first selected items in track
                                                    proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_first_prev_sel_item_smart_back = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_first_prev_sel_item_smart_back = asm.getMediaItemsUserdata.firstPrevSelItemSmartBack(idx_track_sel_track)
    -----  -----  -----  7
    if get_track_first_prev_sel_item_smart_back ~= nil then
    TB_track_first_prev_sel_item_smart_back[#TB_track_first_prev_sel_item_smart_back+1] = get_track_first_prev_sel_item_smart_back
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  7
  if do_function_first_prev_sel_item_smart_back ~= nil and TB_track_first_prev_sel_item_smart_back ~= nil then
    for k, v in pairs(TB_track_first_prev_sel_item_smart_back) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_prev_sel_item_smart_back(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_first_prev_sel_item_smart_back
end

----------------------------------------------------------------------------------
-- • 8 • --
-----------
function asm.doMediaItems.nextLastSelItemSmartBack( import_idx,                             -- track idx foe 'ONE_TRACK'
                                                    track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                                    do_function_next_last_sel_item_smart_back,         -- one last item after last selected items in track
                                                    proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_track_next_last_sel_item_smart_back = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_track_next_last_sel_item_smart_back = asm.getMediaItemsUserdata.nextLastSelItemSmartBack(idx_track_sel_track)
    
    -----  -----  -----  8
    if get_track_next_last_sel_item_smart_back ~= nil then
    TB_track_next_last_sel_item_smart_back[#TB_track_next_last_sel_item_smart_back+1] = get_track_next_last_sel_item_smart_back
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  8
  if do_function_next_last_sel_item_smart_back ~= nil and TB_track_next_last_sel_item_smart_back ~= nil then
    for k, v in pairs(TB_track_next_last_sel_item_smart_back) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_next_last_sel_item_smart_back(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_track_next_last_sel_item_smart_back
end

----------------------------------------------------------------------------------
-- • 9 • --
-----------
function asm.doMediaItems.firstSelItems(import_idx,                             -- track idx foe 'ONE_TRACK'
                                      track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                      do_function_first_selected_item,        -- one first selected item
                                      proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_first_selected_item = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_first_selected_item = asm.getMediaItemsUserdata.firstSelItems(idx_track_sel_track)
    
    -----  -----  -----  7
    if get_first_selected_item ~= nil then
      TB_first_selected_item[#TB_first_selected_item+1] = get_first_selected_item
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  7
  if do_function_first_selected_item ~= nil and TB_first_selected_item ~= nil then
    for k, v in pairs(TB_first_selected_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_selected_item(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_first_selected_item
end

----------------------------------------------------------------------------------
-- • 10 • --
------------
function asm.doMediaItems.lastSelItems(import_idx,                             -- track idx foe 'ONE_TRACK'
                                        track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                        do_function_last_selected_item,         -- one last selected item
                                        proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_last_selected_item = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_last_selected_item = asm.getMediaItemsUserdata.lastSelItems(idx_track_sel_track)
    
    -----  -----  -----  1
    if get_last_selected_item ~= nil then
      TB_last_selected_item[#TB_last_selected_item+1] = get_last_selected_item
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  1
  if do_function_last_selected_item ~= nil and TB_last_selected_item ~= nil then
    for k, v in pairs(TB_last_selected_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_last_selected_item(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_last_selected_item
end

----------------------------------------------------------------------------------
-- • 11 • --
------------
function asm.doMediaItems.firsItems(import_idx,                             -- track idx foe 'ONE_TRACK'
                                    track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                    do_function_first_item,                 -- first item in track
                                    proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_first_track_item = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_first_track_item = asm.getMediaItemsUserdata.firsItems(idx_track_sel_track)
    
    -----  -----  -----  9
    if get_first_track_item ~= nil then
      TB_first_track_item[#TB_first_track_item+1] = get_first_track_item
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  9
  if do_function_first_item ~= nil and TB_first_track_item ~= nil then
    for k, v in pairs(TB_first_track_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_first_item(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_first_track_item
end

----------------------------------------------------------------------------------
-- • 12 • --
------------
function asm.doMediaItems.lastItems(import_idx,                             -- track idx foe 'ONE_TRACK'
                                      track_or_items,                         -- 'SEL_ITEM' or 'SEL_TRACK' or 'ONE_TRACK'
                                      do_function_last_item,                  -- last item in track
                                      proj)
                                                  
  if proj == nil then proj = 0 end
  
  if track_or_items == 'SEL_ITEM' then
    count_sel_items = reaper.CountSelectedMediaItems(proj) -- count selected items
    idx_sel_item_track_table = {}
    sel_item_track_i = 1
    idx_sel_item_track_old = -100
    count_sel_item_track = 0
    for i = 0, count_sel_items-1 do
      sel_item = reaper.GetSelectedMediaItem(proj, i)
      sel_item_track = reaper.GetMediaItemTrack(sel_item)
      idx_sel_item_track =  reaper.GetMediaTrackInfo_Value(sel_item_track, 'IP_TRACKNUMBER')
      if idx_sel_item_track ~= idx_sel_item_track_old then
        idx_sel_item_track_table[sel_item_track_i] = idx_sel_item_track
        sel_item_track_i = sel_item_track_i + 1
        idx_sel_item_track_old = idx_sel_item_track
        count_sel_item_track = count_sel_item_track + 1
      end
    end
    count_sel_tracks = count_sel_item_track
  elseif track_or_items == 'SEL_TRACK' then
    count_sel_tracks = reaper.CountSelectedTracks(proj) -- track item counts
  elseif track_or_items == 'ONE_TRACK' then
    count_sel_tracks = 1
  else
    return
  end
  
  TB_last_track_item = {}
  
  ----------------------------------------------------------------------------------
  for i = 0, count_sel_tracks-1 do
    if track_or_items == 'SEL_ITEM' then
      idx_track_sel_track = idx_sel_item_track_table[i+1]
    elseif track_or_items == 'SEL_TRACK' then
      sel_track = reaper.GetSelectedTrack(proj, i)
      idx_track_sel_track =  reaper.GetMediaTrackInfo_Value(sel_track, 'IP_TRACKNUMBER')
    elseif track_or_items == 'ONE_TRACK' then
      idx_track_sel_track =  import_idx
    end
    
    
    get_last_track_item = asm.getMediaItemsUserdata.lastItems(idx_track_sel_track)
    
    -----  -----  -----  1
    if get_last_track_item ~= nil then
      TB_last_track_item[#TB_last_track_item+1] = get_last_track_item
    end
  end

  ----------------------------------------------------------------------------------
  -----  -----  -----  1
  if do_function_last_item ~= nil and TB_last_track_item ~= nil then
    for k, v in pairs(TB_last_track_item) do
      if v ~= nil then
        v_item_track = reaper.GetMediaItemTrack(v)
        do_function_last_item(v, v_item_track)
      end
    end
  end

  ----------------------------------------------------------------------------------
  return  TB_last_track_item
end

----------------------------------------------------------------
------------------------- DESCRIPTION --------------------------
----------------------------------------------------------------
--function ACTION_FUNCTION(temp_item, temp_track)
--end

------ (_, '', 1_all_sel, 2_all_unsel, 3_all_before_sel, 4_all_after_sel,
------      5_first_before_sel, 6_last_after_sel, 7_first_before_sel_smart_back, 8_last_after_sel_smart_back,
------      7_first_sel, 10_last_sel, 11_first, 12_last, proj)
--asm.doTrackItems(_idx, 'SEL_ITEM', _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12)

------ idx_of_track

------ 'SEL_ITEM' - use items on traks with selected items
------ 'SEL_TRACK' - use items on selected traks
------ 'ONE_TRACK' - use items on idx_of_track (1st parameter) tracks
------ (idx_of_track, 'SEL_ITEM', ACTION_FUNCTION)

--asm.doMediaItems.allSelItems      (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 1 - all selected items in track
--asm.doMediaItems.allUnselItems    (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 2 - all unselected items in track
--asm.doMediaItems.beforeSelItems   (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 3 - all items before even selected in track
--asm.doMediaItems.afterSelItems    (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 4 - all items after even selected in track
--asm.doMediaItems.firstPrevSelItem (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 5 - one first item before first selected items in track
--asm.doMediaItems.nextLastSelItem  (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 6 - one last item after last selected items in track
--asm.doMediaItems.firstPrevSelItemSmartBack (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 7 - one first item before first selected items in track
--asm.doMediaItems.nextLastSelItemSmartBack  (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 8 - one last item after last selected items in track
--asm.doMediaItems.firstSelItems    (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 9 - one first selected item
--asm.doMediaItems.lastSelItems     (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 10 - one last selected item
--asm.doMediaItems.firsItems        (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 11 - first item in track
--asm.doMediaItems.lastItems        (_, 'SEL_ITEM', _ACTION_FUNCTION)  -- 12 - last item in track
----------------------------------------------------------------
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[function asm.msg(message)
  reaper.ShowConsoleMsg('"'..tostring(message)..'": '..tostring(message).."\n")
  --reaper.ShowConsoleMsg("")
end]]--


--[[function asm.getTextWindow(title, fields_num, field_title, field_text)
  is_text, get_text_stop = reaper.GetUserInputs(title, fields_num, field_title, field_text)
  if is_text then
    text = get_text_stop
  end
  return text
end]]

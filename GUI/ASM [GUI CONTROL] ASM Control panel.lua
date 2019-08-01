--[[
 * ReaScript Name: ASM [GUI CONTROL] ASM Control panel
 * Instructions: Just use 
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.1.6
 * Description: Use and join
--]]

--[[
 * Changelog:
 * v1.0.0 (2018-07-05)
  + Initial release
 * v1.1.0 (2018-07-06)
  + New buttons in the left side
 * v1.1.5 (2019-03-14)
  + Add LMB swipe to change button state
  # Change behavior color functional button on left side 
  # Fix font color
 * v1.1.6 (2019-03-16)
  # Update code
 * v1.1.7 (2019-04-10)
  # Update code
--]]

script_title='ASM [GUI CONTROL] ASM Control panel'

local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."asm"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."math"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."other"..".lua")

----------------------------------------------------------------------
------------------------------ CHEKERS -------------------------------
----------------------------------------------------------------------
function cheker_nothing() end
function cheker() reaper.defer(cheker_nothing) reaper.atexit(cheker_nothing) end

count_tracks_all =  reaper.CountTracks(0)
if not count_tracks_all then cheker() end --Cheker
count_tracks_selected = reaper.CountSelectedTracks(0)
if not count_tracks_selected then cheker() end --Cheker
----------------------------------------------------------------------
--------------------------- WINDOWS SIZE -----------------------------
----------------------------------------------------------------------
local zoom_indx_count = count_tracks_all
local window_w_start = (zoom_indx_count*20)+10
local window_h_start = 120
local zoom = 2
local window_w = window_w_start*zoom
local window_h = window_h_start*zoom
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
--local indx_numb_old = -2
----------------------------------------------------------------------
------------------------- ASM SHORTS ---------------------------------
----------------------------------------------------------------------
--[[asm = {
  getRGBA = function (rgbR, rgbG, rgbB, rgbA) -- Convert RGB to float numbers
      rgbR, rgbG, rgbB, rgbA = rgbR/255, rgbG/255, rgbB/255, rgbA/255
      return rgbR, rgbG, rgbB, rgbA
  end,
  setColor = function(r, g, b, a) gfx.r, gfx.g, gfx.b, gfx.a = asm.getRGBA(r, g, b, a) return r, g, b, a end, --set (and return) convertetd RGBA color
  setXY = function(x, y) gfx.x, gfx.y = x, y end, --set x, y coordinates
  doCommandID = function(cID_input, type) --commandID, type: 1 - Main , 2- MIDI )
    if type == 'MAIN' then commandID = reaper.NamedCommandLookup(cID_input) reaper.Main_OnCommand(commandID, 0)
    elseif type == 'MIDI' then activeMidiEditor = reaper.MIDIEditor_GetActive() commandID = reaper.NamedCommandLookup(cID_input) reaper.MIDIEditor_OnCommand(activeMidiEditor, commandID) end
  end
}]]
--------------------------------------------------
--[[function asm.table_join(table_1, table_2)
  if table_1 and table_2 then
    new_concat_table_2 = table_2
    new_concat_table_1 = table_1
    local i = #table_2 + 1
    for k_2, v_2 in pairs(table_2) do
      for k_1, v_1 in pairs(table_1) do
        if v_2 == v_1 then
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
end]]
---------------------------------------
function asm.get_mouse_down_state()
  if gfx.mouse_cap ~= 0 then
    mouse_down_state = 1
  else
    mouse_down_state = 0
  end
  return mouse_down_state
end
----------------------------------------------------------------------
---------------------- setmetatable FUNCTION -------------------------
----------------------------------------------------------------------
function extended(Child, Parent)
  setmetatable(Child,{__index = Parent}) 
end

----------------------------------------------------------------------
---------------------- CREATE BUTTON ---------------------------------
----------------------------------------------------------------------
Element = {}
function Element:new_elem(x, y, w, h, fill,
                          text_1, r_1, g_1, b_1, a_1, text_2, r_2, g_2, b_2, a_2,
                          state_boolean, font, font_size, font_type, font_r, font_g, font_b, font_a,
                          frame_x, frame_y, frame_w, frame_h, frame_r, frame_g, frame_b, frame_a, indx_numb,
                          func_01, func_02, func_03, func_04, func_05, func_06, func_07, func_08, func_09, func_10,
                          func_11, func_12, func_13, func_14, func_15, func_16, func_17, func_18, func_19, func_20,
                          func_21 ,func_22 ,func_23 ,func_24 ,func_25 ,func_26 ,func_27 ,func_28 ,func_29 ,func_30,
                          func_31 ,func_32 ,func_33 ,func_34 ,func_35 ,func_36 ,func_37 ,func_38 ,func_39 ,func_40,
                          func_41 ,func_42 ,func_43 ,func_44 ,func_45 ,func_46 ,func_47 ,func_48 ,func_49 ,func_50)
    local elem = {}
      elem.x, elem.y, elem.w, elem.h, elem.fill = x, y, w, h, fill
      elem.text_1, elem.r_1, elem.g_1, elem.b_1, elem.a_1 = text_1, r_1, g_1, b_1, a_1
      elem.text_2, elem.r_2, elem.g_2, elem.b_2, elem.a_2 = text_2, r_2, g_2, b_2, a_2
      elem.state_boolean, elem.font, elem.font_size, elem.font_type = state_boolean, font, font_size, font_type 
      elem.font_r, elem.font_g, elem.font_b, elem.font_a= font_r, font_g, font_b, font_a
      elem.frame_x, elem.frame_y, elem.frame_w, elem.frame_h = frame_x, frame_y, frame_w, frame_h
      elem.frame_r, elem.frame_g, elem.frame_b, elem.frame_a, elem.indx_numb = frame_r, frame_g, frame_b, frame_a, indx_numb
      elem.func_01, elem.func_02, elem.func_03, elem.func_04, elem.func_05 = func_01, func_02, func_03, func_04, func_05
      elem.func_06, elem.func_07, elem.func_08, elem.func_09, elem.func_10 = func_06, func_07, func_08, func_09, func_10
      elem.func_11, elem.func_12, elem.func_13, elem.func_14, elem.func_15 = func_11, func_12, func_13, func_14, func_15
      elem.func_16, elem.func_17, elem.func_18, elem.func_19, elem.func_20 = func_16, func_17, func_18, func_19, func_20
      elem.func_21, elem.func_22, elem.func_23, elem.func_24, elem.func_25 = func_21, func_22, func_23, func_24, func_25
      elem.func_26, elem.func_27, elem.func_28, elem.func_29, elem.func_30 = func_26, func_27, func_28, func_29, func_30
      elem.func_31, elem.func_32, elem.func_33, elem.func_34, elem.func_35 = func_31, func_32, func_33, func_34, func_35
      elem.func_36, elem.func_37, elem.func_38, elem.func_39, elem.func_40 = func_36, func_37, func_38, func_39, func_40
      elem.func_41, elem.func_42, elem.func_43, elem.func_44, elem.func_45 = func_41, func_42, func_43, func_44, func_45
      elem.func_46, elem.func_47, elem.func_48, elem.func_49, elem.func_50 = func_46, func_47, func_48, func_49, func_50
      extended(elem, self)
    return elem
end

function Element:hot_keys(hk_func_01, hk_func_02, hk_func_03, hk_func_04, hk_func_05,
                          hk_func_06, hk_func_07, hk_func_08, hk_func_09, hk_func_10)
  
  LMB   = (gfx.mouse_cap & 1) ~= 0
  RMB   = (gfx.mouse_cap & 2) ~= 0
  Ctrl  = (gfx.mouse_cap & 4) ~= 0
  Shift = (gfx.mouse_cap & 8) ~= 0
  Alt   = (gfx.mouse_cap & 16) ~= 0
  Win   = (gfx.mouse_cap & 32) ~= 0
  MMB   = (gfx.mouse_cap & 64) ~= 0
  
  --if gfx.getchar() > 0 then Msg(Char) hk_func_01() end -- Ctrl+Aa
  --if gfx.getchar() == 4 then Msg('0000000') hk_func_02() end -- Ctrl+D
  --if gfx.getchar() == 4 then hk_func_02() end -- Ctrl+D
  --[[Ctrl_z = gfx.getchar() 
  Ctrl_Shift_z = gfx.getchar()
  Space = gfx.getchar()
  S = gfx.getchar()
  M = gfx.getchar()]]
  
  
  --[[Char = gfx.getchar()
  if gfx.getchar() ~= 0 then
  Msg('0')
  end]]
  
  
  --if Ctrl_a then hk_func_01() end --Track: Select all tracks
--  if Ctrl_d then hk_func_02() end --Track: Unelect all tracks
end
------------------------------------------------------------------
------------------------------------------------------------------
Button = {}
extended(Button, Element)
--button.state = false

function Button:create()
  x, y, w, h, fill = self.x, self.y, self.w, self.h, self.fill
  func_1, text_1, r_1, g_1, b_1, a_1 = self.func_1, self.text_1, self.r_1, self.g_1, self.b_1, self.a_1
  func_2, text_2, r_2, g_2, b_2, a_2 = self.func_2, self.text_2, self.r_2, self.g_2, self.b_2, self.a_2
  state_boolean, font, font_size, font_type = self.state_boolean, self.font, self.font_size, self.font_type
  font_r, font_g, font_b, font_a = self.font_r, self.font_g, self.font_b, self.font_a
  fr_x, fr_y, fr_w, fr_h = self.frame_x, self.frame_y, self.frame_w, self.frame_h
  fr_r, fr_g, fr_b, fr_a, indx_numb = self.frame_r, self.frame_g, self.frame_b, self.frame_a, self.indx_numb
  func_01_LMB, func_02_LMB, func_03_LMB_ctrl, func_04_LMB_ctrl = self.func_01, self.func_02, self.func_03, self.func_04
  func_05_LMB_shift, func_06_LMB_shift, func_07_LMB_alt, func_08_LMB_alt = self.func_05, self.func_06, self.func_07, self.func_08
  func_09_LMB_ctrl_shift, func_10_LMB_ctrl_shift, func_11_LMB_ctrl_alt, func_12_LMB_ctrl_alt = self.func_09, self.func_10, self.func_11, self.func_12
  func_13_LMB_shift_alt, func_14_LMB_shift_alt, func_15_LMB_ctrl_shift_alt, func_16_LMB_ctrl_shift_alt = self.func_13, self.func_14, self.func_15, self.func_16
  func_17, func_18, func_19, func_20 = self.func_17, self.func_18, self.func_19, self.func_20
  func_21, func_22, func_23, func_24, func_25 = self.func_21, self.func_22, self.func_23, self.func_24, self.func_25
  func_26, func_27, func_28, func_29, func_30 = self.func_26, self.func_27, self.func_28, self.func_29, self.func_30
  func_31, func_32, func_33, func_34, func_35 = self.func_31, self.func_32, self.func_33, self.func_34, self.func_35
  func_36, func_37, func_38, func_39, func_40 = self.func_36, self.func_37, self.func_38, self.func_39, self.func_40
  func_41, func_42, func_43, func_44, func_45 = self.func_41, self.func_42, self.func_43, self.func_44, self.func_45
  func_46, func_47, func_48, func_49, func_50 = self.func_46, self.func_47, self.func_48, self.func_49, self.func_50
  x, y, w, h, fr_x, fr_y, fr_w, fr_h, font_size = x*zoom, y*zoom, w*zoom, h*zoom, fr_x*zoom, fr_y*zoom, fr_w*zoom, fr_h*zoom ,font_size*zoom -- zooming some varibles
  Button:hot_keys()
  Button:mouse_on()
  Button:LMB()
  Button:RMB()
  Button:change_on_off()
  Button:color_on()
  Button:draw_bg()
  Button:draw_frame()
  Button:draw_text()
end
------------------------------------------------------------------
function Button:draw_bg()
  gfx.rect(x, y, w, h, fill)
end
------------------------------------------------------------------
function Button:draw_frame()
  asm.setColor(fr_r, fr_g, fr_b, fr_a)
  gfx.rect(fr_x, fr_y, fr_w, fr_h, false)
end
------------------------------------------------------------------
function Button:mouse_on()            
  mouse_on_button =
                (gfx.mouse_x > x-1 and gfx.mouse_x < x+w) and
                (gfx.mouse_y > y-1 and gfx.mouse_y < y+h)
end
------------------------------------------------------------------
function Button:change_on_off()
  if not state_boolean then
               r, g, b, a = r_1, g_1, b_1, a_1
               text = text_1
             else
               r, g, b, a = r_2, g_2, b_2, a_2
               text = text_2
             end
end
------------------------------------------------------------------
function Button:color_on()
            if (gfx.mouse_cap & 1) == 0 and mouse_on_button then
              asm.setColor(r+20, g+20, b+20, a)
              button_up = true
            else
              asm.setColor(r, g, b, a)
            end
end
------------------------------------------------------------------
function Button:draw_text()
  gfx.setfont(1, font, font_size, font_type)
  asm.setColor(font_r, font_g, font_b, font_a)
  text_w, text_h = gfx.measurestr(text)
  text_x = ((w - text_w) / 2 + x)
  text_y = ((h - text_h) / 2 + y)
  asm.setXY(text_x, text_y)
  gfx.drawstr(text)
end
------------------------------------------------------------------
function Button:LMB()

  LMB   = (gfx.mouse_cap & 1) ~= 0
  RMB   = (gfx.mouse_cap & 2) ~= 0
  Ctrl  = (gfx.mouse_cap & 4) ~= 0
  Shift = (gfx.mouse_cap & 8) ~= 0
  Alt   = (gfx.mouse_cap & 16) ~= 0
  Win   = (gfx.mouse_cap & 32) ~= 0
  MMB   = (gfx.mouse_cap & 64) ~= 0  

  if LMB and Ctrl and Shift and Alt and mouse_on_button then --LMB+Ctrl+Shift+Alt
    reaper.Undo_BeginBlock()
    asm.setColor(r-30, g-30, b-30, a)
        if func_15_LMB_ctrl_shift_alt or func_16_LMB_ctrl_shift_alt then
        
          if state_boolean and button_up then
            func_15_LMB_ctrl_shift_alt(indx_numb)
          elseif button_up then
            func_16_LMB_ctrl_shift_alt(indx_numb)
          end
        end
   button_up = false
  elseif LMB and Shift and Alt and mouse_on_button then --LMB+Shift+Alt
    reaper.Undo_BeginBlock()
    asm.setColor(r-30, g-30, b-30, a)
        if func_13_LMB_shift_alt or func_14_LMB_shift_alt then
          if state_boolean and button_up then
            func_13_LMB_shift_alt(indx_numb)
          elseif button_up then
            func_14_LMB_shift_alt(indx_numb)
          end
        end
   button_up = false
  elseif LMB and Ctrl and Alt and mouse_on_button then --LMB+Ctrl+Alt
    reaper.Undo_BeginBlock()
    asm.setColor(r-30, g-30, b-30, a)
        if func_11_LMB_ctrl_alt or func_12_LMB_ctrl_alt then
          if state_boolean and button_up then
            func_11_LMB_ctrl_alt(indx_numb)
          elseif button_up then
            func_12_LMB_ctrl_alt(indx_numb)
          end
        end
   button_up = false
  elseif LMB and Ctrl and Shift and mouse_on_button then --LMB+Ctrl+Shift
    reaper.Undo_BeginBlock()
    asm.setColor(r-30, g-30, b-30, a)
        if func_09_LMB_ctrl_shift or func_10_LMB_ctrl_shift then
          if state_boolean and button_up then
            func_09_LMB_ctrl_shift(indx_numb)
          elseif button_up then
            func_10_LMB_ctrl_shift(indx_numb)
          end
        end
    button_up = false
  elseif LMB and Alt and mouse_on_button then -- LMB+Alt
    reaper.Undo_BeginBlock()
    asm.setColor(r-30, g-30, b-30, a)
      if func_07_LMB_alt or func_08_LMB_alt then
        if state_boolean and button_up then
          func_07_LMB_alt(indx_numb)
        elseif button_up then
          func_08_LMB_alt(indx_numb)
        end
      end
   button_up = false
  elseif LMB and Shift and mouse_on_button then -- LMB+Shift
    reaper.Undo_BeginBlock()
    asm.setColor(r-30, g-30, b-30, a)
      if func_05_LMB_shift or func_06_LMB_shift then
        if state_boolean and button_up then
          func_05_LMB_shift(indx_numb)
        elseif button_up then
          func_06_LMB_shift(indx_numb)
        end
      end
   button_up = false
  elseif LMB and Ctrl and mouse_on_button then --LMB+Ctrl
    reaper.Undo_BeginBlock()
    asm.setColor(r-30, g-30, b-30, a)
      if func_03_LMB_ctrl or func_04_LMB_ctrl then
        if state_boolean and button_up then
          func_03_LMB_ctrl(indx_numb)
        elseif button_up then
          func_04_LMB_ctrl(indx_numb)
        end
      end
   button_up = false
  elseif LMB and mouse_on_button then --LMB
    reaper.Undo_BeginBlock()
      asm.setColor(r-50, g-50, b-50, a)
      if func_01_LMB or func_02_LMB then
        if state_boolean and button_up then
          func_01_LMB(indx_numb)
        elseif button_up then
          func_02_LMB(indx_numb)
        end
      end
      if indx_numb ~= indx_numb_old and button_up then --and changed_state then
        button_up = false
        indx_numb_old = indx_numb
      elseif indx_numb == indx_numb_old and button_up then
        button_up = false
        indx_numb_old = indx_numb
      elseif indx_numb ~= indx_numb_old then
        button_up = true
        indx_numb_old = indx_numb
      end
  end
  reaper.Undo_EndBlock(script_title, -1)
end
------------------------------------------------------------------
function Button:RMB()
  if (gfx.mouse_cap & 2) ~= 0 and mouse_on_button then
    asm.setColor(r-30, g-30, b-30, a)
    menu_x, menu_y = gfx.clienttoscreen(gfx.mouse_x,gfx.mouse_y)
      if func_1_LMB or func_1_LMB then
         if button_up then
           reaper.ShowPopupMenu('track_panel', menu_x, gfx.mouse_y, _, 0, 0, 0)
         elseif button_up then
           reaper.ShowPopupMenu('track_panel', menu_x, gfx.mouse_y, _, 0, 0, 0)
         end
      end
  button_up = false
  end
end

----------------------------------------------------------------------
-------------------------- MAIN FUNCTION -----------------------------
----------------------------------------------------------------------
function MAIN()
  window_w = window_w_start*zoom
  window_h = window_h_start*zoom
  window_w_start = (zoom_indx_count*20)+10
  window_h_start = window_h_start
  
  local mouse_on_window =
      (gfx.mouse_x > 0 and gfx.mouse_x < window_w) and
      (gfx.mouse_y > 0 and gfx.mouse_y < window_h)
  
  asm.setColor(0, 0, 0, 255)
  gfx.rect(0, 0, window_w, window_h, true)
  
---------------------------------------------------------------------

----------------------------------------------------------------------
----------------------- FUNCTION FOR BUTTONS -------------------------
----------------------------------------------------------------------
  count_tracks_all =  reaper.CountTracks(0)
  if not count_tracks_all then cheker() end --Cheker
-------------------------------------  
-------------------------------------
------------------01 select-----------------
  --[[function func_1_tr_unsel(track_numb) --LMB
    local track = reaper.GetTrack(0, track_numb)
    reaper.Main_OnCommand(40297, 0)--Track: Unselect all tracks
    reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', 0)
    --commandID = reaper.NamedCommandLookup("40913") --vertical scroll selected track
    reaper.Main_OnCommand(40913, 0)--vertical scroll selected track
  end]]
  function func_2_tr_sel(track_numb) --LMB
    local track = reaper.GetTrack(0, track_numb)
    reaper.Main_OnCommand(40297, 0)--Track: Unselect all tracks
    reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', 1)
    --commandID = reaper.NamedCommandLookup("40913") --vertical scroll selected track
    reaper.Main_OnCommand(40913, 0)--vertical scroll selected track
  end
  
  function func_3_tr_unsel_ctrl(track_numb) --LMB_Ctrl
    local track = reaper.GetTrack(0, track_numb)
    reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', 0)
  end
  function func_4_tr_sel_ctrl(track_numb)
    local track = reaper.GetTrack(0, track_numb)
    reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', 1)
  end
  
  function func_6_tr_sel_shift(track_numb) --LMB_Shift
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    for k, tr in pairs(sel_tracks) do
      first_tr = sel_tracks[1]
      last_tr = tr
    end
    reaper.Main_OnCommand(40297, 0)--Track: Unselect all tracks
    if track_numb < first_tr then
      for track_numb = track_numb, first_tr do
        local track = reaper.GetTrack(0, track_numb)
        reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', 1)
      end
    elseif track_numb > last_tr then 
      for last_tr = last_tr, track_numb do
        local track = reaper.GetTrack(0, last_tr)
        reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', 1)
      end
    else 
      local track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', 1)
    end
  end
  
------------------02 color-----------------
  function func_1_color_for_sel(track_numb) --LMB
    apply, new_track_color = reaper.GR_SelectColor()
    if apply == 1 then
      local sel_tracks = asm.countTracksState('I_SELECTED', 1)
      if sel_tracks then
        for k, tr in pairs(sel_tracks) do
          if track_numb == tr and tr then
            for k2, tr2 in pairs(sel_tracks) do
              track = reaper.GetTrack(0, tr2)
              reaper.SetTrackColor(track, new_track_color)
            end
          else
            track = reaper.GetTrack(0, track_numb)
            reaper.SetTrackColor(track, new_track_color)
          end
        end
      else
        track = reaper.GetTrack(0, track_numb)
        reaper.SetTrackColor(track, new_track_color)
      end
    end
  end
  
  function func_4_color_one_random_for_sel_ctrl_alt(track_numb) --LMB_Ctrl random color for selected tracks
    reaper.Main_OnCommand(40360, 0) --Track: Set to one random color
  end
  
  function func_5_color_for_one_shift(track_numb) -- LMB_Shift
    apply, new_track_color = reaper.GR_SelectColor()
    if apply == 1 then
      track = reaper.GetTrack(0, track_numb)
      reaper.SetTrackColor(track, new_track_color)
    end
  end
  function func_7_color_random_for_sel_alt(track_numb) --LMB_Alt random color for selected tracks
    reaper.Main_OnCommand(40358, 0) --Track: Set to random colors
  end
------------------03 Mute-----------------
  function func_1_m_off(track_numb)                     --LMB 01 Mute_off
      local sel_tracks = asm.countTracksState('I_SELECTED', 1)
      if sel_tracks then
        for k, tr in pairs(sel_tracks) do
          if track_numb == tr and tr then
            for k2, tr2 in pairs(sel_tracks) do
              track = reaper.GetTrack(0, tr2)
              reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 0)
            end
          else
            track = reaper.GetTrack(0, track_numb)
            reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 0)
          end
        end
      else
        track = reaper.GetTrack(0, track_numb)
        reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 0)
      end
  end
  function func_2_m_on(track_numb)                      --LMB 02 Mute_on
      local sel_tracks = asm.countTracksState('I_SELECTED', 1)
      if sel_tracks then
        for k, tr in pairs(sel_tracks) do
          if track_numb == tr and tr then
            for k2, tr2 in pairs(sel_tracks) do
              track = reaper.GetTrack(0, tr2)
              reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 1)
            end
          else
            track = reaper.GetTrack(0, track_numb)
            reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 1)
          end
        end
      else
        track = reaper.GetTrack(0, track_numb)
        reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 1)
      end
  end
  function func_5_m_off_shift(track_numb)                    --LMB_Shift 03 Mute_off
        track = reaper.GetTrack(0, track_numb)
        reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 0)
  end
  function func_6_m_on_shift(track_numb)                    --LMB_Shift 04 Mute_on
        track = reaper.GetTrack(0, track_numb)
        reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 1)
  end
------------------04 Solo-----------------
  function func_1_s_off(track_numb)                      --LMB 01 Solo_off
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 0)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 0)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 0)
    end
  end
  function func_2_s_on(track_numb)                       --LMB 02 Solo_on
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 1)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 1)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 1)
    end
  end
  function func_5_s_off_shift(track_numb)                    --LMB_Shift 03 Solo_off
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 0)
  end
  function func_6_s_on_shift(track_numb)                    --LMB_Shift 04 Solo_on
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', 1)
  end
------------------04 Record-----------------
  function func_1_rec_off(track_numb)                      --LMB 01 Record_off
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 0)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 0)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 0)
    end
  end
  function func_2_rec_on(track_numb)                       --LMB 02 Record_on
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 1)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 1)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 1)
    end
  end
  function func_5_rec_off_ctrl(track_numb)                    --LMB_Shift 03 Record_off
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 0)
  end
  function func_6_rec_on_ctrl(track_numb)                    --LMB_Shift 04 Recordon_on
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'I_RECARM', 1)
  end
------------------05 TCP show-----------------
  function func_1_tcp_show_off(track_numb)                      --LMB 01 TCP_show_off
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 0)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 0)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 0)
    end
    reaper.TrackList_AdjustWindows(1)
    reaper.UpdateArrange()
  end
  function func_2_tcp_show_on(track_numb)                       --LMB 02 TCP_show_on
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 1)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 1)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 1)
    end
    reaper.TrackList_AdjustWindows(1)
    reaper.UpdateArrange()
  end
  function func_5_tcp_show_off_shift(track_numb)                    --LMB_Shift 03 TCP_show_off
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 0)
      reaper.TrackList_AdjustWindows(1)
      reaper.UpdateArrange()
  end
  function func_6_tcp_show_on_shift(track_numb)                    --LMB_Shift 04 TCP_show_on
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINTCP', 1)
      reaper.TrackList_AdjustWindows(1)
      reaper.UpdateArrange()
  end
------------------05 MCP show-----------------
  function func_1_mcp_show_off(track_numb)                      --LMB 01 MCP_show_off
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 0)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 0)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 0)
    end
    reaper.TrackList_AdjustWindows(0)
    reaper.UpdateArrange()
  end
  function func_2_mcp_show_on(track_numb)                       --LMB 02 MCP_show_on
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
        if track_numb == tr and tr then
          for k2, tr2 in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr2)
            reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 1)
          end
        else
          track = reaper.GetTrack(0, track_numb)
          reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 1)
        end
      end
    else
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 1)
    end
    reaper.TrackList_AdjustWindows(0)
    reaper.UpdateArrange()
  end
  function func_5_mcp_show_off_shift(track_numb)                    --LMB_Shift 03 MCP_show_off
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 0)
      reaper.TrackList_AdjustWindows(0)
      reaper.UpdateArrange()
  end
  function func_6_mcp_show_on_shift(track_numb)                    --LMB_Shift 04 MCP_show_on
      track = reaper.GetTrack(0, track_numb)
      reaper.SetMediaTrackInfo_Value(track, 'B_SHOWINMIXER', 1)
      reaper.TrackList_AdjustWindows(0)
      reaper.UpdateArrange()
  end

--------------------------------------------- 
--------------------------------------------- 
--------------------Settings-----------------
function set_01_number_hide() --LMB Show/hide track numbers
  number_show_state = false
end
function set_02_number_show()
  number_show_state = true
end
---------------------------------------------

function set_01_color_number_hide() --LMB Show/hide track numbers on color state
  number_color_show_state = false
end
function set_02_color_number_show()
  number_color_show_state = true
end

--[[function set_01_color_for_sel(track_numb) --LMB
Msg(01)
  apply, new_track_color = reaper.GR_SelectColor()
  if apply == 1 then
    local sel_tracks = asm.countTracksState('I_SELECTED', 1)
    if sel_tracks then
      for k, tr in pairs(sel_tracks) do
            track = reaper.GetTrack(0, tr)
            reaper.SetTrackColor(track, new_track_color)
      end
    end
  end
end]]--
  
function set_04_color_one_random_for_sel_ctrl_alt(track_numb) --LMB_Ctrl random color for selected tracks
  reaper.Main_OnCommand(40360, 0) --Track: Set to one random color
end
  
function set_07_color_random_for_sel_alt(track_numb) --LMB_Alt random color for selected tracks
  reaper.Main_OnCommand(40358, 0) --Track: Set to random colors
end
---------------------------------------------
function set_01_mute_all_off() --LMB Mute/unmute all
  mute_all_off_state = false
  reaper.Main_OnCommand(40339, 0) --Track: Unmute all tracks
end
function set_02_mute_all_on()
  mute_all_off_state = true
  reaper.Main_OnCommand(40730, 0) --Track: Mute tracks
end
---------------------------------------------
function set_01_solo_all_off() --LMB Solo/unsolo all
  solo_all_off_state = false
  reaper.Main_OnCommand(40340, 0) --Track: Unsolo all tracks
end
function set_02_solo_all_on()
  solo_all_off_state = true
  reaper.Main_OnCommand(40728, 0) --Track: Solo tracks
end
---------------------------------------------
function set_01_rec_all_off() --LMB rec/unre all
  rec_all_off_state = false
  reaper.Main_OnCommand(40491, 0) --Track: Unarm all tracks for recording
end
function set_02_rec_all_on()
  rec_all_off_state = true
  local sel_tracks = asm.countTracksState('I_SELECTED', 1)
  if sel_tracks then
  reaper.Main_OnCommand(9, 1) --Track: Toggle record arm for selected tracks
  end
end
---------------------------------------------
function set_01_tcp_hide() --LMB Show/hide tcp hide tracks
  tcp_show_state = false
  count_tcp_show_tr = asm.countTracksState('B_SHOWINMIXER', 1)
  zoom_indx_count = #count_tcp_show_tr
  return count_tcp_show_tr
end
function set_02_tcp_show()
  tcp_show_state = true
  count_tracks_all =  reaper.CountTracks(0)
  --if not count_tracks_all then cheker() end --Cheker
  tb_count_tcp_show_tr = {}
  for i = 0, count_tracks_all-1 do
    tb_count_tcp_show_tr[i+1] = i
  end
  count_tcp_show_tr = tb_count_tcp_show_tr
  zoom_indx_count = count_tracks_all
  return count_tcp_show_tr
end
---------------------------------------------
function set_01_mcp_hide() --LMB Show/hide tcp hide tracks
  mcp_show_state = false
  count_mcp_show_tr = asm.countTracksState('B_SHOWINTCP', 1)
  zoom_indx_count = #count_mcp_show_tr
  return count_mcp_show_tr
end
function set_02_mcp_show()
  mcp_show_state = true
  count_tracks_all =  reaper.CountTracks(0)
  --if not count_tracks_all then cheker() end --Cheker
  tb_count_mcp_show_tr = {}
  for i = 0, count_tracks_all-1 do
    tb_count_mcp_show_tr[i+1] = i
  end
  count_mcp_show_tr = tb_count_mcp_show_tr
  zoom_indx_count = count_tracks_all
  return count_mcp_show_tr
end

---------------------------------------------
--------------------------------------------- 
--------------------------------------------- 
local track_names = {}
local track_color_numbers = {}
local track_state_m = {}
local track_state_s = {}
local track_state_rec = {}
local track_state_num = {}
local track_state_tcp = {}
local track_state_mcp = {}
local track_state_sel = {}
local track_get_r = {}
local track_get_g = {}
local track_get_b = {}

if tcp_show_state and not mcp_show_state then track_state = set_01_mcp_hide()
elseif not tcp_show_state and mcp_show_state then track_state = set_01_tcp_hide()
elseif not tcp_show_state and not mcp_show_state then track_state = set_02_tcp_show()
tcp_show_state = false mcp_show_state = false
elseif tcp_show_state and mcp_show_state then
tcp_track_state = set_01_tcp_hide() mcp_track_state = set_01_mcp_hide()
  tcp_show_state = true mcp_show_state = true
  main_track_state = asm.table_join(tcp_track_state, mcp_track_state)
  zoom_indx_count = #main_track_state
  track_state = main_track_state
end

--[[if not tcp_show_state and mcp_show_state then track_state = set_01_mcp_hide()
elseif not mcp_show_state and tcp_show_state then track_state = set_01_tcp_hide()
elseif mcp_show_state and tcp_show_state then track_state = set_02_mcp_show()
--[[elseif not mcp_show_state and not tcp_show_state then
  track_state = set_01_mcp_hide()
  for z, y in pairs(track_state) do
    Msg(y)
  end
end]]
local inside_m, inside_s, inside_rec = false, false, false
if track_state then
for tab_i, track_i in pairs(track_state) do
--for track_i = 1, count_tracks_all do
  track_this = reaper.GetTrack(0, track_i)
  is_track_names, track_get_names = reaper.GetTrackName(track_this, '')
  --is_track_name, track_get_name = reaper.GetSetMediaTrackInfo_String(track_this, '', 'P_NAME', 0)
  track_getR, track_getG, track_getB = reaper.ColorFromNative(reaper.GetTrackColor(track_this))
  track_state_ip_num = reaper.GetMediaTrackInfo_Value(track_this, 'IP_TRACKNUMBER')
  track_state_m_on = reaper.GetMediaTrackInfo_Value(track_this, 'B_MUTE') == 1
  track_state_s_on = reaper.GetMediaTrackInfo_Value(track_this, 'I_SOLO') == 1 or
                     reaper.GetMediaTrackInfo_Value(track_this, 'I_SOLO') == 2
  track_state_rec_on = reaper.GetMediaTrackInfo_Value(track_this, 'I_RECARM') == 1
  track_state_sel_on = reaper.GetMediaTrackInfo_Value(track_this, 'I_SELECTED') == 1
  track_state_num[tab_i] =  math.modf(track_state_ip_num)
  --if track_get_name == 'Track N' then track_get_name = '' end
  --Msg(track_get_name)
  track_names[tab_i] = string.sub(track_get_names, 1, 5)
  track_color_numbers[tab_i] = ''
  track_state_m[tab_i] = track_state_m_on
  track_state_s[tab_i] = track_state_s_on
  track_state_rec[tab_i] = track_state_rec_on
  track_state_sel[tab_i] = track_state_sel_on
  track_get_r[tab_i] = track_getR
  track_get_g[tab_i] = track_getG
  track_get_b[tab_i] = track_getB
  
  track_state_tcp_on = reaper.GetMediaTrackInfo_Value(track_this, "B_SHOWINTCP") == 1
  track_state_mcp_on = reaper.GetMediaTrackInfo_Value(track_this, "B_SHOWINMIXER") == 1
  track_state_tcp[tab_i] = track_state_tcp_on
  track_state_mcp[tab_i] = track_state_mcp_on
  
  if track_state_m_on   then  mute_all_off_state = true inside_m =  true
  elseif not inside_m   then  mute_all_off_state = false end
  
  if track_state_s_on   then  solo_all_off_state = true inside_s =  true
  elseif not inside_s   then  solo_all_off_state = false end
 --Msg(track_state_rec[tab_i])
  if track_state_rec_on then  rec_all_off_state =  true inside_rec = true
  elseif not inside_rec then  rec_all_off_state =  false end
end
end

--Msg(rec_all_off_state)
---------------------------------- Settings buttons ----------------------------------
Btn_1 = Button:new_elem(0, 0, 10, 10, true,
                        '', 35, 35, 35, 255, '', 80, 80, 80, 255,
                        number_show_state, 'Calibri', 8, 'b', 20, 20, 20, 255,
                        0, 0, 10, 10, 20, 20, 20, 255, ib,
                        set_01_number_hide, set_02_number_show)

Btn_2 = Button:new_elem(0, 10, 10, 10, true,
                        '', 35, 35, 35, 255, '', 35, 35, 35, 255,
                        number_color_show_state, 'Calibri', 8, 'b', 20, 20, 20, 255,
                        0, 10, 10, 10, 20, 20, 20, 255, ib,
                        set_01_color_number_hide, set_02_color_number_show,
                        set_04_color_one_random_for_sel_ctrl_alt, set_04_color_one_random_for_sel_ctrl_alt,
                        _, _, set_07_color_random_for_sel_alt, set_07_color_random_for_sel_alt)
                        
Btn_3 = Button:new_elem(0, 20, 10, 20, true, --Mute
                        '', 35, 35, 35, 255, '', 175, 50, 50, 255,
                        mute_all_off_state, 'Calibri', 13, 'b', 20, 20, 20, 255,
                        0, 20, 10, 20, 20, 20, 20, 255, ib,
                        set_01_mute_all_off, set_02_mute_all_on)
                        
Btn_4 = Button:new_elem(0, 40, 10, 20, true, --Solo
                        '', 35, 35, 35, 255, '', 200, 150, 50, 255,
                        solo_all_off_state, 'Calibri', 13, 'b', 20, 20, 20, 255,
                        0, 40, 10, 20, 20, 20, 20, 255, ib,
                        set_01_solo_all_off, set_02_solo_all_on)

Btn_5 = Button:new_elem(0, 60, 10, 20, true, -- Record
                        '', 35, 35, 35, 255, '', 200, 70, 70, 255,
                        rec_all_off_state, 'Calibri', 13, 'b', 20, 20, 20, 255,
                        0, 60, 10, 20, 20, 20, 20, 255, ib,
                        set_01_rec_all_off, set_02_rec_all_on)

Btn_6 = Button:new_elem(0, 80, 10, 20, true, --TCP
                        '', 35, 35, 35, 255, '', 80, 80, 80, 255,
                        tcp_show_state, 'Calibri', 8, 'b', 20, 20, 20, 255,
                        0, 80, 10, 20, 20, 20, 20, 255, ib,
                        set_01_tcp_hide, set_02_tcp_show)
                        
Btn_7 = Button:new_elem(0, 100, 10, 20, true, --MCP
                        '', 35, 35, 35, 255, '', 80, 80, 80, 255,
                        mcp_show_state, 'Calibri', 8, 'b', 20, 20, 20, 255,
                        0, 100, 10, 20, 20, 20, 20, 255, ib,
                        set_01_mcp_hide, set_02_mcp_show)

Buttons_tab = {Btn_1, Btn_2, Btn_3, Btn_4, Btn_5, Btn_6, Btn_7}



---------------------------------- BUTTONS PANEL ----------------------------------
local M_btn_1 = {}  --number
local M_btn_2 = {}  --color
local M_btn_3 = {}  --mute
local M_btn_4 = {}  --solo
local M_btn_5 = {}  --record
local M_btn_6 = {} --tcp hide
local M_btn_7 = {} --mcp hide
local M_pos_x = 10
local M_pos_y = 0
if track_state then

if number_show_state then
track_names = track_state_num
else track_names = track_names end

if number_color_show_state then
track_color_numbers = track_state_num
else track_color_numbers = track_color_numbers end

for tab_i, track_i in pairs(track_state) do
--for i = 1, count_tracks_all do
local i = tab_i
local ib = track_i
--[[M_btn_1[i] = Button:new_elem(M_pos_x, M_pos_y, 20, 10, true,
                              track_state_num[i], 20, 20, 20, 255, track_state_num[i], 80, 80, 80, 255,
                              track_state_sel[i], 'Calibri', 10, 'b', 180, 180, 180, 250,
                              M_pos_x, M_pos_y, 20, 10, 20, 20, 20, 255, ib,
                              func_2_tr_sel, func_2_tr_sel, func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl,
                              func_6_tr_sel_shift, func_6_tr_sel_shift)]]
                              
---------------------Buttons varibles---------------------
local btn_text_r, btn_text_g, btn_text_b, btn_text_a = 200, 200, 200, 255
----------------------------------------------------------

M_btn_1[i] = Button:new_elem(M_pos_x, M_pos_y, 20, 10, true,
                              track_names[i], 20, 20, 20, 255, track_names[i], 80, 80, 80, 255,
                              track_state_sel[i], 'Calibri', 8, 'b', btn_text_r, btn_text_g, btn_text_b, btn_text_a,
                              M_pos_x, M_pos_y, 20, 10, 20, 20, 20, 255, ib,
                              func_2_tr_sel, func_2_tr_sel, func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl,
                              func_6_tr_sel_shift, func_6_tr_sel_shift)
                              
M_btn_2[i] = Button:new_elem(M_pos_x, M_pos_y+10, 20, 10, true,
                              --[[track_state_num[i]]track_color_numbers[i], track_get_r[i], track_get_g[i], track_get_b[i], 255,
                              --[[track_state_num[i]]track_color_numbers[i], track_get_r[i], track_get_g[i], track_get_b[i], 255,
                              _, 'Calibri', 8, 'b', btn_text_r, btn_text_g, btn_text_b, btn_text_a,
                              M_pos_x, M_pos_y+10, 20, 10, 20, 20, 20, 255, ib,
                              func_1_color_for_sel, func_1_color_for_sel, func_4_color_one_random_for_sel_ctrl_alt, func_4_color_one_random_for_sel_ctrl_alt,
                              func_5_color_for_one_shift, func_5_color_for_one_shift,
                              func_7_color_random_for_sel_alt, func_7_color_random_for_sel_alt,
                              func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl, func_2_tr_sel, func_2_tr_sel,
                              _, _, func_6_tr_sel_shift, func_6_tr_sel_shift)


M_btn_3[i] = Button:new_elem(M_pos_x, M_pos_y+20, 20, 20, true,
                              'M', 35, 35, 35, 255, 'M', 175, 50, 50, 255,
                              track_state_m[i], 'Calibri', 13, 'b', btn_text_r, btn_text_g, btn_text_b, btn_text_a,
                              M_pos_x, M_pos_y+20, 20, 20, 20, 20, 20, 255, ib,
                              func_1_m_off, func_2_m_on, _, _, func_5_m_off_shift, func_6_m_on_shift,
                              _, _, func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl, func_2_tr_sel, func_2_tr_sel,
                              _, _, func_6_tr_sel_shift, func_6_tr_sel_shift)

                              
M_btn_4[i] = Button:new_elem(M_pos_x, M_pos_y+40, 20, 20, true,
                              'S', 35, 35, 35, 255, 'S', 200, 150, 50, 255,
                              track_state_s[i], 'Calibri', 13, 'b', btn_text_r, btn_text_g, btn_text_b, btn_text_a,
                              M_pos_x, M_pos_y+40, 20, 20, 20, 20, 20, 255, ib,
                              func_1_s_off, func_2_s_on, _, _, func_5_s_off_shift, func_6_s_on_shift,
                              _, _, func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl, func_2_tr_sel, func_2_tr_sel,
                              _, _, func_6_tr_sel_shift, func_6_tr_sel_shift)

                              
M_btn_5[i] = Button:new_elem(M_pos_x, M_pos_y+60, 20, 20, true,
                              'R', 35, 35, 35, 255, 'R', 200, 70, 70, 255,
                              track_state_rec[i], 'Calibri', 13, 'b', btn_text_r, btn_text_g, btn_text_b, btn_text_a,
                              M_pos_x, M_pos_y+60, 20, 20, 20, 20, 20, 255, ib,
                              func_1_rec_off, func_2_rec_on, _, _, func_5_rec_off_shift, func_6_rec_on_shift,
                              _, _, func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl, func_2_tr_sel, func_2_tr_sel,
                              _, _, func_6_tr_sel_shift, func_6_tr_sel_shift)

                              
M_btn_6[i] = Button:new_elem(M_pos_x, M_pos_y+80, 20, 20, true,
                              'TCP', 20, 20, 20, 255, 'TCP', 80, 80, 80, 255,
                              track_state_tcp[i], 'Calibri', 8, 'b', btn_text_r, btn_text_g, btn_text_b, btn_text_a,
                              M_pos_x, M_pos_y+80, 20, 20, 20, 20, 20, 255, ib,
                              func_1_tcp_show_off, func_2_tcp_show_on, _, _, func_5_tcp_show_off_shift, func_6_tcp_show_on_shift,
                              _, _, func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl, func_2_tr_sel, func_2_tr_sel,
                              _, _, func_6_tr_sel_shift, func_6_tr_sel_shift)

                              
M_btn_7[i] = Button:new_elem(M_pos_x, M_pos_y+100, 20, 20, true,
                              'MCP', 20, 20, 20, 255, 'MCP', 80, 80, 80, 255,
                              track_state_mcp[i], 'Calibri', 8, 'b', btn_text_r, btn_text_g, btn_text_b, btn_text_a,
                              M_pos_x, M_pos_y+100, 20, 20, 20, 20, 20, 255, ib,
                              func_1_mcp_show_off, func_2_mcp_show_on, _, _, func_5_mcp_show_off_shift, func_6_mtcp_show_on_shift,
                              _, _, func_3_tr_unsel_ctrl, func_4_tr_sel_ctrl, func_2_tr_sel, func_2_tr_sel,
                              _, _, func_6_tr_sel_shift, func_6_tr_sel_shift)

                              
M_pos_x = M_pos_x + 20
end
end
-----------------------------------------------------------------------------

function Create()
  
  for key, btns        in pairs(Buttons_tab)  do btns:create() end
  
  for M_key, M_btns1   in pairs(M_btn_1)      do M_btns1:create() end
  for M_key, M_btns2   in pairs(M_btn_2)      do M_btns2:create() end
  for M_key, M_btns3   in pairs(M_btn_3)      do M_btns3:create() end
  for M_key, M_btns4   in pairs(M_btn_4)      do M_btns4:create() end
  for M_key, M_btns5   in pairs(M_btn_5)      do M_btns5:create() end
  for M_key, M_btns6   in pairs(M_btn_6)      do M_btns6:create() end
  for M_key, M_btns7   in pairs(M_btn_7)      do M_btns7:create() end
end

Create()


---------------------------------------------------------------------
  zoom = asm_math.cutFloatTo(math.min (gfx.w/window_w_start, gfx.h/window_h_start), 1) -- zoom number
  if zoom <= 1 then zoom = 1 end

  --if mouse_on_window then Msg('00') end
  --if gfx.getchar() > 0 then Msg(Char) hk_func_01() end -- Ctrl+Aa
  Char =  gfx.getchar(-1)
  --if Char > 0 then Msg(Char) end
  if Char == 1 then reaper.Main_OnCommand(40296, 0) end -- Ctrl+A
  if Char == 4 then reaper.Main_OnCommand(40297, 0) end -- Ctrl+D
  if Char == 32 then reaper.Main_OnCommand(40044, 0) end -- Space -- Transport: Play/stop
  if Char == 26 and not Shift then reaper.Main_OnCommand(40029, 0) end -- Ctrl+z -- Edit: Undo
  if Char == 26 and Shift then reaper.Main_OnCommand(40030, 0) end -- Ctrl+Shift+z -- Edit: Redo
  if Char == 109 then reaper.Main_OnCommand(6, 0) end -- M -- Track: Toggle mute for selected tracks
  if Char == 115 then reaper.Main_OnCommand(7, 0) end -- S -- Track: Toggle solo for selected tracks
  if Char == 6579564 then reaper.Main_OnCommand(40005, 0) end --Del -- Track: Remove tracks
  if Char == 8 then reaper.Main_OnCommand(40005, 0) end --Backspase -- Track: Remove tracks
  --if Char == 104 then reaper.Main_OnCommand(40005, 0) end -- H --
  if (Char ~= 27 and Char >= 0) then --exit function
     reaper.defer(MAIN) else gfx.quit()
   end
 
  gfx.update()
  reaper.atexit(MAIN)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
--reaper.Undo_BeginBlock()
--
gfx.init("ASM CP", window_w, window_h, 1)
--gfx.init(GUI.name, GUI.w, GUI.h, 0, x, y)
--gfx.dock(1)--, 0, 0, window_w, window_h)
MAIN()
--reaper.Undo_EndBlock(script_title, -1)

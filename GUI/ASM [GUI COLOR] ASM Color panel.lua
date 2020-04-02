--[[
 * ReaScript Name: ASM [GUI COLOR] ASM Color panel
 * Instructions:  LMB - Change track color. RMB - Change Item color. MMB - Change pelette color. LMB+Alt - Remove palette color. For reset pelette remove all colors.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.3
 * Description: Colorize track items and items
--]]

--[[
 * Changelog:
 * v1.0.0 (2020-04-01)
  + Initial release
* v1.0.1 (2020-04-02)
  + Save dock state
* v1.0.2 (2020-04-02)
  + Update functionality
* v1.0.3 (2020-04-02)
  + Update
--]]

local script_title='ASM [GUI COLOR] ASM Color panel'
local script_win_title = 'ASM Color Panel'

local proj = 0

----------------------------------------------------------------------
local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
local libraries_path = (script_path .. '../_libraries/'..'/')
local ini_path = (script_path ..'/')

dofile(libraries_path .."ASM [_LIBRARY] ".."asm"..".lua")
dofile(libraries_path .."ASM [_LIBRARY] ".."buttons"..".lua")
--dofile(libraries_path .."ASM [_LIBRARY] ".."io"..".lua")
dofile(libraries_path .. "ASM [_LIBRARY] ".."math"..".lua")
dofile(libraries_path .. "ASM [_LIBRARY] ".."other"..".lua")
--dofile(libraries_path .."ASM [_LIBRARY] ".."table"..".lua")

INI = dofile(libraries_path .."LIP"..".lua")

----------------------------------------------------------------------
local color_palette_ini = 'ASM [GUI COLOR] ASM Color panel -color_palette'
local settings_ini = 'ASM [GUI COLOR] ASM Color panel -settings'

local is_color_palette_ini = reaper.file_exists(ini_path .. color_palette_ini ..'.ini')
local is_settings_ini = reaper.file_exists(ini_path .. settings_ini ..'.ini')


----------------------------------------------------------------------
local button_size = 10

-------------------------- load colors palette ------------------------------
local colors_buttons = {}
local color_buttons_count = 0

function reset_colors()
  colors_buttons = {
    [1] =   {r = 100, g = 170,  b = 190},
    [2] =   {r = 55,  g = 120,  b = 180},
    [3] =   {r = 75,  g = 170,  b = 75},
    [4] =   {r = 235, g = 205,  b = 50},
    [5] =   {r = 210, g = 105,  b = 50},
    [6] =   {r = 200, g = 70,   b = 50},
    [7] =   {r = 175, g = 55,   b = 90},
    [8] =   {r = 120, g = 75,   b = 135},
    [9] =   {r = 95,  g = 60,   b = 165},
    [10] =  {r = 170, g = 215,  b = 55}
  }
end


--[[if colors_buttons ~= nil then
  for key, value in pairs(colors_buttons) do
    color_buttons_count = key
  end
end]]

-------------------------- load settings ------------------------------
local settings ={}

local window_x_start, window_y_start, window_h_start, window_w_start, dock, zoom

function reset_settings()
  dock = 1
  zoom = 4
  window_x_start = 0
  window_y_start = 0
  window_w_start = ((color_buttons_count+1)*button_size*zoom)
  window_h_start = button_size*zoom
end

----------------------------- save -----------------------------------------

function load_preference()
  
  if is_color_palette_ini then
    colors_buttons = INI.load(ini_path .. color_palette_ini ..'.ini')
    if colors_buttons[1] == nil then
      reset_colors()
    end
  else
    reset_colors()
  end
  
  if colors_buttons ~= nil then
    for key, value in pairs(colors_buttons) do
      color_buttons_count = key
    end
  end
  
  --
  
  if is_settings_ini then
    settings = INI.load(ini_path .. settings_ini ..'.ini')
    
    if settings.settings ~= nil then
      dock = settings.settings.dock
      zoom = settings.settings.zoom
      window_x_start = settings.settings.window_x_start
      window_y_start = settings.settings.window_y_start
      window_w_start = settings.settings.window_w_start
      window_h_start = settings.settings.window_h_start
    else
      reset_settings()
    end
    
  else
    reset_settings()
  end
  
  --[[local x_win_position_state = reaper.HasExtState(script_win_title, "x_win_position") 
  local y_win_position_state = reaper.HasExtState(script_win_title, "y_win_position")
  if x_win_position_state == true and y_win_position_state == true then
     x_win_position = tonumber(reaper.GetExtState(script_win_title, "x_win_position"))
     y_win_position = tonumber(reaper.GetExtState(script_win_title, "y_win_position"))
  end
  
  local win_width_state = reaper.HasExtState(script_win_title, "win_width") 
  local win_height_state = reaper.HasExtState(script_win_title, "win_height")
  if win_width_state == true and win_height_state == true then
     win_width = tonumber(reaper.GetExtState(script_win_title, "win_width"))
     win_height = tonumber(reaper.GetExtState(script_win_title, "win_height"))
  end

  local dock_state = reaper.HasExtState(script_win_title, "dock")
  if dock_state == true then
    dock = tonumber(reaper.GetExtState(script_win_title, "dock"))
  end]]
    
end
load_preference()
     --[[ Msg(dock)
      Msg(zoom)
      Msg(window_x_start)
      Msg(window_y_start)
      Msg(window_w_start)
      Msg(window_h_start)]]--

function save_preference()

  local dock, window_x_get_in_closed, window_y_get_in_closed, window_w_get_in_closed, window_h_get_in_closed = gfx.dock(-1, 0, 0, 0, 0)
  
  settings = {
    ['settings'] = {
      ['dock'] = dock,
      ['zoom'] = zoom,
      ['window_x_start'] = window_x_get_in_closed,
      ['window_y_start'] = window_y_get_in_closed,
      ['window_w_start'] = window_w_get_in_closed,
      ['window_h_start'] = window_h_get_in_closed
    }
  }

 
  INI.save((ini_path .. settings_ini ..'.ini'), settings)

  INI.save((ini_path .. color_palette_ini ..'.ini'), colors_buttons)
 --[[ Msg('saved')
  Msg(dock_get_get_in_closed)
  Msg(zoom)
  Msg(window_x_get_in_closed)
  Msg(window_y_get_in_closed)
  Msg(window_w_get_in_closed)
  Msg(window_h_get_in_closed)]]--
  
  --[[local _boolean, window_HWND, win_width, win_height = asm.getWindowState(script_win_title)
  reaper.SetExtState(script_win_title, "win_width", tostring(win_width), 1)
  reaper.SetExtState(script_win_title, "win_height", tostring(win_height), 1)
  
  local _, x_win_position, y_win_position, _, _ = gfx.dock(-1, 0, 0, 0, 0)
  reaper.SetExtState(script_win_title, "x_win_position", tostring(x_win_position), 1)
  reaper.SetExtState(script_win_title, "y_win_position", tostring(y_win_position), 1)

  --reaper.DeleteExtState(script_win_title, "win_width", 1)
  --reaper.DeleteExtState(script_win_title, "win_height", 1)
  --reaper.DeleteExtState(script_win_title, "x_win_position", 1)
  --reaper.DeleteExtState(script_win_title, "y_win_position", 1)

  local dock_state, x_pos, y_pos, _, _ = gfx.dock(-1, 0, 0, 0, 0)
  reaper.SetExtState(script_win_title, "dock", tostring(dock_state), 1)]]
end

----------------------------------------------------------------------



















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
--local window_w_start
--local window_h_start
--local _boolean, window_HWND, window_width, window_height = asm.getWindowState(script_win_title)
      
--[[if window_w_start > window_h_start then
  window_h_start = ((color_buttons_count+1)*button_size)
  window_w_start = button_size
else
  window_h_start = button_size
  window_w_start = ((color_buttons_count+1)*button_size)
end]]

--local window_w = window_w_start*zoom
--local window_h = window_h_start*zoom
------------------------------------------------------------------
function Button:LMB() 
  if mouse_on_button then
    if LMB and Alt then -- LMB+Alt
      reaper.Undo_BeginBlock()
        if func_07_LMB_alt or func_08_LMB_alt then
          if state_boolean and button_up then
            func_07_LMB_alt(param_01)
          elseif button_up then
            func_08_LMB_alt(param_01)
          end
        end
     button_up = false
     elseif LMB  then --LMB
    
      reaper.Undo_BeginBlock()
        if func_01_LMB or func_02_LMB then
          if state_boolean and button_up then
            --func_01_LMB(param_01)
            func_01_LMB(r_original_btn_color, g_original_btn_color, b_original_btn_color)
          elseif button_up then
            --func_02_LMB(param_01)
            func_02_LMB(r_original_btn_color, g_original_btn_color, b_original_btn_color)
          end
        end
        button_up = false
    end
  end
  reaper.Undo_EndBlock(script_title, -1)
end
------------------------------------------------------------------
function Button:RMB()
  if mouse_on_button then
    if RMB  then --RMB
      reaper.Undo_BeginBlock()
        if func_01_RMB or func_01_RMB then
          if state_boolean and button_up then
            --func_01_LMB(param_01)
            func_01_RMB(r_original_btn_color, g_original_btn_color, b_original_btn_color)
          elseif button_up then
            --func_02_LMB(param_01)
            func_01_RMB(r_original_btn_color, g_original_btn_color, b_original_btn_color)
          end
        end
        button_up = false
    end
  end
  reaper.Undo_EndBlock(script_title, -1)
end
------------------------------------------------------------------
function Button:MMB()
  if mouse_on_button then
    if MMB then
      reaper.Undo_BeginBlock()
      if func_01_MMB or func_02_MMB then
              if state_boolean and button_up then
                --func_01_LMB(param_01)
                func_01_MMB(param_01)
              elseif button_up then
                --func_02_LMB(param_01)
                func_02_MMB(param_01)
              end
      end
      button_up = false
    end
  end
  reaper.Undo_EndBlock(script_title, -1)
end
















function draw_or_update_buttons()
  local Btn_pos_x  = 0
  local Btn_pos_y = 0
  local add_btn_pos_x = 0
  local add_btn_pos_y = 0
  local Buttons_table = {}
  local stroke = 1
  if colors_buttons then
      for tab_i, track_i in pairs(colors_buttons) do
        i = tab_i
        btn_numb = tab_i
        r = track_i["r"]
        g = track_i["g"]
        b = track_i["b"]
  
            Buttons_table[i] = Button:new_elem(Btn_pos_x, Btn_pos_y, button_size, button_size, true,
  
                                      btn_numb, _, _, _, _,
                                      
                                      _, zoom, 50, 30,
  
                                      r, g, b, 255,
                                      stroke, 30, 30, 30, 255,
                                      255, 255, 255, 255,
                                      100, 100, 100, 255,
                                      _text,'Calibri', 24, 'b',
                                      255, 255, 255, 255,
                                      
                                      80, 80, 80, 255,
                                      stroke, 255, 255, 255, 255,
                                      55, 255, 255, 255,
                                      100, 100, 100, 255,
                                      _text,'Calibri', 24, 'b',
                                      255, 255, 255, 255,
                                      func_01_LMB_color_for_sel, func_01_LMB_color_for_sel, _04, _05, _05, _06,
                                      func_01_LMB_ALT_remove_button, func_01_LMB_ALT_remove_button, _09, _10, _11, _12, _13, _14, _15, _16,
                                      
                                      func_01_RMB_color_for_sel_ITEMS, func_01_RMB_color_for_sel_ITEMS, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32,
                                      
                                      func_01_MMB_change_button_color, func_01_MMB_change_button_color, _35, _36, _37, _38, _39, _40, _41, _42, _43, _44, _45, _46, _47, _48)
  
        
       
        
        _boolean, window_HWND, window_w_frame, window_h_frame = asm.getWindowState(script_win_title)
        
        if window_w_frame > window_h_frame then
          Btn_pos_x = (Btn_pos_x + button_size)
          add_btn_pos_x = Btn_pos_x
        else
          Btn_pos_y = (Btn_pos_y + button_size)
          add_btn_pos_y = Btn_pos_y
        end
        
      end
  end
   Button_add = Button:new_elem(add_btn_pos_x, add_btn_pos_y, button_size, button_size, true,
   
                                _, _, _, _, _,
                                
                                _, zoom, 50, 30,

                                30, 30, 30, 255,
                                stroke, 30, 30, 30, 255,
                                30, 30, 30, 255,
                                0, 0, 0, 255,
                                "+", 'Calibri', 10, 'b',
                                230, 230, 230, 255,
                                
                                30, 30, 30, 255,
                                stroke, 30, 30, 30, 255,
                                0, 0, 0, 255,
                                0, 0, 0, 255,
                                "+",'Calibri', 10, 'b',
                                230, 230, 230, 255,
                                
                                func_01_LMB_add_color, func_01_LMB_add_color, _03, _04, _05, _06, _07, _08, _09, _10, _11, _12, _13, _14, _15, _16,
                                _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32,
                                _33, _34, _35, _36, _37, _38, _39, _40, _41, _42, _43, _44, _45, _46, _47, _48)
                                --_01, _02, _03, _04, _05, _06, _07, _08, _09, _10, _11, _12, _13, _14, _15, _16,
                                --_17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32,
                                --_33, _34, _35, _36, _37, _38, _39, _40, _41, _42, _43, _44, _45, _46, _47, _48)
                                    

    createButton(Buttons_table)
    createButton(Button_add)                          
end



























----------------------------------------------------------------------
  ----------------------- FUNCTION FOR BUTTONS -------------------------
  ----------------------------------------------------------------------
  count_tracks_all =  reaper.CountTracks(0)
  if not count_tracks_all then cheker() end --Cheker
  -------------------------------------  
  -------------------------------------
  ------------------01 select-----------------
  
  
  
  
  
  
  
  
  
  function func_01_MMB_change_button_color(btn_numb) --MMB
    save_preference()
    apply, new_button_color = reaper.GR_SelectColor()
        --Msg (new_track_color)
    if apply == 1 then
      r, g, b = reaper.ColorFromNative(new_button_color)
      colors_buttons_one_color = {}
      colors_buttons_one_color["r"] = r
      colors_buttons_one_color["g"] = g
      colors_buttons_one_color["b"] = b
      colors_buttons[btn_numb] = colors_buttons_one_color
      end
  end
  
  
  
  function func_01_LMB_color_for_sel(r, g, b) --LMB
    
    new_track_color = reaper.ColorToNative(r, g, b)

      count_track_all =  reaper.CountTracks(0)
      for i = 0, count_track_all - 1 do

        track = reaper.GetTrack(0, i)
        track_isSel = reaper.IsTrackSelected(track)

        if track_isSel then
          reaper.SetTrackColor(track, new_track_color)
        end
      end

  end  
  
  
  
  
  function func_01_RMB_color_for_sel_ITEMS(r, g, b) --LMB
  
    
    local new_item_color = reaper.ColorToNative(r, g, b)
    
  
    local count_selected_items = reaper.CountSelectedMediaItems(0)
--    if Count_Selected_Items == 0 then no_undo() return end
      
    for i = 0 , count_selected_items-1 do
        local selected_item = reaper.GetSelectedMediaItem(0, i)
        color = reaper.GetMediaItemInfo_Value(selected_item,"I_CUSTOMCOLOR")
        reaper.SetMediaItemInfo_Value(selected_item,"I_CUSTOMCOLOR", new_item_color|0x1000000)
        reaper.UpdateItemInProject(selected_item)
    end
     

  end
  
  
  
  function func_01_LMB_add_color() --LMB
    save_preference()
    local color_buttons_count = 0
    if colors_buttons ~= nil then
      for key, value in pairs(colors_buttons) do
        color_buttons_count = key
      end
    end

    apply, add_button_color = reaper.GR_SelectColor()
  
    if apply == 1 then
      r, g, b = reaper.ColorFromNative(add_button_color)
      colors_buttons_one_color = {}
      colors_buttons_one_color["r"] = r
      colors_buttons_one_color["g"] = g
      colors_buttons_one_color["b"] = b
      colors_buttons[color_buttons_count+1] = colors_buttons_one_color
    end
  
  end
  
  function func_01_LMB_ALT_remove_button(pos)
    save_preference()
    colors_buttons_temp = {}
    i = 1
    if colors_buttons ~= nil then
      for key, value in pairs(colors_buttons) do
        if key ~= pos then
          colors_buttons_temp[i] = value
          i = i + 1
        end
      end
    end
    colors_buttons = colors_buttons_temp
    --table.remove(colors_buttons[pos-1])
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
  --------------------------------------------- 
  --------------------------------------------- 
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
-------------------------- MAIN FUNCTION -----------------------------
----------------------------------------------------------------------
local exit_in = 1
local horizontal = true
local mouseout = true
function MAIN()
  local char = gfx.getchar()
  if char == 27 or char < 0 and exit_in == 1 then
    save_preference()
    --remove_settings()
    exit_in = 0
    return gfx.quit(), reaper.atexit(MAIN)
  end


 
  --[[if char == 27 then
    save_preference()
    reaper.atexit()
    gfx.quit()
  end     
                            -- escape
  if char ~= -1 then
  
  reaper.defer(MAIN)
  
  else
    --INI_set()
    save_preference()
    reaper.atexit()
    gfx.quit()
  end -- stop on close ]]

  --window_w = window_w_start*zoom
  --window_h = window_h_start*zoom
  _boolean, window_HWND, window_w_frame, window_h_frame, window_x_frame, window_y_frame = asm.getWindowState(script_win_title)
      --window_width = 100
      --window_height = 100
  
  if window_w_frame > window_h_frame then
    window_w_start = ((color_buttons_count+1)*button_size)--*zoom
    window_h_start = button_size--*zoom
    --if horizontal then
    --  horizontal = false
    --  local _boolean, window_HWND, win_width, win_height = asm.getWindowState(script_win_title)
    --  reaper.JS_Window_Resize(window_HWND, window_h_start, window_w_start)
    --end
  else
    window_w_start = button_size--*zoom
    window_h_start = ((color_buttons_count+1)*button_size)--*zoom
    --if not horizontal then
    --  horizontal = true
    --  local _boolean, window_HWND, win_width, win_height = asm.getWindowState(script_win_title)
    --  reaper.JS_Window_Resize(window_HWND, window_h_start, window_w_start)
    --end
  end
  zoom = asm_math.cutFloatTo(math.min (gfx.w/window_w_start, gfx.h/window_h_start), 1) -- zoom number
  if zoom <= 1 then zoom = 1 end
  --Msg(zoom)
    
  local mouse_on_window =
      (gfx.mouse_x > 0 and gfx.mouse_x < window_w_frame) and
      (gfx.mouse_y > 0 and gfx.mouse_y < window_h_frame)
  


  ---------------------------------------------------------------------

  --if mouse_on_window then Msg('00') end
  --if gfx.getchar() > 0 then Msg(Char) hk_func_01() end -- Ctrl+Aa
  --Char =  gfx.getchar(-1)
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
  --[[if (Char ~= 27 and Char >= 0) then --exit function
     reaper.defer(MAIN)
  else
     save_preference()
     gfx.quit()
  end]]--
  --gfx.mode = 2
  
   
   
   -- if mouse_on_window then
      asm.setColor(30, 30, 30, 255)
      gfx.rect(0, 0, window_w_frame, window_h_frame, true)
     draw_or_update_buttons()
      --gfx.update()
      mouseout = true
    --[[elseif not mouse_on_window and mouseout then

            draw_or_update_buttons()
            gfx.dest = 800
            --gfx.setimgdim(800, 0, 0)  
            gfx.setimgdim(800, window_w, window_h) 
            asm.setColor(30, 30, 30, 255)
            gfx.rect(0, 0, window_w, window_h, true)
            draw_or_update_buttons()
            gfx.dest=-1
            gfx.blit(800, 1, 0,
                      0, 0, window_w, window_h,
                      0, 0, window_w, window_h, 0, 0)
                    mouseout = true]]
            
            
            --gfx.blit(800, 1, 0, bt_img_src_x_pos, bt_img_src_y, bt_img_src_w, bt_img_src_h, x, y, w, h)
    --end
    
    
    
    
    
    
    
    
    
    
    
    reaper.defer(MAIN)
    --[[if gfx.getchar() >= 0 then reaper.defer(MAIN)
      else 
        save_preference()
      end]]
end
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------


--reaper.Undo_BeginBlock()
--
gfx.init(script_win_title, window_w_start, window_h_start, dock, window_x_start, window_y_start)
--gfx.init(GUI.name, GUI.w, GUI.h, 0, x, y)
--gfx.dock(1)--, 0, 0, window_w, window_h)
MAIN()
--reaper.Undo_EndBlock(script_title, -1)
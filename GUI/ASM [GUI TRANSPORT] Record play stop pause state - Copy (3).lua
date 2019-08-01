--[[
 * ReaScript Name: ASM [GUI TRANSPORT] Record play stop pause state
 * Instructions:  Open script and read help (F1)
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: Record play stop pause state
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-02-26)
  + Initial release
 * v1.0.1 (2019-03-16)
  + Add repeat state (optional)
  + Help (F1)
 * v1.0.5 (2019-03-16)
  + Add menu (F1 for help)
    Menu items: "Repeat" (on/off), "Show indication" (of repeat), "Help", "Close"
 * v1.0.6 (2019-03-16)
  # Update code
 * v1.1.0 (2019-03-18)
  + Add settings items in menu
  # Fix menu position
--]]

script_title = "ASM [GUI TRANSPORT] Record play stop pause state"

-- !! ------------------------------------------------------------------ !! --
-- !! ------------------------ DEFAULT SETTINGS ------------------------ !! --
-- !! ------------------------------------------------------------------ !! --
local zoom = 1        --zoom start index
-- use "ASM [GUI DEVELOPER] Show gfx.getchar() number.lua
local stop_txt, pause_txt, play_txt, rec_txt
  
local R_stop_bg,    G_stop_bg,    B_stop_bg
local R_pause_bg,   G_pause_bg,   B_pause_bg
local R_play_bg,    G_play_bg,    B_play_bg
local R_rec_bg,     G_rec_bg,     B_rec_bg
  
local R_stop_txt,   G_stop_txt,   B_stop_txt
local R_pause_txt,  G_pause_txt,  B_pause_txt
local R_play_txt,   G_play_txt,   B_play_txt
local R_rec_txt,    G_rec_txt,    B_rec_txt
  
local repeat_unique_color_state
local repeat_on_color_state
local repeat_off_color_state
local R_repeat_on, G_repeat_on, B_repeat_on
local R_repeat_off, G_repeat_off, B_repeat_off
 
local user_record_key_number
local user_repeat_key_number
local docker_start

local repeat_indicate_state
----------------------------------------------------------------------
------------------------------USER HELP-------------------------------
----------------------------------------------------------------------

help_msg =
'MMB\t\t- Menu'..'\n'..
'\n'..
'RMB\t\t- Record (Play)'..'\n'..
'\n'..
'LMB\t\t- Play (Stop)'..'\n'..
'LMB+Ctrl\t- Record (Play)'..'\n'..
'LMB+Shift\t- Pause (Play)'..'\n'..
'\n'..
'Space\t\t- Play (Stop)'..'\n'..
'Space+Shift\t- Pause (Play)'..'\n'..
'\n'..
'Editable:'..'\n'..
'\n'..
'* (num keyboard)\t- Record (Play)'..'\n'..
'/ (num keyboard)\t- Repeat'..'\n'..
'\n'..
'You can change this keys in the scrip'..'\n'..
'just use "ASM [GUI DEVELOPER] Show gfx.getchar() number.lua" script'..'\n'..
'to get key number and insert to the value:'..'\n'..
'user_record_key_number\t- Record'..'\n'..
'user_repeat_key_number\t- Repeat'..'\n'..
'\n'..
'Also you can change custom colors'..'\n'..
'\n'..
'Feel free to open script and change USER SETTINGS'

----------------------------------------------------------------------
-------------------------------ASM data-------------------------------
----------------------------------------------------------------------
local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."asm"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."io"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."math"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."other"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."table"..".lua")

local settings_script_path = script_path .. "../_ini/"
local settings_file_path = script_path .. "../_ini/"..script_title..".ini" --settings file path
local settings_file --= io.open (fileSettingsPath, "a")
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
function check_numb_string(settings_file)
    --Msg(settings_file)
    stop_read = 0
    while stop_read == 0 do
      string = settings_file:read()
      string = string
      string_type_d = string.find(string, "%d") -- if number
      string_type_a = string.find(string, "%a") -- if chart
      string_type_comment = string.find(string, "%[")
      if string_type_comment ~= nil then
        string_line = nil
      elseif string_type_d ~= nil then
        string_line = tonumber(string)
        stop_read = 1
      elseif string_type_a ~= nil then
        string_line = tostring(string)
        stop_read = 1
      else
        string_line = nil
      end
    end
    Msg(string_line)
    return string_line
end
----------------------------------------------------------------------
function file_lines_count(settings_file_path)
  settings_file = io.open (settings_file_path, 'r')
  stop_read = 0
  lines_count = 0
  while stop_read == 0 do
    local string = settings_file:read() -- read file as
      if string == nil then
        stop_read = 1
      else
        lines_count = lines_count + 1
      end
  end
  io.close(settings_file)
  return lines_count
end
----------------------------------------------------------------------
function save_settings()

    settings_file = io.open (settings_file_path, 'w') -- open file for write
    
    data_to_settings_file = 
                            stop_txt..'\n'..pause_txt..'\n'..play_txt..'\n'..rec_txt..'\n'..
    
                            R_stop_bg..'\n'..    G_stop_bg..'\n'..    B_stop_bg..'\n'..
                            R_pause_bg..'\n'..   G_pause_bg..'\n'..   B_pause_bg..'\n'..
                            R_play_bg..'\n'..    G_play_bg..'\n'..    B_play_bg..'\n'..
                            R_rec_bg..'\n'..     G_rec_bg..'\n'..     B_rec_bg..'\n'..
    
                            R_stop_txt..'\n'..   G_stop_txt..'\n'..   B_stop_txt..'\n'..
                            R_pause_txt..'\n'..  G_pause_txt..'\n'..  B_pause_txt..'\n'..
                            R_play_txt..'\n'..   G_play_txt..'\n'..   B_play_txt..'\n'..
                            R_rec_txt..'\n'..    G_rec_txt..'\n'..    B_rec_txt..'\n'..
    
                            repeat_unique_color_state..'\n'..
                            repeat_on_color_state..'\n'..
                            repeat_off_color_state..'\n'..
                            R_repeat_on..'\n'..   G_repeat_on..'\n'..   B_repeat_on..'\n'..
                            R_repeat_off..'\n'..  G_repeat_off..'\n'..  B_repeat_off..'\n'..
    
                            user_record_key_number..'\n'..
                            user_repeat_key_number..'\n'..
                            
                            docker_start..'\n'..
                            
                            repeat_indicate_state
                            
    settings_file:write(data_to_settings_file..'\n')
    io.close(settings_file) -- close file
end
----------------------------------------------------------------------
function remove_settings()
  os.remove(settings_file_path)
end

local file_is_on_start
local settings_file_check = asm_io.file_exists(settings_file_path)
if settings_file_check == false then
  file_is_on_start = 0
  
  stop_txt, pause_txt, play_txt, rec_txt = 'STOP', 'PAUSE', 'PLAY', 'RECORD' --texts
  
  R_stop_bg,    G_stop_bg,    B_stop_bg   =  30,  30,  30 --Stop color BG (RGB)
  R_pause_bg,   G_pause_bg,   B_pause_bg  =  30,  30,  30 --Pause color BG (RGB)
  R_play_bg,    G_play_bg,    B_play_bg   =  30,  30,  30 --Play color BG (RGB)
  R_rec_bg,     G_rec_bg,     B_rec_bg    = 200,  70,  70 --Rec color BG (RGB)
  
  R_stop_txt,   G_stop_txt,   B_stop_txt  = 100, 100, 100 --Stop color TXT (RGB)
  R_pause_txt,  G_pause_txt,  B_pause_txt = 100, 170, 190 --Pause color TXT (RGB)
  R_play_txt,   G_play_txt,   B_play_txt  =  75, 170,  75 --Play color TXT (RGB)
  R_rec_txt,    G_rec_txt,    B_rec_txt   =  30,  30,  30 --Rec color TXT (RGB)
  
  repeat_unique_color_state = 0 -- enable repeat uniqur color (below)
  repeat_on_color_state = 1     -- enable repeat ON uniqur color
  repeat_off_color_state = 0    -- enable repeat OFF uniqur color
  R_repeat_on, G_repeat_on, B_repeat_on    = 100, 170, 190 -- Repeat color ON
  R_repeat_off, G_repeat_off, B_repeat_off =  35,  35,  35 -- Repeat color OFF
  
  user_record_key_number = 42 -- * (num keyboard)
  user_repeat_key_number = 47 -- / (num keyboard)
  docker_start = 1 --start in docker
  
  repeat_indicate_state = 1    -- eneble repeat indication]]
  
  save_settings()
else
  file_is_on_start = 1
  --count_lines = file_lines_count(settings_file_path)
  settings_file = io.open (settings_file_path, 'r')    -- eneble repeat indication

    stop_txt, pause_txt, play_txt, rec_txt  =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --texts
    R_stop_bg,    G_stop_bg,    B_stop_bg   =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Stop color BG (RGB)
    
    R_pause_bg,   G_pause_bg,   B_pause_bg  =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Pause color BG (RGB)
    R_play_bg,    G_play_bg,    B_play_bg   =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Play color BG (RGB)
    R_rec_bg,     G_rec_bg,     B_rec_bg    =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Rec color BG (RGB)
    
    R_stop_txt,   G_stop_txt,   B_stop_txt  =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Stop color TXT (RGB)
    R_pause_txt,  G_pause_txt,  B_pause_txt =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Pause color TXT (RGB)
    R_play_txt,   G_play_txt,   B_play_txt  =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Play color TXT (RGB)
    R_rec_txt,    G_rec_txt,    B_rec_txt   =    check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) --Rec color TXT (RGB)
    
    repeat_unique_color_state =  check_numb_string(settings_file) -- enable repeat uniqur color (below)
    repeat_on_color_state =  check_numb_string(settings_file)     -- enable repeat ON uniqur color
    repeat_off_color_state =  check_numb_string(settings_file)    -- enable repeat OFF uniqur color
    R_repeat_on, G_repeat_on, B_repeat_on    =   check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) -- Repeat color ON
    R_repeat_off, G_repeat_off, B_repeat_off =   check_numb_string(settings_file),  check_numb_string(settings_file),  check_numb_string(settings_file) -- Repeat color OFF
    
    user_record_key_number =  check_numb_string(settings_file) -- * (num keyboard)
    user_repeat_key_number =  check_numb_string(settings_file) -- / (num keyboard)
    docker_start =  check_numb_string(settings_file) --start in docker
    
    repeat_indicate_state =   check_numb_string(settings_file)
     
  io.close(settings_file) -- close file
end
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

function DEL_testF()
  settings_file = io.open (settings_file_path, 'r') -- open file for read
  --while repeat_indicate_state == nil do
  --Msg(repeat_indicate_state)
  --repeat_indicate_state = settings_file:read()
  --if settings_file ~= nil then -- IF FILE IS ON DISK
    local stop_read = 0
    local i = 1
    while stop_read == 0 do
      local fileTXT = settings_file:read() -- read file as
      if fileTXT == nil then
        stop_read = 1
      else
        --fileTXT = settings_file:read() -- read file as
        sss = check_numb_string(fileTXT)
        Msg(sss)
      end
    
    end
  --end

  --settings_file = io.open (settings_file_path, 'a') -- open file for write with add
  --settings_file:write('11x00cv\n')

  io.close(settings_file) -- close file
end
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
count_tracks_all =  reaper.CountTracks(0)
if not count_tracks_all then goto END end --Cheker
count_tracks_selected = reaper.CountSelectedTracks(0)
if not count_tracks_selected then goto END end --Cheker
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local window_w_start = 200
local window_h_start = 100
local window_w = window_w_start*zoom
local window_h = window_h_start*zoom
local shine = 20

--gfx.mouse_wheel = 0
--local width_slider = 0


local CENTER_H = 1*zoom
local CENTER_V = 4*zoom


local mouse_Lclick = false
local mouse_Rclick = false
----------------------------------------------------------------------
-------------------------------MENU-----------------------------------
----------------------------------------------------------------------
local menu_text = ''
local menu_init = {
  it_1_1   = 'Repeat',
  it_2_2   = 'Show indication',
  it_3_s   = '||>Edit text',
  it_4_3   = 'STOP',
  it_5_4   = 'PAUSE',
  it_6_5   = 'PLAY',
  it_7_6   = '<RECORD',
  it_8_s   = '>Edit text color',
  it_9_7   = 'STOP',
  it_10_9  = 'PAUSE',
  it_11_10 = 'PLAY',
  it_12_11 = '<RECORD',
  it_13_s  = '>Edit background color',
  it_14_12 = 'STOP',
  it_15_13 = 'PAUSE',
  it_16_14 = 'PLAY',
  it_17_15 = '<RECORD',
  it_18_16 = '||Show settings file',
  it_19_17 = '||Help',
  it_20_18 = '||Close'
}

local m = {}               --{ title='', state='', mute='', list='', endlist='', seperate='' },
  m[1]                  = { title='Repeat'}
  Show_indication         = { title='Show indication'}
  Edit_text               = { title='Edit text', list=1, seperate=3}
  STOP_t                  = { title='STOP'}
  PAUSE_t                 = { title='PAUSE'}
  PLAY_t                  = { title='PLAY'}
  RECORD_t                = { title='RECORD', endlist=1}
  Edit_text_color         = { title='Edit text color', list=1}
  STOP_tc                 = { title='STOP'}
  PAUSE_tc                = { title='PAUSE'}
  PLAY_tc                 = { title='PLAY'}
  RECORD_tc               = { title='RECORD', endlist=1}
  Edit_background_color   = { title='Edit background color', list=1}
  STOP_bc                 = { title='STOP'}
  PAUSE_bc                = { title='PAUSE'}
  PLAY_bc                 = { title='PLAY'}
  RECORD_bc               = { title='RECORD', endlist=1}
  Show_settings_file      = { title='Show settings file', seperate=2}
  Help                    = { title='Help', seperate=2 }
  Close                   = { title='Close', seperate=2 }

  Msg(m[1])

for k, v in pairs(m) do
  Msg(m[v])
end

local menu = asm_table.copy(menu_init)

function menu_setF()
  menu_text =      menu.it_1_1..    '|'..menu.it_2_2..    '|'..menu.it_3_s..    '|'..menu.it_4_3..    '|'..menu.it_5_4..
              '|'..menu.it_6_5..    '|'..menu.it_7_6..    '|'..menu.it_8_s..    '|'..menu.it_9_7..    '|'..menu.it_10_9..
              '|'..menu.it_11_10..  '|'..menu.it_12_11..  '|'..menu.it_13_s..   '|'..menu.it_14_12..  '|'..menu.it_15_13..
              '|'..menu.it_16_14..  '|'..menu.it_17_15..  '|'..menu.it_18_16..  '|'..menu.it_19_17..  '|'..menu.it_20_18
              
  return menu_text
end
local menu_02_state = 1
  
----------------------------------------------------------------------
----------------------------------------------------------------------
function mouseOn(R_mC, G_mC, B_mC, A_mC)--color
  local border_l = 0
  local border_t = 0
  local border_r = window_w
  local border_b = window_h
  local mouse_on_window =
  (gfx.mouse_x > border_l and gfx.mouse_x < border_r) and
  (gfx.mouse_y > border_t and gfx.mouse_y < border_b)
  if mouse_on_window then
    if mouse_click then
      asm.setColor(R_mC-shine, G_mC-shine, B_mC-shine, A_mC)
    else
      asm.setColor(R_mC+shine, G_mC+shine, B_mC+shine, A_mC)
    end
  end
  return R_mC, G_mC, B_mC, A_mC
end
----------------------------------------------------------------------
function rec_state()
  local status = function()
    if (reaper.GetPlayState() & 2) == 2 then
      return pause_txt
    elseif (reaper.GetPlayState() & 4) == 4 then
      return rec_txt
    elseif (reaper.GetPlayState() & 1) == 1 then
      return play_txt
    else
      return stop_txt
    end
  end
  return string.format(status())
end
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
function help_menuF()
  reaper.ShowMessageBox(help_msg, 'HELP: '..script_title, 0)
end

function open_settings_file_menuF()
  reaper.CF_ShellExecute(settings_script_path)
end
-------------------------------------
function text_STOP_menuF()
  is_text, get_text = reaper.GetUserInputs('Text STOP Background', 1, '"STOP" text:', 'STOP')
  if is_text then
    stop_txt = get_text
  end
end
function text_PAUSE_menuF()
  is_text, get_text = reaper.GetUserInputs('Text PAUSE Background', 1, '"PAUSE" text:', 'PAUSE')
  if is_text then
    pause_txt = get_text
  end
end
function text_PLAY_menuF()
  is_text, get_text = reaper.GetUserInputs('Text PLAY Background', 1, '"PLAY" text:', 'PLAY')
  if is_text then
    play_txt = get_text
  end
end
function text_REC_menuF()
  is_text, get_text = reaper.GetUserInputs('Text RECORD Background', 1, '"RECORD" text:', 'RECORD')
  if is_text then
    rec_txt = get_text
  end
end
-------------------------------------
function      color_STOP_txt_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_stop_txt, G_stop_txt, B_stop_txt = reaper.ColorFromNative(get_color)
  end
end
function      color_PAUSE_txt_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_pause_txt, G_pause_txt, B_pause_txt = reaper.ColorFromNative(get_color)
  end
end
function      color_PLAY_txt_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_play_txt, G_play_txt, B_play_txt = reaper.ColorFromNative(get_color)
  end
end
function      color_REC_txt_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_rec_txt, G_rec_txt, B_rec_txt = reaper.ColorFromNative(get_color)
  end
end
-------------------------------------
function color_STOP_bg_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_stop_bg, G_stop_bg, B_stop_bg = reaper.ColorFromNative(get_color)
  end
end
function color_PAUSE_bg_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_pause_bg, G_pause_bg, B_pause_bg = reaper.ColorFromNative(get_color)
  end
end
function color_PLAY_bg_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_play_bg, G_play_bg, B_play_bg = reaper.ColorFromNative(get_color)
  end
end
function color_REC_bg_menuF()
  is_color, get_color = reaper.GR_SelectColor()
  if is_color then
    R_rec_bg, G_rec_bg, B_rec_bg = reaper.ColorFromNative(get_color)
  end
end
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local exit_in = 1
function MAIN()
--Msg('repeat_indicate_state.. '..repeat_indicate_state)

  LMB   = (gfx.mouse_cap & 1) ~= 0
  RMB   = (gfx.mouse_cap & 2) ~= 0
  Ctrl  = (gfx.mouse_cap & 4) ~= 0
  Shift = (gfx.mouse_cap & 8) ~= 0
  Alt   = (gfx.mouse_cap & 16) ~= 0
  Win   = (gfx.mouse_cap & 32) ~= 0
  MMB   = (gfx.mouse_cap & 64) ~= 0
  mouse_x, mouse_y = asm.getMouseXY()

local char = gfx.getchar()
  if char == 27 or char < 0 and exit_in == 1 then
  Msg('EXIT')
    save_settings()
    --remove_settings()
    exit_in = 0
    return gfx.quit(), reaper.atexit(MAIN)
  end
  if char == 26161  then
    helpF() --show help
  end
  window_w = gfx.w
  window_h = gfx.h
  zoom = asm_math.cutFloatTo(math.min (window_w/window_w_start, window_h/window_h_start), 1) -- zoom number

  
  
  local border_l = 0
  local border_t = 0
  local border_r = window_w
  local border_b = window_h
  --local margin = math.min(gfx.w, gfx.h) / 10
  local margin = 0
  local margin_repeat = 0
  local right = gfx.w - margin
  local width = right - margin
  local bottom = gfx.h - margin
  local height = bottom - margin
  
  local mouse_on_window =
  (gfx.mouse_x > border_l and gfx.mouse_x < border_r) and
  (gfx.mouse_y > border_t and gfx.mouse_y < border_b)
  

---------------------------------Munu---------------------------------
----------------------------------------------------------------------
  if (reaper.GetSetRepeat(-1) & 1) == 1 then
    menu_01_state = 1 else menu_01_state = 0
  end
  
  if menu_01_state == 1 then --and menu_02_state == 1 then
    menu.it_1_1 = '!'..menu_init.it_1_1
    --menu.it_2_2 = '!'..menu_init.it_2_2
    --menu_text = "!Repeat|!Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
  elseif menu_01_state == 0 then --and menu_02_state == 1 then
    menu.it_1_1 = menu_init.it_1_1
    --menu.it_2_2 = '!'..menu_init.it_2_2
    --menu_text = "Repeat|!Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
  end
  
  
  if repeat_indicate_state == 1 then
    menu_02_state = 1 else menu_02_state = 0
  end
  
  if menu_02_state == 1 then
    menu.it_2_2 = '!'..menu_init.it_2_2
    
    --menu_text = "!Repeat|Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
  elseif menu_02_state == 0 then
    --menu.it_1_1 = menu_init.it_1_1
    menu.it_2_2 = menu_init.it_2_2
    --menu_text = "Repeat|Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
  end
  
  if MMB then
  --gfx.showmenu("first item, followed by separator||!second item, checked|>third item which spawns a submenu|#first item in submenu, grayed out|<second and last item in submenu|fourth item in top menu")
    asm.setXY(mouse_x, mouse_y)
    menu_text = menu_setF()
    menu_set = gfx.showmenu(menu_text)
    
    if menu_set == 1 then
    reaper.GetSetRepeat(2)
      --[[if menu_01_state == 1 and menu_02_state == 1 then
        menu_text = "Repeat|!Show indication|||Help|||Close"
        reaper.GetSetRepeat(2)
      elseif menu_01_state == 0 and menu_02_state == 1 then
        menu_text = "!Repeat|!Show indication|||Help|||Close"
        reaper.GetSetRepeat(2)
      elseif menu_01_state == 1 and menu_02_state == 0 then
        menu_text = "Repeat|Show indication|||Help|||Close"
        reaper.GetSetRepeat(2)
      elseif menu_01_state == 0 and menu_02_state == 0 then
        menu_text = "!Repeat|Show indication|||Help|||Close"
        reaper.GetSetRepeat(2)
      end]]
    
    elseif menu_set == 2 then
      if menu_01_state == 1 and menu_02_state == 1 then
        menu.it_1_1 = '!'..menu_init.it_1_1
        menu.it_2_2 = menu_init.it_2_2
        --menu_text = "!Repeat|Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
        repeat_indicate_state = 0
        menu_02_state = 0
      elseif menu_01_state == 0 and menu_02_state == 1 then
        menu.it_1_1 = menu_init.it_1_1
        menu.it_2_2 = menu_init.it_2_2
        --menu_text = "Repeat|Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
        repeat_indicate_state = 0
        menu_02_state = 0
      elseif menu_01_state == 1 and menu_02_state == 0 then
        menu.it_1_1 = '!'..menu_init.it_1_1
        menu.it_2_2 = '!'..menu_init.it_2_2
        --menu_text = "!Repeat|!Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
        repeat_indicate_state = 1
        menu_02_state = 1
      elseif menu_01_state == 0 and menu_02_state == 0 then
        menu.it_1_1 = menu_init.it_1_1
        menu.it_2_2 = '!'..menu_init.it_2_2
        --menu_text = "Repeat|!Show indication|||>Edit text|STOP|PAUSE|PLAY|<RECORD|||Color STOP Background|||Show settings file|||Help|||Close"
        repeat_indicate_state = 1
        menu_02_state = 1
      end
    elseif menu_set == 3 then
      text_STOP_menuF()  
    elseif menu_set == 4 then
      text_PAUSE_menuF()
    elseif menu_set == 5 then
      text_PLAY_menuF()
    elseif menu_set == 6 then
      text_REC_menuF()
    elseif menu_set == 7 then
      color_STOP_txt_menuF()  
    elseif menu_set == 8 then
      color_PAUSE_txt_menuF()
    elseif menu_set == 9 then
      color_PLAY_txt_menuF()
    elseif menu_set == 10 then
      color_REC_txt_menuF()
    elseif menu_set == 11 then
      color_STOP_bg_menuF()  
    elseif menu_set == 12 then
      color_PAUSE_bg_menuF()
    elseif menu_set == 13 then
      color_PLAY_bg_menuF()
    elseif menu_set == 14 then
      color_REC_bg_menuF()
    elseif menu_set == 15 then
      open_settings_file_menuF() -- open settings file location
    elseif menu_set == 16 then
      help_menuF() --show help
    elseif menu_set == 17 then
      return gfx.quit(), reaper.atexit(MAIN)
    end
  end
  

-----------------------------BG coloring------------------------------
----------------------------------------------------------------------
  if (reaper.GetPlayState() & 2) == 2 then
    asm.setColor(R_pause_bg, G_pause_bg, B_pause_bg, 255) --BG color Pause
    gfx.rect(margin, margin, width, height, true)
  elseif (reaper.GetPlayState() & 4) == 4 then
    asm.setColor(R_rec_bg, G_rec_bg, B_rec_bg, 255) --BG color Recording
    gfx.rect(margin, margin, width, height, true)
  elseif (reaper.GetPlayState() & 1) == 1 then
    asm.setColor(R_play_bg, G_play_bg, B_play_bg, 255) --BG color Playing
    gfx.rect(margin, margin, width, height, true)
  else
    asm.setColor(R_stop_bg, G_stop_bg, B_stop_bg, 255) --BG color Stop
    gfx.rect(margin, margin, width, height, true)
  end
  
  if repeat_unique_color_state == 1 and repeat_indicate_state == 1 then
    if (reaper.GetSetRepeat(-1) & 1) == 1 then
      if repeat_on_color_state == 1 then
        asm.setColor(R_repeat_on, G_repeat_on, B_repeat_on, 255) --Repeat color ON
      end
      gfx.rect(margin_repeat, margin_repeat, width/10, height-(margin_repeat*2), true)
      gfx.rect(width-(width/10)-margin_repeat+1, margin_repeat, width/10, height-(margin_repeat*2), true)
    else
      if repeat_off_color_state == 1 then
        asm.setColor(R_repeat_off, G_repeat_off, B_repeat_off, 255) --Repeat color OFF
      end
      gfx.rect(margin_repeat, margin_repeat, width/10, height-20, true)
      gfx.rect(width-(width/10)-margin_repeat+1, margin_repeat, width/10, height-(margin_repeat*2), true)
    end
  end
  
  if (reaper.GetPlayState() & 2) == 2 then --BG color Pause
    asm.setColor(R_pause_txt, G_pause_txt, B_pause_txt, 255)
    mouseOn(R_pause_txt, G_pause_txt, B_pause_txt, 255)
  elseif (reaper.GetPlayState() & 4) == 4 then --BG color Recording)
    asm.setColor(R_rec_txt, G_rec_txt, B_rec_txt, 255)
    mouseOn(R_rec_txt, G_rec_txt, B_rec_txt, 255)
  elseif (reaper.GetPlayState() & 1) == 1 then --BG color Playing
    asm.setColor(R_play_txt, G_play_txt, B_play_txt, 255)
    mouseOn(R_play_txt, G_play_txt, B_play_txt, 255)
  else --BG color Stop
    asm.setColor(R_stop_txt, G_stop_txt, B_stop_txt, 255)
    mouseOn(R_stop_txt, G_stop_txt, B_stop_txt, 255)
  end
  
  if repeat_unique_color_state == 0 and repeat_indicate_state == 1 then
    if (reaper.GetSetRepeat(-1) & 1) == 1 then
      gfx.rect(margin_repeat, margin_repeat, width/10, height-(margin_repeat*2), true)
      gfx.rect(width-(width/10)-margin_repeat+1, margin_repeat, width/10, height-(margin_repeat*2), true)
    end
  end

------------------------------draw Text-------------------------------
---------------------------------------------------------------------- 
  local font_size = 40
  gfx.setfont(1, 'Calibri', font_size*zoom, 98)
  local windowText = rec_state()
  local text_w, text_h = gfx.measurestr(windowText)
  if text_w > (window_w/100*60)+20 then
    while text_w > (window_w/100*60)+20 do
      font_size = font_size - 0.5
      gfx.setfont(1, 'Calibri', font_size*zoom, 98)
      windowText = rec_state()
      text_w, text_h = gfx.measurestr(windowText)
    end
  end
  text_x = ((window_w - text_w) / 2)
  text_y = ((window_h - text_h) / 2)
  asm.setXY(text_x, text_y)
  gfx.drawstr(windowText)
  --gfx.drawstr(windowText, CENTER_H | CENTER_V, right, bottom)

------------------------actions with RMB click------------------------
----------------------------------------------------------------------
  if RMB and mouse_on_window then
    mouse_Rclick = true
  elseif mouse_Rclick then
    if (reaper.GetPlayState() & 2) == 2 then --Pause
        asm.doCmdID(1013,'MAIN') --Transport: Record
    elseif (reaper.GetPlayState() & 4) == 4 then --Rec
        asm.doCmdID(1007,'MAIN') --Transport: Play
    elseif (reaper.GetPlayState() & 1) == 1 then --Play
        asm.doCmdID(1013,'MAIN') --Transport: Record
    elseif (reaper.GetPlayState() & 0) == 0 then --Stop
        asm.doCmdID(1013,'MAIN') --Transport: Record
    end
    mouse_Rclick = false
  end
------------------------actions with LMB click------------------------
----------------------------------------------------------------------
  if LMB and mouse_on_window then --actions with LMB click
    mouse_Lclick = true
  elseif mouse_Lclick then
    if (reaper.GetPlayState() & 2) == 2 then --Pause
      if Shift then --Shift+LMB
        asm.doCmdID(1007,'MAIN') --Transport: Play
      elseif Ctrl then --Ctrl+LMB
        asm.doCmdID(1013,'MAIN') --Transport: Record
      elseif RMB then --RMB
        asm.doCmdID(1013,'MAIN') --Transport: Record
      else --LMB
        asm.doCmdID(1007,'MAIN') --Transport: Play
      end
    elseif (reaper.GetPlayState() & 4) == 4 then --Rec
      if Shift then --Shift+LMB
        asm.doCmdID(1008,'MAIN') --Transport: Pause
      elseif Ctrl then --Ctrl+LMB
        asm.doCmdID(1007,'MAIN') --Transport: Play
      elseif RMB then --RMB
        asm.doCmdID(1016,'MAIN') --Transport: Stop
      else --LMB
        asm.doCmdID(1016,'MAIN') --Transport: Stop
      end
    elseif (reaper.GetPlayState() & 1) == 1 then --Play
      if Shift then --Shift+LMB
        asm.doCmdID(1008,'MAIN') --Transport: Pause
      elseif Ctrl then --Ctrl+LMB
        asm.doCmdID(1013,'MAIN') --Transport: Record
      elseif RMB then --RMB
        asm.doCmdID(1013,'MAIN') --Transport: Record
      else --LMB
        asm.doCmdID(1016,'MAIN') --Transport: Stop
      end
    elseif (reaper.GetPlayState() & 0) == 0 then --Stop
      if Shift then --Shift+LMB
        asm.doCmdID(1008,'MAIN') --Transport: Pause
      elseif Ctrl then --Ctrl+LMB
        asm.doCmdID(1013,'MAIN') --Transport: Record
      elseif RMB then --RMB
        asm.doCmdID(1013,'MAIN') --Transport: Record
      else --LMB
        asm.doCmdID(1007,'MAIN') --Transport: Play
      end
    end
    mouse_Lclick = false
  end
  
---------------------actions with keyboard hotkeys--------------------
----------------------------------------------------------------------  
  if char >= 0 then 
    if (reaper.GetPlayState() & 2) == 2 then --------------------------------Pause
       if Shift and char == 32 then --Shift+space
         asm.doCmdID(1007,'MAIN') --Transport: Play
       elseif char == 32 then --space
         asm.doCmdID(1007,'MAIN') --Transport: Play
       elseif char == user_record_key_number then --*
         asm.doCmdID(1013,'MAIN') --Transport: Record
       end
    elseif (reaper.GetPlayState() & 4) == 4 then --------------------------------Rec
      if Shift and char == 32 then --Shift+space
      asm.doCmdID(1008,'MAIN') --Transport: Pause
      elseif char == 32 then --space
        asm.doCmdID(1016,'MAIN') --Transport: Stop
      elseif char == user_record_key_number then --*
        asm.doCmdID(1007,'MAIN') --Transport: Play
      end
    elseif (reaper.GetPlayState() & 1) == 1 then --------------------------------Play
      if Shift and char == 32 then --Shift+space
        asm.doCmdID(1008,'MAIN') --Transport: Pause
      elseif char == 32 then --space
        asm.doCmdID(1016,'MAIN') --Transport: Stop
      elseif char == user_record_key_number then --*
        asm.doCmdID(1013,'MAIN') --Transport: Record
      end
    elseif (reaper.GetPlayState() & 0) == 0 then --------------------------------Stop
      if Shift and char == 32 then --Shift+space
        asm.doCmdID(1008,'MAIN') --Transport: Pause
      elseif char == 32 then --space
        asm.doCmdID(1007,'MAIN') --Transport: Play
      elseif char == user_record_key_number then --*
        asm.doCmdID(1013,'MAIN') --Transport: Record  
      end
    end
    
    if char == user_repeat_key_number then --------------------------------Repeat
      Msg(555)
      DEL_testF()
      reaper.GetSetRepeat(2)
    end
  end
    
  gfx.update()
  reaper.defer(MAIN)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

gfx.setfont(1, 'Calibri', 30, 9)
gfx.init("ASM Record play stop pause state", window_w, window_h, docker_start)
MAIN()

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

::END::




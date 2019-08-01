--[[
 * ReaScript Name: ASM [GUI DEVELOPER] Show gfx.getchar() number (img)
 * Instructions: Use the keyboard to find out the number that the gfx.getchar () function needs.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.1
 * Description: Show gfx.getchar() number
 * Provides: ../_images/ASM GUI DEVELOPER Show gfx.getchar() number (img)/*.{png}
--]]

--[[
 * Changelog:
 * v1.0.0 (2018-07-16)
  + Initial release
 * v1.0.1 (2019-03-16)
  # Update code
--]]

script_title='ASM [GUI DEVELOPER] Show gfx.getchar() number (img)'

local window_w_start = 350
local window_h_start = 150
local zoom = 1
local window_w = window_w_start*zoom
local window_h = window_h_start*zoom

local design_state_img = 'img'

local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."asm"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."math"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."other"..".lua")

gfx.loadimg(800, script_path .. "../_images/"..script_title.."/BG.png")
gfx.loadimg(801, script_path .. "../_images/"..script_title.."/ASM.png")
gfx.loadimg(802, script_path .. "../_images/"..script_title.."/zoom_minus.png")
gfx.loadimg(803, script_path .. "../_images/"..script_title.."/zoom_plus.png")


-----------------------------------------------------------------------------------------
--[[function cutFloatTo(num, idp) --function that does not round a but truncates fractional numbers
  idp = (10^idp)
  intNum,remNum = math.modf(num)
  remNum = math.modf(remNum*idp)/idp
  newNum = intNum + remNum
  return newNum
end]]
-----------------------------------------------------------------------------------------
--[[asm = {
  getRGBA = function (rgbR, rgbG, rgbB, rgbA) -- Convert RGB to float numbers
      rgbR, rgbG, rgbB, rgbA = rgbR/255, rgbG/255, rgbB/255, rgbA/255
      return rgbR, rgbG, rgbB, rgbA
  end,
  setColor = function(r, g, b, a) gfx.r, gfx.g, gfx.b, gfx.a = asm.getRGBA(r, g, b, a) return r, g, b, a end, --set (and return) convertetd RGBA color
  setXY = function(x, y) gfx.x, gfx.y = x, y end, --set x, y coordinates
  doCmdID = function(cID_input, type) --commandID, type: 'MAIN' - Main , 'MIDI' - MIDI )
    if type == 'MAIN' then commandID = reaper.NamedCommandLookup(cID_input) reaper.Main_OnCommand(commandID, 0)
    elseif type == 'MIDI' then activeMidiEditor = reaper.MIDIEditor_GetActive() commandID = reaper.NamedCommandLookup(cID_input) reaper.MIDIEditor_OnCommand(activeMidiEditor, commandID) end
  end
}]]
-----------------------------------------------------------------------------------------



function extended(Child, Parent)
  setmetatable(Child,{__index = Parent}) 
end

----------------------------------------------------------------------
--------------------------- CREATE BUTTON ----------------------------
----------------------------------------------------------------------
Element = {}
function Element:new_elem(x, y, w, h, fill,
                          bt_img_numb, bt_img_src_x, bt_img_src_y, bt_img_src_w, bt_img_src_h, bt_type,
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
      elem.bt_img_numb, elem.bt_img_src_x, elem.bt_img_src_y = bt_img_numb, bt_img_src_x, bt_img_src_y
      elem.bt_img_src_w, elem.bt_img_src_h, elem.bt_type = bt_img_src_w, bt_img_src_h, bt_type
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
  Alt   = (gfx.mouse_cap & 16) ~= 0
  Win   = (gfx.mouse_cap & 32) ~= 0
  MMB   = (gfx.mouse_cap & 64) ~= 0
  
end
------------------------------------------------------------------
------------------------------------------------------------------
Button = {}
extended(Button, Element)
--button.state = false

function Button:create()
  x, y, w, h, fill = self.x, self.y, self.w, self.h, self.fill
  bt_img_numb, bt_img_src_x, bt_img_src_y = self.bt_img_numb, self.bt_img_src_x, self.bt_img_src_y
  bt_img_src_w, bt_img_src_h, bt_type = self.bt_img_src_w, self.bt_img_src_h, self.bt_type
  text_1, r_1, g_1, b_1, a_1 = self.text_1, self.r_1, self.g_1, self.b_1, self.a_1
  text_2, r_2, g_2, b_2, a_2 = self.text_2, self.r_2, self.g_2, self.b_2, self.a_2
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
  x, y, w, h = x*zoom, y*zoom, w*zoom, h*zoom-- zooming some varibles
  if font_size then font_size = font_size*zoom end
  if fr_x and fr_y and fr_w and fr_h then fr_x, fr_y, fr_w, fr_h = fr_x*zoom, fr_y*zoom, fr_w*zoom, fr_h*zoom end
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
  if bt_type == 'img' then
      gfx.blit(bt_img_numb, 1, 0, bt_img_src_x_pos, bt_img_src_y, bt_img_src_w, bt_img_src_h, x, y, w, h)
    else
      gfx.rect(x, y, w, h, fill)
  end
end
------------------------------------------------------------------
function Button:draw_frame()
  if bt_type ~= 'img' then
    if fr_x and fr_y and fr_w and fr_h then
      asm.setColor(fr_r, fr_g, fr_b, fr_a)
      gfx.rect(fr_x, fr_y, fr_w, fr_h, false)
    end
  end
end
------------------------------------------------------------------
function Button:mouse_on()            
  mouse_on_button =
                (gfx.mouse_x > x-1 and gfx.mouse_x < x+w) and
                (gfx.mouse_y > y-1 and gfx.mouse_y < y+h)
end
------------------------------------------------------------------
function Button:change_on_off()
  if bt_type == 'img' then
    if not state_boolean then
               --gfx.blit(source, scale, rotation[, srcx, srcy, srcw, srch, destx, desty, destw, desth, rotxoffs, rotyoffs] )
                 --gfx.blit(bt_img_numb, 1, 0 , bt_img_src_x_pos, bt_img_src_y, bt_img_src_w, bt_img_src_h, x, y, w, h)
                bt_img_src_x = bt_img_src_x
               else
                bt_img_src_x = bt_img_src_x+(bt_img_src_w*2)
                 --gfx.blit(bt_img_numb, 1, 0, bt_img_src_x+bt_img_src_w, bt_img_src_y, bt_img_src_w, bt_img_src_h, x, y, w, h)
               end
  else
    if not state_boolean then
                 r, g, b, a = r_1, g_1, b_1, a_1
                 text = text_1
               else
                 r, g, b, a = r_2, g_2, b_2, a_2
                 text = text_2
               end
  end
end
------------------------------------------------------------------
function Button:color_on()
  if bt_type == 'img' then
      if (gfx.mouse_cap & 1) == 0 and mouse_on_button then
        --gfx.blit(bt_img_numb, 1, 0, bt_img_src_x+bt_img_src_w, bt_img_src_y, bt_img_src_w, bt_img_src_h, x, y, w, h)
        bt_img_src_x_pos = bt_img_src_x+bt_img_src_w
        button_up = true
      else
        bt_img_src_x_pos = bt_img_src_x
        --gfx.blit(bt_img_numb, 1, 0, bt_img_src_x, bt_img_src_y, bt_img_src_w, bt_img_src_h, x, y, w, h)
      end
  else
      if (gfx.mouse_cap & 1) == 0 and mouse_on_button then
        asm.setColor(r+20, g+20, b+20, a)
        button_up = true
      else
        asm.setColor(r, g, b, a)
      end
  end
end
------------------------------------------------------------------
function Button:draw_text()
  gfx.setfont(1, font, font_size, font_type)
  if font_r and font_g and font_b and font_a then
    asm.setColor(font_r, font_g, font_b, font_a)
  end
  text_w, text_h = gfx.measurestr(text)
  text_x = ((w - text_w) / 2 + x)
  text_y = ((h - text_h) / 2 + y)
  asm.setXY(text_x, text_y)
  if text then gfx.drawstr(text) end
end
------------------------------------------------------------------
function Button:LMB()
  
  if (gfx.mouse_cap & 1) ~= 0 and mouse_on_button then --undo_point
    --[[reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()
    
    --reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock(script_title, -1)
    --reaper.UpdateArrange()]]
  end
  if (gfx.mouse_cap & 1) ~= 0 and (gfx.mouse_cap & 4) ~= 0 and (gfx.mouse_cap & 8) ~= 0 and (gfx.mouse_cap & 16) ~= 0 and mouse_on_button then --LMB+Ctrl+Shift+Alt
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
        if func_15_LMB_ctrl_shift_alt or func_16_LMB_ctrl_shift_alt then
          if state_boolean and button_up then
            func_15_LMB_ctrl_shift_alt(indx_numb)
          elseif button_up then
            func_16_LMB_ctrl_shift_alt(indx_numb)
          end
        end
    button_up = false
  elseif (gfx.mouse_cap & 1) ~= 0 and (gfx.mouse_cap & 8) ~= 0 and (gfx.mouse_cap & 16) ~= 0 and mouse_on_button then --LMB+Shift+Alt
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
        if func_13_LMB_shift_alt or func_14_LMB_shift_alt then
          if state_boolean and button_up then
            func_13_LMB_shift_alt(indx_numb)
          elseif button_up then
            func_14_LMB_shift_alt(indx_numb)
          end
        end
    button_up = false
  elseif (gfx.mouse_cap & 1) ~= 0 and (gfx.mouse_cap & 4) ~= 0 and (gfx.mouse_cap & 16) ~= 0 and mouse_on_button then --LMB+Ctrl+Alt
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
        if func_11_LMB_ctrl_alt or func_12_LMB_ctrl_alt then
          if state_boolean and button_up then
            func_11_LMB_ctrl_alt(indx_numb)
          elseif button_up then
            func_12_LMB_ctrl_alt(indx_numb)
          end
        end
    button_up = false
  elseif (gfx.mouse_cap & 1) ~= 0 and (gfx.mouse_cap & 4) ~= 0 and (gfx.mouse_cap & 8) ~= 0 and mouse_on_button then --LMB+Ctrl+Shift
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
        if func_09_LMB_ctrl_shift or func_10_LMB_ctrl_shift then
          if state_boolean and button_up then
            func_09_LMB_ctrl_shift(indx_numb)
          elseif button_up then
            func_10_LMB_ctrl_shift(indx_numb)
          end
        end
    button_up = false
  elseif (gfx.mouse_cap & 1) ~= 0 and (gfx.mouse_cap & 16) ~= 0 and mouse_on_button then -- LMB+Alt
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
      if func_07_LMB_alt or func_08_LMB_alt then
        if state_boolean and button_up then
          func_07_LMB_alt(indx_numb)
        elseif button_up then
          func_08_LMB_alt(indx_numb)
        end
      end
    button_up = false
  elseif (gfx.mouse_cap & 1) ~= 0 and (gfx.mouse_cap & 8) ~= 0 and mouse_on_button then -- LMB+Shift
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
      if func_05_LMB_shift or func_06_LMB_shift then
        if state_boolean and button_up then
          func_05_LMB_shift(indx_numb)
        elseif button_up then
          func_06_LMB_shift(indx_numb)
        end
      end
    button_up = false
  elseif (gfx.mouse_cap & 1) ~= 0 and (gfx.mouse_cap & 4) ~= 0 and mouse_on_button then --LMB+Ctrl
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
      if func_03_LMB_ctrl or func_04_LMB_ctrl then
        if state_boolean and button_up then
          func_03_LMB_ctrl(indx_numb)
        elseif button_up then
          func_04_LMB_ctrl(indx_numb)
        end
      end
    button_up = false
  elseif (gfx.mouse_cap & 1) ~= 0 and mouse_on_button then --LMB
    reaper.Undo_BeginBlock()
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
      if func_01_LMB or func_02_LMB then
        if state_boolean and button_up then
          func_01_LMB(indx_numb)
        elseif button_up then
          func_02_LMB(indx_numb)
        end
      end
    button_up = false
  end
  reaper.Undo_EndBlock(script_title, -1)
end
------------------------------------------------------------------
function Button:RMB()
  if (gfx.mouse_cap & 2) ~= 0 and mouse_on_button then
    if bt_type == 'img' then
      bt_img_src_x_pos = bt_img_src_x+(bt_img_src_w*2)
    else
      asm.setColor(r-30, g-30, b-30, a)
    end
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
------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------


function MAIN()
  --window_w = window_w_start*zoom
  --window_h = window_h_start*zoom
  --zoom = cutFloatTo(math.min (gfx.w/window_w_start, gfx.h/window_h_start), 1) -- zoom number
  --if zoom <= 1 then zoom = 1 end
  
  if not design_state then
    gfx.blit(800, 1, 0, 0, 0, 350, 150, 0, 0, window_w, window_h)
  else
    asm.setColor(35, 35, 35, 255)
    gfx.rect(0, 0, window_w, window_h, true)
    asm.setColor(20, 20, 20, 255)
    for i = 0, 5 do
      gfx.rect(i, i, window_w-(i*2), window_h-(i*2), false)
    end
  end
  
--------------------------------------------------------------------------
  function Design_1()
    design_state = false
  end
  function Design_2()
    design_state = true
  end  
--------------------------------------------------------------------------
  function Zoom_minus()
    zoom = zoom - 0.5
    if zoom <= 0.5 then zoom = 0.5 end
    window_w = window_w_start*zoom
    window_h = window_h_start*zoom
    
    local _, new_x_pos, new_y_pos, _, _ = gfx.dock(-1, 0, 0, 0, 0)
    gfx.quit()
    gfx.init("Show gfx.getchar() number (img)", window_w, window_h, 0, new_x_pos, new_y_pos)
  end
--------------------------------------------------------------------------
  function Zoom_plus()
    zoom = zoom + 0.5
    if zoom >= 3 then zoom = 3 end
    window_w = window_w_start*zoom
    window_h = window_h_start*zoom
    
    local _, new_x_pos, new_y_pos, _, _ = gfx.dock(-1, 0, 0, 0, 0)
    gfx.quit()
    gfx.init("Show gfx.getchar() number (img)", window_w, window_h, 0, new_x_pos, new_y_pos)
  end
------------------------------------------------------------------------- 
  gfx.setfont(1, 'Calibri', 80*zoom, 98)
  text_w, text_h = gfx.measurestr(show_Char)
  text_x = ((window_w - text_w) / 2)
  text_y = ((window_h - text_h) / 2)
  asm.setXY(text_x, text_y)
  asm.setColor(200, 200, 200, 255)
  if show_Char then
    gfx.drawstr(show_Char)
  end
  
  --------------------------------------------------------------------------
  Btn_1 = Button:new_elem(325, 130, 20, 10, true, --button
                          801, 0, 0, 60, 30, 'img', --img bg
                          'on', 35, 35, 35, 255, 'off', 80, 80, 80, 255, --bg
                          design_state, '', _, '39', _, _, _, _, --text
                          325, 130, 20, 10, 255, 255, 255, 255, '', --frame
                          Design_1, Design_2) --function
                          
  Btn_2 = Button:new_elem(5, 130, 10, 10, true, --button
                          802, 0, 0, 30, 30, 'img', --img bg
                          'on', 35, 35, 35, 255, 'off', 80, 80, 80, 255, --bg
                          design_state, '', _, '39', _, _, _, _, --text
                          325, 130, 20, 10, 255, 255, 255, 255, '', --frame
                          Zoom_minus, Zoom_minus) --function   
                          
  Btn_3 = Button:new_elem(15, 130, 9, 10, true, --button
                          803, 0, 0, 27, 30, 'img', --img bg
                          'on', 35, 35, 35, 255, 'off', 80, 80, 80, 255, --bg
                          design_state, '', _, '39', _, _, _, _, --text
                          325, 130, 20, 10, 255, 255, 255, 255, '', --frame
                          Zoom_plus, Zoom_plus) --function                      
  
  Buttons_tab = {Btn_1, Btn_2, Btn_3}
  
  
  function Create()
    for key, btns        in pairs(Buttons_tab)  do btns:create() end
  end
  
  Create()
  --------------------------------------------------------------------------  
  
  
  Char =  gfx.getchar()
  if Char > 0 then
    show_Char =  math.modf(Char)
    --Msg(Char)
  end
  if  Char >= 0 then --exit function/
     reaper.defer(MAIN)
   end
  gfx.update()
  reaper.atexit(MAIN)
end

mouse_glob_x, mouse_glob_y = reaper.GetMousePosition()
gfx.init("Show gfx.getchar() number (img)", window_w, window_h, 0, 50, 50)
MAIN()

--[[
 * ReaScript Name: ASM [_LIBRARY] buttons.lua
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.1
--]]

--[[
 * Changelog:
 * v1.0.0 (2020-04-01)
  + Initial release
* v1.0.1 (2020-04-02)
  + Initial release
--]]





----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
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
function Element:new_elem(x_btn_position, y_btn_position, w_btn_width, h_btn_height, fill,   

                          parameter_01, parameter_02, parameter_03, parameter_04, parameter_05,
  
                          btn_state_boolean, zoom_index, hover_color_plus, pressed_color_minus, -- button state, button zoom, and button index num

                          btn_r_1, btn_g_1, btn_b_1, btn_a_1, -- state 1 buttons parameters
                          btn_border_size_1, btn_border_r_1, btn_border_g_1, btn_border_b_1, btn_border_a_1,
                          border_r_pressed_1, border_g_pressed_1, border_b_pressed_1, border_a_pressed_1,
                          border_r_hover_1, border_g_hover_1, border_b_hover_1, border_a_hover_1,
                          btn_text_1, font_name_1, font_size_1, font_type_1,
                          font_r_1, font_g_1, font_b_1, font_a_1,

                          btn_r_2, btn_g_2, btn_b_2, btn_a_2, -- state 2 buttons parameters
                          btn_border_size_2, btn_border_r_2, btn_border_g_2, btn_border_b_2, btn_border_a_2,
                          border_r_pressed_2, border_g_pressed_2, border_b_pressed_2, border_a_pressed_2,
                          border_r_hover_2, border_g_hover_2, border_b_hover_2, border_a_hover_2,
                          btn_text_2, font_name_2, font_size_2, font_type_2,
                          font_r_2, font_g_2, font_b_2, font_a_2,
                          
                          --gfx.blit(bt_img_numb, 1, 0, bt_img_src_x, bt_img_src_y, bt_img_src_w, bt_img_src_h, x, y, w, h)
                          
                          func_01, func_02, func_03, func_04, func_05, func_06, func_07, func_08, func_09, func_10,
                          func_11, func_12, func_13, func_14, func_15, func_16, func_17, func_18, func_19, func_20,
                          func_21, func_22, func_23, func_24, func_25, func_26, func_27, func_28, func_29, func_30,
                          func_31, func_32, func_33, func_34, func_35, func_36, func_37, func_38, func_39, func_40,
                          func_41, func_42, func_43, func_44, func_45, func_46, func_47, func_48, func_49, func_50)
    local elem = {}
      elem.x, elem.y, elem.w, elem.h, elem.fill = x_btn_position, y_btn_position, w_btn_width, h_btn_height, fill

      elem.parameter_01, elem.parameter_02, elem.parameter_03, elem.parameter_04, elem.parameter_05 = parameter_01, parameter_02, parameter_03, parameter_04, parameter_05

      elem.state_boolean, elem.zoom_index, elem.hover_color_plus, elem.pressed_color_minus =  btn_state_boolean, zoom_index, hover_color_plus, pressed_color_minus

      elem.r_1_1, elem.g_1_1, elem.b_1_1, elem.a_1_1 = btn_r_1, btn_g_1, btn_b_1, btn_a_1
      elem.border_1, elem.r_1_2, elem.g_1_2, elem.b_1_2, elem.a_1_2 = btn_border_size_1, btn_border_r_1, btn_border_g_1, btn_border_b_1, btn_border_a_1
      elem.r_1_3, elem.g_1_3, elem.b_1_3, elem.a_1_3 = border_r_pressed_1, border_g_pressed_1, border_b_pressed_1, border_a_pressed_1
      elem.r_1_4, elem.g_1_4, elem.b_1_4, elem.a_1_4 = border_r_hover_1, border_g_hover_1, border_b_hover_1, border_a_hover_1
      elem.text_1, elem.font_1, elem.font_size_1, elem.font_type_1 = btn_text_1, font_name_1, font_size_1, font_type_1
      elem.font_r_1, elem.font_g_1, elem.font_b_1, elem.font_a_1 = font_r_1, font_g_1, font_b_1, font_a_1

      elem.r_2_1, elem.g_2_1, elem.b_2_1, elem.a_2_1 = btn_r_2,  btn_g_2,  btn_b_2,  btn_a_2
      elem.border_2, elem.r_2_2, elem.g_2_2, elem.b_2_2, elem.a_2_2 = btn_border_size_2, btn_border_r_2, btn_border_g_2,  btn_border_b_2, btn_border_a_2
      elem.r_2_3, elem.g_2_3, elem.b_2_3, elem.a_2_3 = border_r_pressed_2, border_g_pressed_2, border_b_pressed_2, border_a_pressed_2
      elem.r_2_4, elem.g_2_4, elem.b_2_4, elem.a_2_4 = border_r_hover_2, border_g_hover_2, border_b_hover_2, border_a_hover_2
      elem.text_2, elem.font_2, elem.font_size_2, elem.font_type_2 = btn_text_2, font_name_2, font_size_2, font_type_2
      elem.font_r_2, elem.font_g_2, elem.font_b_2, elem.font_a_2 = font_r_2, font_g_2, font_b_2, font_a_2

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

------------------------------------------------------------------
------------------------------------------------------------------
Button = {}
extended(Button, Element)
--button.state = false

function Button:create()

  x, y, w, h, fill = self.x, self.y, self.w, self.h, self.fill

  param_01, param_02, param_03, param_04, param_05 = self.parameter_01, self.parameter_02, self.parameter_03, self.parameter_04, self.parameter_05

  state_boolean, zoom_index, hover_color_plus, pressed_color_minus = self.state_boolean, self.zoom_index, self.hover_color_plus, self.pressed_color_minus

  r_1_1, g_1_1, b_1_1, a_1_1 = self.r_1_1, self.g_1_1, self.b_1_1, self.a_1_1
  border_1, r_1_2, g_1_2, b_1_2, a_1_2 = self.border_1, self.r_1_2, self.g_1_2, self.b_1_2, self.a_1_2
  r_1_3, g_1_3, b_1_3, a_1_3 = self.r_1_3, self.g_1_3, self.b_1_3, self.a_1_3
  r_1_4, g_1_4, b_1_4, a_1_4 = self.r_1_4, self.g_1_4, self.b_1_4, self.a_1_4
  text_1, font_1, font_size_1, font_type_1 = self.text_1, self.font_1, self.font_size_1, self.font_type_1
  font_r_1, font_g_1, font_b_1, font_a_1 = self.font_r_1, self.font_g_1, self.font_b_1, self.font_a_1

  r_2_1, g_2_1, b_2_1, a_2_1 = self.r_2_1, self.g_2_1, self.b_2_1, self.a_2_1
  border_2, r_2_2, g_2_2, b_2_2, a_2_2 = self.border_2, self.r_2_2, self.g_2_2, self.b_2_2, self.a_2_2
  r_2_3, g_2_3, b_2_3, a_2_3 = self.r_2_3, self.g_2_3, self.b_2_3, self.a_2_3
  r_2_4, g_2_4, b_2_4, a_2_4 = self.r_2_4, self.g_2_4, self.b_2_4, self.a_2_4
  text_2, font_2, font_size_2, font_type_2 = self.text_2, self.font_2, self.font_size_2, self.font_type_2
  font_r_2, font_g_2, font_b_2, font_a_2 = self.font_r_2, self.font_g_2, self.font_b_2, self.font_a_2

  func_01_LMB, func_02_LMB, func_03_LMB_ctrl, func_04_LMB_ctrl = self.func_01, self.func_02, self.func_03, self.func_04
  func_05_LMB_shift, func_06_LMB_shift, func_07_LMB_alt, func_08_LMB_alt = self.func_05, self.func_06, self.func_07, self.func_08
  func_09_LMB_ctrl_shift, func_10_LMB_ctrl_shift, func_11_LMB_ctrl_alt, func_12_LMB_ctrl_alt = self.func_09, self.func_10, self.func_11, self.func_12
  func_13_LMB_shift_alt, func_14_LMB_shift_alt, func_15_LMB_ctrl_shift_alt, func_16_LMB_ctrl_shift_alt = self.func_13, self.func_14, self.func_15, self.func_16
  
  func_01_RMB, func_02_RMB, func_19_RMB_ctrl, func_20_RMB_ctrl = self.func_17, self.func_18, self.func_19, self.func_20
  func_21_RMB_shift, func_22_RMB_shift, func_23_RMB_alt, func_24_RMB_alt = self.func_21, self.func_22, self.func_23, self.func_24
  func_25_RMB_ctrl_shift, func_26_RMB_ctrl_shift, func_27_RMB_ctrl_alt, func_28_RMB_ctrl_alt = self.func_25, self.func_26, self.func_27, self.func_28
  func_29_RMB_shift_alt, func_30_RMB_shift_alt, func_31_RMB_ctrl_shift_alt, func_32_RMB_ctrl_shift_alt = self.func_29, self.func_30, self.func_31, self.func_32
    
  func_01_MMB, func_02_MMB, func_35_MMB_ctrl, func_36_MMB_ctrl = self.func_33, self.func_34, self.func_35, self.func_36
  func_37_MMB_shift, func_38_MMB_shift, func_39_MMB_alt, func_40_MMB_alt = self.func_37, self.func_38, self.func_39, self.func_40
  func_41_MMB_ctrl_shift, func_42_MMB_ctrl_shift, func_43_MMB_ctrl_alt, func_44_MMB_ctrl_alt = self.func_41, self.func_42, self.func_43, self.func_44
  func_45_MMB_shift_alt, func_46_MMB_shift_alt, func_47_MMB_ctrl_shift_alt, func_48_MMB_ctrl_shift_alt = self.func_45, self.func_46, self.func_47, self.func_48
  
  x, y, w, h = x*zoom_index, y*zoom_index, w*zoom_index, h*zoom_index -- zooming some varibles
  if font_size_1 ~= nil then font_size_1 = font_size_1*zoom_index end
  if font_size_2 ~= nil then font_size_2 = font_size_2*zoom_index end
  if text_1 == nil then text_1 = '' end
  if text_2 == nil then text_2 = '' end
  --if border_1 then border_1 = border_1*zoom_index end
  --if border_2 then border_2 = border_2*zoom_index end
  
  LMB   = (gfx.mouse_cap & 1) ~= 0
  RMB   = (gfx.mouse_cap & 2) ~= 0
  Ctrl  = (gfx.mouse_cap & 4) ~= 0
  Shift = (gfx.mouse_cap & 8) ~= 0
  Alt   = (gfx.mouse_cap & 16) ~= 0
  Win   = (gfx.mouse_cap & 32) ~= 0
  MMB   = (gfx.mouse_cap & 64) ~= 0
  
  Button:mouse_on()
  Button:get_button_type()
  Button:change_state_on_off()
  Button:draw_bg()
  Button:draw_text()
  Button:LMB()
  Button:RMB()
  Button:MMB()

end
------------------------------------------------------------------
function Button:get_button_type()
  if not LMB and not MMB and not RMB and mouse_on_button then
    button_type = "hover"
  elseif (LMB or MMB or RMB) and mouse_on_button then
    button_type = "pressed"
  else
    button_type = "normal"
  end
end
------------------------------------------------------------------
function Button:draw_bg()
  
  if border_1 > 0 then -- draw border if it is > 0
  
    fr_x, fr_y, fr_w, fr_h = x, y, w, h
    x, y, w, h = x+border_1, y+border_1, w-border_1*2, h-border_1*2

    
    if button_type == "normal" then
      asm.setColor(border_r, border_g, border_b, border_a)
    elseif button_type == "hover" then
      asm.setColor(border_r_hover, border_g_hover, border_b_hover, border_a_hover)
    elseif button_type == "pressed" then
      asm.setColor(border_r_pressed, border_g_pressed, border_b_pressed, border_a_pressed)
    end
    
    gfx.rect(fr_x, fr_y, fr_w, fr_h, true)
  end
    
  
  if button_type == "normal" then -- draw bg
    asm.setColor(r, g, b, a)
  elseif button_type == "hover" then
    asm.setColor(r+hover_color_plus, g+hover_color_plus, b+hover_color_plus, a)
    button_up = true
  elseif button_type == "pressed" then
    asm.setColor(r-pressed_color_minus, g-pressed_color_minus, b-pressed_color_minus, a)
  end

  gfx.rect(x, y, w, h, fill) -- draw BG
end
------------------------------------------------------------------
function Button:mouse_on()            
  mouse_on_button =
                (gfx.mouse_x > x-1 and gfx.mouse_x < x+w) and
                (gfx.mouse_y > y-1 and gfx.mouse_y < y+h)
end
------------------------------------------------------------------
function Button:change_state_on_off()
  if not state_boolean then
    r, g, b, a = r_1_1, g_1_1, b_1_1, a_1_1
    r_original_btn_color, g_original_btn_color, b_original_btn_color, a_original_btn_color = r_1_1, g_1_1, b_1_1, a_1_1
    border_1, border_r, border_g, border_b, border_a =  border_1, r_1_2, g_1_2, b_1_2, a_1_2
    border_r_hover, border_g_hover, border_b_hover, border_a_hover = r_1_3, g_1_3, b_1_3, a_1_3
    border_r_pressed, border_g_pressed, border_b_pressed, border_a_pressed = r_1_4, g_1_4, b_1_4, a_1_4
    font, font_size, font_type = font_1, font_size_1, font_type_1
    font_r, font_g, font_b, font_a = font_r_1, font_g_1, font_b_1, font_a_1
    text = text_1
  else
    r_original_btn_color, g_original_btn_color, b_original_btn_color, a_original_btn_color = r_2_1, g_2_1, b_2_1, a_2_1
    r, g, b, a = r_2_1, g_2_1, b_2_1, a_2_1
    border_1, border_r, border_g, border_b, border_a =  border_2, r_2_2, g_2_2, b_2_2, a_2_2
    border_r_hover, border_g_hover, border_b_hover, border_a_hover = r_2_3, g_2_3, b_2_3, a_2_3
    border_r_pressed, border_g_pressed, border_b_pressed, border_a_pressed = r_2_4, g_2_4, b_2_4, a_2_4
    font, font_size, font_type = font_2, font_size_2, font_type_2
    font_r, font_g, font_b, font_a = font_r_2, font_g_2, font_b_2, font_a_2
    text = text_2
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
-------------------------Create Button----------------------------
------------------------------------------------------------------
function createButton(buttons_table)
  if type(buttons_table) == 'table' then
    for table_key, table_val in pairs(buttons_table) do
      if type(table_val) == "table" then
        table_val:create()
      elseif table_val ~= nil then
        buttons_table:create()
        return
      end
    end
  else
    Msg("Table is not a table")
  end
end
--[[
 * ReaScript Name: ASM [GUI DEVELOPER] Show gfx.getchar() number (GUI)
 * Instructions: Use the keyboard to find out the number that the gfx.getchar () function needs.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: Show gfx.getchar() number
--]]

--[[
 * Changelog:
 * v1.0.0 (2018-07-06)
  + Initial release
--]]

function cutFloatTo(num, idp) --function that does not round a but truncates fractional numbers
  idp = (10^idp)
  intNum,remNum = math.modf(num)
  remNum = math.modf(remNum*idp)/idp
  newNum = intNum + remNum
  return newNum
end
-----------------------------------------------------------------------------------------
asm = {
  getRGBA = function (rgbR, rgbG, rgbB, rgbA) -- Convert RGB to float numbers
      rgbCONST = 0.00390625    -- ASM Rgb constanta
      rgbR = rgbR * rgbCONST
      rgbG = rgbG * rgbCONST
      rgbB = rgbB * rgbCONST
      rgbA = rgbA * rgbCONST
      return rgbR, rgbG, rgbB, rgbA  
  end,
  setColor = function(r, g, b, a) gfx.r, gfx.g, gfx.b, gfx.a = asm.getRGBA(r, g, b, a) end,
  setXY = function(x, y) gfx.x, gfx.y = x, y end
}
-----------------------------------------------------------------------------------------
window_w_start = 350
window_h_start = 150
zoom = 1
window_w = window_w_start*zoom
window_h = window_h_start*zoom

function MAIN()
  window_w = window_w_start*zoom
  window_h = window_h_start*zoom
  zoom = cutFloatTo(math.min (gfx.w/window_w_start, gfx.h/window_h_start), 1) -- zoom number
  if zoom <= 1 then zoom = 1 end
  asm.setColor(35, 35, 35, 255)
  gfx.rect(0, 0, window_w, window_h, true)
  asm.setColor(20, 20, 20, 255)
  for i = 0, 5 do
    gfx.rect(i, i, window_w-(i*2), window_h-(i*2), false)
  end
  gfx.setfont(1, 'Calibri', 100*zoom, 98)
  text_w, text_h = gfx.measurestr(show_Char)
  text_x = ((window_w - text_w) / 2)
  text_y = ((window_h - text_h) / 2)
  asm.setXY(text_x, text_y)
  asm.setColor(200, 200, 200, 255)
  if show_Char then
    gfx.drawstr(show_Char)
  end
  
  Char =  gfx.getchar()
  if Char > 0 then
    show_Char =  math.modf(Char)
    --Msg(Char)
  end
  if Char >= 0 then --exit function/
     reaper.defer(MAIN) else gfx.quit()
   end
  gfx.update()
  reaper.atexit(MAIN)
end

gfx.init("Show gfx.getchar() number", window_w, window_h)
MAIN()

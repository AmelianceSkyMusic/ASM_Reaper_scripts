--[[
 * ReaScript Name: ASM [ENV] Set new value for selected automation points _underlying envelope
 * Instructions: Select some points in automation item (in selected envelope) and Run.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: A script for the relative editing of automation points by using a single least value  
--]]

--[[
 * Changelog:
 * v1.0 (2018-04-26)
  + Initial release
--]]

script_title = "ASM [ENV] Set new value for selected automation points _underlying envelope"

function myRound(num, idp)--convert numbers
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

------------------selected envelop userdata------------------
envelop_sel = reaper.GetSelectedEnvelope(0)
if not envelop_sel then reaper.defer(function() end) return end
-------------------------------------------------------------

-----------------how many points in envelope---------------
count_ePoints = reaper.CountEnvelopePoints(envelop_sel)
if count_ePoints < 1 then reaper.defer(function() end) return end
-------------------------------------------------------------

------------------how many selected points------------------
--------------------get lower pointvalue--------------------
count_sel_ePoint = 0
pValue_low = ''
numbDot = 3 --numbers after dot

for p = 0, count_ePoints - 1 do

    p1, ePoint_time, get_pValue_low, p4, p5, ePoint_sel = reaper.GetEnvelopePoint(envelop_sel, p)
    
    if ePoint_sel then
      
      if pValue_low == '' then
        
        pValue_low = get_pValue_low
          
      end
      
      if get_pValue_low < pValue_low then
        
        pValue_low = get_pValue_low
          
      end
      
      
      count_sel_ePoint = count_sel_ePoint + 1 
      
    end
    
    
end
-------------------------------------------------------------

pValue_low = myRound(pValue_low, numbDot)
 
retval, new_user_value = reaper.GetUserInputs("Set new point value", 1, "Value:", pValue_low) --Get users new value

new_user_value = myRound(new_user_value, numbDot)


for i = 0, count_ePoints - 1 do

    p1, ePoint_time, pValue, p4, p5, ePoint_sel = reaper.GetEnvelopePoint(envelop_sel, i)
    
    pValue = myRound(pValue, numbDot)
    
    dif_new_value = pValue_low - new_user_value
    
    new_value = pValue - dif_new_value

    ePoint_num = reaper.GetEnvelopePointByTime(envelop_sel, ePoint_time)

    if ePoint_sel then
    
      reaper.SetEnvelopePoint(envelop_sel, i, ePoint_time_last, new_value, nil, nil, nil, 1) --Set new value
        
    end

end
      
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

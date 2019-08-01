--[[
 * ReaScript Name: ASM [ENV] Set new value for selected automation points _automation items
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

script_title = "ASM [ENV] Set new value for selected automation points _automation items"

function myRound(num, idp)--convert numbers
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

------------------selected envelop userdata------------------
envelop_sel = reaper.GetSelectedEnvelope(0)
if not envelop_sel then goto END end --Cheker
-------------------------------------------------------------

------------------how many items in envelope------------------
count_eItems = reaper.CountAutomationItems(envelop_sel)
if count_eItems < 1 then goto END end --Cheker
-------------------------------------------------------------

------------------get Min and Max envelope values------------------
br_env = reaper.BR_EnvAlloc(envelop_sel, false)
active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, envType, faderScaling = reaper.BR_EnvGetProperties(br_env)--, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
-------------------------------------------------------------

count_sel_ePoint_Ex = 0
pValue_low_prev_Ex = ''
pValue_low = ''
numbDot = 3 --numbers after dot

for sel_aItems = 0, count_eItems - 1 do

  -----------------how many points in envelope---------------
  count_ePoints = reaper.CountEnvelopePointsEx(envelop_sel, sel_aItems)
  if count_ePoints < 1 then goto END end --Cheker
  -------------------------------------------------------------

  ------------------how many selected points------------------
  --------------------get lower pointvalue--------------------
  count_sel_ePoint = 0
  
  for p = 0, count_ePoints - 1 do
  
      p1, ePoint_time, get_pValue_low, p4, p5, ePoint_sel = reaper.GetEnvelopePointEx(envelop_sel, sel_aItems, p)
      
      reaper.Envelope_SortPointsEx(envelop_sel, sel_aItems)
      
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
  
  
  count_sel_ePoint_Ex = count_sel_ePoint_Ex + count_sel_ePoint
  
  -------------------------------------------------------------

end



  -------------------------------------------------------------
  -------------------------Main Part---------------------------
  -------------------------------------------------------------

if count_sel_ePoint_Ex < 1 then goto END end --Cheker

pValue_low = myRound(pValue_low, numbDot)
  
retval, new_user_value = reaper.GetUserInputs("Set new point value", 1, "Value:", pValue_low) --Get users new value

new_user_value = myRound(new_user_value, numbDot)
  

for sel_aItems = 0, count_eItems - 1 do

  for i = 0, count_ePoints - 1 do

    p1, ePoint_time, pValue, p4, p5, ePoint_sel = reaper.GetEnvelopePointEx(envelop_sel, sel_aItems, i)

    pValue = myRound(pValue, numbDot)
    
    dif_new_value = pValue_low - new_user_value
    
    new_value = pValue - dif_new_value

    ePoint_num = reaper.GetEnvelopePointByTimeEx(envelop_sel, sel_aItems, ePoint_time)

    if ePoint_sel then
      
      new_value = myRound(new_value, numbDot)
      
      if new_value <= minValue then

        new_value = minValue

      end

      if new_value >= maxValue then

        new_value = maxValue
        
      end
      
      reaper.SetEnvelopePointEx(envelop_sel, sel_aItems, i, ePoint_time_last, new_value, nil, nil, nil, 1) --Set new value
      reaper.Envelope_SortPointsEx(envelop_sel, sel_aItems) --Sort points by time (need for buggy "SetEnvelopePointEx")
        
    end
  
  end

end
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)

::END::

reaper.UpdateArrange()


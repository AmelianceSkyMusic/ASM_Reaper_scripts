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
 * v1.0.1 (2018-04-27)
  + Added full support for Volume, Volume (Pre-Fx), Trim Volume envelopes
  + Added full support for Mute envelope
  + Added hints for some envelopes in the input window
--]]

script_title = "ASM [ENV] Set new value for selected automation points _automation items"

--------------------------------------------------->>>>>>>>--
---------------------service functions------------->>>>>>>>--
--------------------------------------------------->>>>>>>>--

function Msg(param) reaper.ShowConsoleMsg(tostring(param).."\n") end
reaper.ShowConsoleMsg("")

function cutFloatTo(num, idp) --function that does not round a but truncates fractional numbers
  idp = (10^idp)
  intNum,remNum = math.modf(num)
  remNum = math.modf(remNum*idp)/idp
  newNum = intNum + remNum
  return newNum
end

function roundFloatTo(num, idp) --function that round a but truncates fractional numbers
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function test_and_convert_value(get_value) --test envelope and convert values
--Msg('pValue_low'..pValue_low)
  if envType == 0 or envType == 1 then --Volume, Volume (Pre-Fx), Trim Volume - Envelope
    get_value = 20 * ( math.log(get_value, 10 ) )
    --new_volume = math.exp((item_voldb+1) * 0.115129254)
    new_func_value = roundFloatTo(get_value, 2)
    minValue = -100.0
    maxValue = 0
    env_mod_min_text = minValue
    input_text_value = 'Value '..env_mod_min_text..' to '..env_mod_max_text..' :'
    
  --elseif envType == 2 or envType == 3 then -- Pan, Pan (Pre-Fx) - Envelope
    
  elseif envType == 4 or envType == 5 then -- Width, Width (Pre-Fx) - Envelope
    get_value = get_value * 100
    new_func_value = cutFloatTo(get_value, 0)
    input_text_value = 'Value '..env_mod_min_text..' to '..env_mod_max_text..' :'
    
  elseif envType == 6 then --Mute - Envelop
    new_func_value = cutFloatTo(get_value, 0)
    input_text_value = 'Value (1 - mute, 0 - unmete):'
    
  else --others - Envelope
    --get_value = get_value * 0,0078740157480315
    new_func_value = roundFloatTo(get_value, 2)
    input_text_value = 'Value '..env_mod_min_text..' to '..env_mod_max_text..' :' 
    pValue_low_text = pValue_low 
  end

  return new_func_value

end
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------

--------------------------------------------------->>>>>>>>--
------------------selected envelop userdata-------->>>>>>>>--
--------------------------------------------------->>>>>>>>--
envelop_sel = reaper.GetSelectedEnvelope(0) --get id for selected envelope
if not envelop_sel then goto END end --Cheker
-------------------------------------------------------------
count_eItems = reaper.CountAutomationItems(envelop_sel) --how many items is in envelope
if count_eItems < 1 then goto END end --Cheker
-------------------------------------------------------------
br_env = reaper.BR_EnvAlloc(envelop_sel, false) --for BR_EnvGetProperties
active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, envType, faderScaling = reaper.BR_EnvGetProperties(br_env)--, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
-------------------------------------------------------------
env_mod_min_text = reaper.Envelope_FormatValue(envelop_sel, minValue) --text max and min envelope values for input area
env_mod_max_text = reaper.Envelope_FormatValue(envelop_sel, maxValue)
-------------------------------------------------------------
test_and_convert_value(minValue) --test and convert max and min envelope value for checker
test_and_convert_value(maxValue)
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------

--[[Msg(envType)
Msg(minValue)
Msg(maxValue)
Msg('\n')
Msg(env_mod_min_text)
Msg(env_mod_max_text)
Msg('\n')]]--

--------------------------------------------------->>>>>>>>--
------------------how many selected points--------->>>>>>>>--
-------------------get lower point value----------->>>>>>>>--
--------------------------------------------------->>>>>>>>--
count_sel_ePoint_Ex = 0 -- some varibles
pValue_low_prev_Ex = ''
pValue_low = ''
ePoint_time_low = ''
for sel_aItems = 0, count_eItems - 1 do
  -----------------how many points in envelope---------------
  count_ePoints = reaper.CountEnvelopePointsEx(envelop_sel, sel_aItems)
  if count_ePoints < 1 then goto END end --Cheker
  -------------------------------------------------------------
  count_sel_ePoint = 0
  for p = 0, count_ePoints - 1 do
      reaper.Envelope_SortPointsEx(envelop_sel, sel_aItems) --mast have stop bug
      p1, get_ePoint_time_low, get_pValue_low, p4, p5, ePoint_sel = reaper.GetEnvelopePointEx(envelop_sel, sel_aItems, p)
      if ePoint_sel then 
        if pValue_low == '' then
          pValue_low = get_pValue_low --get first selected value
          ePoint_time_low = get_ePoint_time_low --get first selected time
        end
        if get_pValue_low < pValue_low then 
          pValue_low = get_pValue_low --chage value if new value lower
          ePoint_time_low = get_ePoint_time_low --chage time if new value lower      
        end
        count_sel_ePoint = count_sel_ePoint + 1 --selected points counter for one item       
      end   
  end
  count_sel_ePoint_Ex = count_sel_ePoint_Ex + count_sel_ePoint --selected points counter for all item
end
------------------how many points in envelope----------------
if count_sel_ePoint_Ex < 1 then goto END end --Cheker
-------------------------------------------------------------
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------

--[[Msg('\n')
Msg('pValue_low '..pValue_low)
Msg('\n')]]--


--[[if pValue_low <= minValue then

  pValue_low = minValue

  elseif pValue_low >= maxValue then

  pValue_low = maxValue
    
  end]]

pValue_low = test_and_convert_value(pValue_low)
pValue_low_text = reaper.Envelope_FormatValue(envelop_sel, pValue_low)

retval, new_user_value = reaper.GetUserInputs("Set new point value", 1, input_text_value, pValue_low_text) --Get users new value
if retval == false then goto END end --Cheker

 --check and convert lower value


reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)
--------------------------------------------------->>>>>>>>--
----------------------MAIN ACTION PART------------->>>>>>>>--
--------------------------------------------------->>>>>>>>--
for sel_aItems = 0, count_eItems - 1 do

  for i = 0, count_ePoints - 1 do

    p1, ePoint_time, pValue, p4, p5, ePoint_sel = reaper.GetEnvelopePointEx(envelop_sel, sel_aItems, i)

    pValue = test_and_convert_value(pValue)
    
    
    dif_new_value = pValue_low - new_user_value
    
    --[[Msg('dif_new_value'..dif_new_value)
    Msg('pValue_low'..pValue_low)
    Msg('new_user_value'..new_user_value)]]--
    
    new_value = pValue - dif_new_value
    
    --[[Msg('new_value'..new_value)
    Msg('pValue'..pValue)
    Msg('dif_new_value'..dif_new_value..'\n')]]--

    ePoint_num = reaper.GetEnvelopePointByTimeEx(envelop_sel, sel_aItems, ePoint_time)

    if ePoint_sel then
      
      --new_value = test_and_convert_value(new_value)      
      
     if new_value <= minValue then

       new_value = minValue

      elseif new_value >= maxValue then

        new_value = maxValue
        
      end
            
      --Msg('0000000new_value'..new_value)
      
      
      if envType == 0 or envType == 1 then --Volume
       new_value = math.exp((new_value) * 0.115129254)
      elseif envType == 6 then  -- Mute
        new_value = new_user_value
      end
      
      reaper.SetEnvelopePointEx(envelop_sel, sel_aItems, i, ePoint_time_last, new_value, nil, nil, nil, 1) --Set new value
      reaper.Envelope_SortPointsEx(envelop_sel, sel_aItems) --Sort points by time (need for buggy "SetEnvelopePointEx")
        
    end
  
  end

end
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------
--<<<<<<<<---------------------------------------------------

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)

::END::

reaper.UpdateArrange()


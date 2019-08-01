--[[
 * ReaScript Name: ASM [NOTES] Set average velocity for selected notes in active take (with user window)
 * Instructions: Select notes(s) and Run.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: Set average velocity for selected notes in active take
--]]

--[[
 * Changelog:
 * v1.0 (2018-06-29)
  + Initial release
--]]

script_title = "ASM [NOTES] Set average velocity for selected notes in active take (with user window)"

function Msg(param) reaper.ShowConsoleMsg(tostring(param).."\n") end
reaper.ShowConsoleMsg("")

function roundFloatTo(num, idp) --function that round a but truncates fractional numbers
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

----------------------------------------------------
----------------------CHEKERS-----------------------
----------------------------------------------------
function cheker_nothing() end function cheker() reaper.defer(cheker_nothing) reaper.atexit(cheker_nothing) end

active = reaper.MIDIEditor_GetActive()
local take = reaper.MIDIEditor_GetTake(active)
if not take then cheker() return end
local _, notes = reaper.MIDI_CountEvts(take)
if notes <= 0 then cheker() return end

----------------------------------------------------
----------CREATE TABLE WITH SELECTED NOTES----------
----------------------------------------------------
count_tab = {}
count_tab_in = 1
for count = 0, notes-1 do
  local _, selected, _, _, _, _, _, _ = reaper.MIDI_GetNote(take, count)
  if selected then
    count_tab[count_tab_in] = count
    count_tab_in = count_tab_in + 1
  end
end
if #count_tab < 1 then cheker() return end

----------------------------------------------------
----------MIN/MAX/AVERAGE VALUE IN TABLE------------
----------------------------------------------------
function min_max_aver_value(tab)
  prev_max_value = 0
  prev_min_value = 127
  for key, value in pairs(tab) do
    max_value = math.max (value, prev_max_value)
    min_value = math.min (value, prev_min_value)
    prev_max_value = max_value
    prev_min_value = min_value
  end
  average_value = (min_value+max_value)/2
  return min_value, max_value, average_value
end


----------------------------------------------------
--------------CREATE TABLE WITH VALUES--------------
----------------------------------------------------
table = {}
for _ , j in pairs(count_tab) do
  local _, _, _, _, _, _, _, vel = reaper.MIDI_GetNote(take, j)
  table[j] = vel
end

----------------------------------------------------
--------------------USER WINDOW---------------------
----------------------------------------------------
min_val, max_val, average_val = min_max_aver_value (table) --get average value
new_avar_val = math.modf(roundFloatTo(tonumber(average_val), 0)) --convert and round value
new_min_val = math.modf(roundFloatTo(tonumber(min_val), 0)) --convert and round value
new_max_val = math.modf(roundFloatTo(tonumber(max_val), 0)) --convert and round value 

--new_avar_val, _ = math.modf (new_avar_val)
retval, new_user_val = reaper.GetUserInputs('Set new avarage value of velocity', 1, 'Min:'..new_min_val.. '; Max:'..new_max_val..'; Avarage:', new_avar_val) --Get users new value
if not retval then cheker() return end --Cheker

----------------------------------------------------
----------CREATE NEW NOTES WITH NEW VALUES----------
----------------------------------------------------
function main()
  for _ , i in pairs(count_tab) do
    new_user_val = roundFloatTo(tonumber(new_user_val), 0)
    local _, selected, mute, start_ppq_pos, end_ppq_pos, chan, pitch, _ = reaper.MIDI_GetNote(take, i)
    new_vel = roundFloatTo(tonumber(new_user_val), 0) --convert and round value
    reaper.MIDI_SetNote(take, i, selected, mute, start_ppq_pos, end_ppq_pos, chan, pitch, new_vel, 1)
  end
end

----------------------------------------------------
---------------------ACTION-------------------------
----------------------------------------------------

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

main()

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

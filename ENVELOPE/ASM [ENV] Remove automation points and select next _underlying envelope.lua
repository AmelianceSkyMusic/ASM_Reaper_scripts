--[[
 * ReaScript Name: ASM [ENV] Remove automation points and select next _underlying envelope
 * Instructions: Select some points in underlying (selected) envelope and Run.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: Remove automation points and select next without move edit cursor in underlying envelope
--]]

--[[
 * Changelog:
 * v1.0 (2018-04-26)
  + Initial release
--]]

script_title = "ASM [ENV] Remove automation points and select next _underlying envelope"

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

envelop_sel = reaper.GetSelectedEnvelope(0)
if not envelop_sel then reaper.defer(function() end) return end

count_ePoints = reaper.CountEnvelopePoints(envelop_sel)
if count_ePoints < 1 then reaper.defer(function() end) return end

count_sel_ePoint = 0
for p = 0, count_ePoints - 1 do
    p1, ePoint_time, p3, p4, p5, ePoint_sel = reaper.GetEnvelopePoint(envelop_sel, p)
    if ePoint_sel then
        count_sel_ePoint = count_sel_ePoint + 1   
    end
end
count_sel_ePoint_new = count_sel_ePoint

j=0
for i = 0, count_ePoints - 1 do
    i=i+j

    p1, ePoint_time, p3, p4, p5, ePoint_sel = reaper.GetEnvelopePoint(envelop_sel, i)

    ePoint_num = reaper.GetEnvelopePointByTime(envelop_sel, ePoint_time)


    if ePoint_sel then

        reaper.DeleteEnvelopePointRange(envelop_sel, ePoint_time, ePoint_time+0.00000000001)
            
        if count_sel_ePoint_new == 1 and i < (count_ePoints - count_sel_ePoint) then

            commandID = reaper.NamedCommandLookup("_BR_ENV_SEL_NEXT_POINT")
            reaper.Main_OnCommand(commandID, 0)

            p1, ePoint_time_last, ePoint_value_last, ePoint_shape_last, ePoint_tension_last, ePoint_sel_last = reaper.GetEnvelopePoint(envelop_sel, i)

            reaper.DeleteEnvelopePointRange(envelop_sel, ePoint_time_last, ePoint_time_last+0.00000000001)

        end

        count_sel_ePoint_new = count_sel_ePoint_new - 1

        j=j-1
        
    end

end

if ePoint_time_last ~= nil  then
    reaper.InsertEnvelopePoint(envelop_sel, ePoint_time_last, ePoint_value_last, ePoint_shape_last, ePoint_tension_last, 1, nill )
end

      
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, 0)

--[[
 * ReaScript Name: ASM [ENV] Remove automation items and select next
 * Instructions: Select automation items and Run.
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: Remove automation items and select next without move edit cursor
--]]

--[[
 * Changelog:
 * v1.0 (2018-04-26)
  + Initial release
--]]

script_title = "ASM [ENV] Remove automation items and select next"

function Msg(param) reaper.ShowConsoleMsg(tostring(param).."\n") end
  
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

--selected envelop userdata
envelop_sel = reaper.GetSelectedEnvelope(0)
if not envelop_sel then reaper.defer(function() end) return end

--how many items in envelope
count_eItems = reaper.CountAutomationItems(envelop_sel)
if count_eItems < 1 then reaper.defer(function() end) return end

for i = 0, count_eItems - 1 do

    eItem_sel = reaper.GetSetAutomationItemInfo(envelop_sel, i, 'D_UISEL', 0, false)

    if eItem_sel == 1 then

        eItem_start = reaper.GetSetAutomationItemInfo(envelop_sel, i, 'D_POSITION', 0, false)

        eItem_len = reaper.GetSetAutomationItemInfo(envelop_sel, i, 'D_LENGTH', 0, false)

        eItem_end = eItem_start + eItem_len

        reaper.Main_OnCommand(42086, 0)
        
        count_eItems_new = reaper.CountAutomationItems(envelop_sel)

        last_sel_eItem = i

    end

end


if last_sel_eItem == nil then reaper.defer(function() end) return end

reaper.GetSetAutomationItemInfo(envelop_sel, last_sel_eItem, 'D_UISEL', 1, true)    
   
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

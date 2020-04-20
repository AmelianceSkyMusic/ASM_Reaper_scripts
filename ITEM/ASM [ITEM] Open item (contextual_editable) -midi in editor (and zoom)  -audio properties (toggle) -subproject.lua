--[[
 * ReaScript Name: ASM [ITEM] Open item (contextual/editable): midi in editor (and zoom) / audio properties (toggle) / subproject
 * Instructions:  Use in mouse modifiers. You can change actions in USER DATA part
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.2
 * Description: Use in mouse modifiers. You can change actions in USER DATA part
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-04-24)
  + Initial release
 * v1.0.1 (2020-04-04)
  + Some fixes
 * v1.0.2 (2020-04-20)
  + Some fixes
--]]
----------------------------------------------------------------------
----------------------------USER DATA---------------------------------
----------------------------------------------------------------------

-- Script: sr_Open MIDI editor and zoom to content.lua:
local midi_action = '_RS84074b5fb92a906b135f993286a2bfb5f7bc86bd'
-- Change section type from 'MAIN' to 'MIDI' if you get command ID from MIDI Editor selection
local midi_action_section = 'MIDI'

-- Item properties: Toggle show media item/take properties:
local audio_action = '41589'

-- Item: Open items in primary external editor:
local subproject_action = '40109'
 
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

 
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

script_title = "ASM [ITEM] Open item (contextual/editable): midi in editor (and zoom) / audio properties (toggle) / subproject"
proj = 0
local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."asm"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."io"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."math"..".lua")
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."other"..".lua")
--dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."table"..".lua")
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------


function MAIN()
  local item_data = reaper.BR_ItemAtMouseCursor()
  
  if item_data ~= nil then
    reaper.SelectAllMediaItems(proj, 0)
    reaper.SetMediaItemInfo_Value(item_data, 'B_UISEL', 1)
    item_type = asm.getItemType(item_data)
    
    if item_type == 'MIDI' then
      asm.doCmdID(midi_action, midi_action_section)
    ----------------------------------------------------------------------  
    elseif item_type == 'AUDIO' then
      asm.doCmdID(audio_action, 'MAIN')
    ----------------------------------------------------------------------
    elseif item_type == 'SUBPROJECT' then
      asm.doCmdID(subproject_action, 'MAIN')
    ----------------------------------------------------------------------  
    end
  end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

MAIN()

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

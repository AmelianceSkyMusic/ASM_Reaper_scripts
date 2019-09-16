--[[
 * ReaScript Name: ASM [ITEM] Glue (midi items only)
 * Instructions: Glue midi items only
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0.0
 * Description: Glue midi items only
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-09-16)
  + Initial release
--]]
----------------------------------------------------------------------
----------------------------USER DATA---------------------------------
----------------------------------------------------------------------

-- Item: Glue items
local midi_action = '41588'
 
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

 
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

script_title = "ASM [ITEM] Glue (midi items only)"
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

function glue_item(temp_item, temp_track)
  
  if temp_item ~= nil then
  
    item_type = asm.getItemType(temp_item)
    
    if item_type == 'MIDI' then
      asm.doCmdID(midi_action ,'MAIN') 
    end
  end

end

function MAIN()

  asm.doItems(_idx, 'SEL_ITEM', glue_item)
  
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
































--[[
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
function remove_item(temp_item, temp_track)
  reaper.DeleteTrackMediaItem(temp_track, temp_item)
end

function select_item(temp_item, temp_track)
  reaper.SetMediaItemSelected(temp_item, true)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
local function MAIN()
  
  asm.doItems(_idx, 'SEL_ITEM', glue_item)
  
end

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
]]--

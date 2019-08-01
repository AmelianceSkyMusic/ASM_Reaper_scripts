--[[
 * ReaScript Name: ASM [ITEM] Remove selected items and select next
 * Instructions:  Select item and run the script
 * Author: Rsay Uaie (Ameliance SkyMusic)
 * Author URI: https://forum.cockos.com/member.php?u=123975
 * Licence: GPL v3
 * REAPER: 5.0
 * Version: 1.0
 * Description: Remove selected items and select next
--]]

--[[
 * Changelog:
 * v1.0.0 (2019-01-29)
  + Initial release
--]]

function MAIN_remove_selected_items_and_select_next()

  script_title = "ASM [ITEM] Remove selected items and select next"
  
  function Msg(param) reaper.ShowConsoleMsg(tostring(param).."\n") end
  reaper.ClearConsole()
  
  local count_sel_items = reaper.CountSelectedMediaItems()
  if count_sel_items <1 then return end
  
  local delete_tab = {}
  local select_tab = {}
  local temp_parent_track_start = reaper.GetMediaItem_Track(reaper.GetSelectedMediaItem(0, 0))
  local j = 1
  
  for i = 0, count_sel_items - 1 do
    local selected_item = reaper.GetSelectedMediaItem(0, i)
    local parent_track = reaper.GetMediaItem_Track(selected_item)
    local temp_item_number = reaper.GetMediaItemInfo_Value(selected_item, 'IP_ITEMNUMBER')
    local temp_selected_item = reaper.GetTrackMediaItem(parent_track, temp_item_number+1)
    if parent_track == temp_parent_track_start then
      select_tab[j] = temp_selected_item
    elseif parent_track ~= temp_parent_track_start then
      j = j + 1
      select_tab[j] = temp_selected_item
      temp_parent_track_star = parent_track
    end
    delete_tab[i+1] = {selected_item, parent_track}
  end
  
  
  reaper.Undo_BeginBlock() reaper.PreventUIRefresh(1) --------------------------------------------
  
  for i = 0, count_sel_items - 1 do
    local temp_item = delete_tab[i+1][1]
    local temp_track = delete_tab[i+1][2]
    reaper.DeleteTrackMediaItem(temp_track, temp_item)
  end
  
  for i = 0, #select_tab-1 do
      local temp_item_sel = select_tab[i+1]
      reaper.SetMediaItemSelected(temp_item_sel, true)
  end
  
  reaper.PreventUIRefresh(-1) reaper.Undo_EndBlock(script_title, -1) ------------------------------
  reaper.UpdateArrange()

end

MAIN_remove_selected_items_and_select_next()

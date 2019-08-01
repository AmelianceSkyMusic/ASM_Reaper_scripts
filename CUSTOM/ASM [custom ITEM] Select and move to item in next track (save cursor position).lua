script_title = 'ASM [custom ITEM] Select and move to item in previous track (save cursor position)'

local info = debug.getinfo(1,'S')
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "../_libraries/".."/ASM [_LIBRARY] ".."asm"..".lua")

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

asm.doCmdID('_BR_SAVE_CURSOR_POS_SLOT_1', 'MAIN') --SWS/BR: Save edit cursor position, slot 01
asm.doCmdID('40419', 'MAIN') --Item navigation: Select and move to item in next track
asm.doCmdID('_BR_RESTORE_CURSOR_POS_SLOT_1', 'MAIN') --Item navigation: Select and move to item in previous track

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
reaper.UpdateArrange()

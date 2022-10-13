TV_GetItemText(pItem) {                                                                                            	;-- retrieves the text/name of the specified treeview node +

/*    	DESCRIPTION

	Link: 			https://autohotkey.com/boards/viewtopic.php?t=4998
	Author: 		just me
	Method: 		GetText
						Retrieves the text/name of the specified node
	Parameters: pItem         - Handle to the item
	Returns: 		The text/name of the specified Item. If the text is longer than 127, only the first 127 characters are retrieved.

*/

TVM_GETITEM := A_IsUnicode ? TVM_GETITEMW : TVM_GETITEMA

WinGet ProcessId, pid, % "ahk_id " this.TVHnd
hProcess := OpenProcess(PROCESS_VM_OPERATION|PROCESS_VM_READ
					   |PROCESS_VM_WRITE|PROCESS_QUERY_INFORMATION
					   , false, ProcessId)

; Size := 28 + 3 * A_PtrSize      ; Size of a TVITEM structure
Size := 40 + 5 * A_PtrSize      ; Size of a TVITEMEX structure

_tvi := VirtualAllocEx(hProcess, 0, Size, MEM_COMMIT, PAGE_READWRITE)
_txt := VirtualAllocEx(hProcess, 0, 256,  MEM_COMMIT, PAGE_READWRITE)

; TVITEMEX Structure
VarSetCapacity(tvi, Size, 0)
NumPut(TVIF_TEXT|TVIF_HANDLE, tvi, 0, "UInt")
; NumPut(pItem, tvi, 4, "Ptr")
NumPut(pItem, tvi, A_PtrSize, "Ptr")
; NumPut(_txt, tvi, 12 + A_PtrSize, "Ptr")
NumPut(_txt, tvi, 8 + (A_PtrSize * 2), "Ptr")
; NumPut(127, tvi, 12 + 2 * A_PtrSize, "Uint")
NumPut(127, tvi, 8 + (A_PtrSize * 3), "Uint")

VarSetCapacity(txt, 256, 0)
WriteProcessMemory(hProcess, _tvi, &tvi, Size)
SendMessage TVM_GETITEM, 0, _tvi, ,  % "ahk_id " this.TVHnd
ReadProcessMemory(hProcess, _txt, txt, 256)

VirtualFreeEx(hProcess, _txt, 0, MEM_RELEASE)
VirtualFreeEx(hProcess, _tvi, 0, MEM_RELEASE)
CloseHandle(hProcess)

return txt
}
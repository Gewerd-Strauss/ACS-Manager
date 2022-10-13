LV_SetCheckState(hLV,p_Item,p_Checked) {                                                                	;-- check (add check mark to) or uncheck (remove the check mark from) an item in the ListView control
/*                              	DESCRIPTION

Function: 								LVM_SetCheckState

Description:						   Check (add check mark to) or uncheck (remove the check mark from) an item in
											the ListView control.

Parameters:						   p_Item - Zero-based index of the item.  Set to -1 to change all items.
											p_Checked - Set to TRUE to check item FALSE to uncheck.

Returns:								   TRUE if successful, otherwise FALSE.

Calls To Other Functions:		 * <LVM_SetItemState>

Remarks:									 * This function should only be used on a ListView control with the
											LVS_EX_CHECKBOXES style.
											* This function emulates the ListView_SetCheckState macro.

From:										jballi

Link:											https://autohotkey.com/board/topic/86149-checkuncheck-checkbox-in-listview-using-sendmessage/
*/

Static LVIS_UNCHECKED     :=0x1000
,LVIS_CHECKED       :=0x2000
,LVIS_STATEIMAGEMASK:=0xF000

Return LVM_SetItemState(hLV,p_Item,p_Checked ? LVIS_CHECKED:LVIS_UNCHECKED,LVIS_STATEIMAGEMASK)
}
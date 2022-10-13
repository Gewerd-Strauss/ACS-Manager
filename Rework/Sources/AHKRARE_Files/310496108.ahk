LV_IsChecked( lvhwnd, nRow ) {                                                                                  	;-- alternate method to find out if a particular row number is checked
;https://autohotkey.com/docs/commands/ListView.htm#ColN
SendMessage, 4140, nRow - 1, 0xF000, ahk_id %lvhwnd%  	; 4140 is LVM_GETITEMSTATE. 0xF000 is LVIS_STATEIMAGEMASK.
IsChecked := (ErrorLevel >> 12) - 1                                 	; This sets IsChecked to true if RowNumber is checked or false otherwise.
return IsChecked
}
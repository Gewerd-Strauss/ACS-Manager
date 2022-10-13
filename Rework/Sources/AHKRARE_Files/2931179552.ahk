LV_MoveRow(moveup = true) {																						;-- the same like above, but slightly different. With integrated script example.
; Original by diebagger (Guest) from:
; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
; Slightly Modifyed by Obi-Wahn
; http://ahkscript.org/germans/forums/viewtopic.php?t=7285
If moveup not in 1,0
Return   ; If direction not up or down (true or false)
while x := LV_GetNext(x)   ; Get selected lines
i := A_Index, i%i% := x
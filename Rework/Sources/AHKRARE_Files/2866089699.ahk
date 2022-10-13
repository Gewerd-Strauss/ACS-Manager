LV_GetCheckedItems(cN,wN) {																						;-- Returns a list of checked items from a standard ListView Control
;https://gist.github.com/TLMcode/4757894
ControlGet, LVItems, List,, % cN, % wN
Item:=Object()
While Pos
Pos:=RegExMatch(LVItems,"`am)(^.*?$)",_,!Pos?(Pos:=1):Pos+StrLen(_)),mCnt:=A_Index-1,Item[mCnt]:=_1
Loop % mCnt {
SendMessage, 0x102c, A_Index-1, 0x2000, % cN, % wN
ChkItems.=(ErrorLevel ? Item[A_Index-1] "`n" : "")
}
Return ChkItems
}
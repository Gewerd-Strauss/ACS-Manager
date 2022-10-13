GetComboBoxChoice(TheList, TheCurrent) {																	;-- Combobox function
	; https://github.com/altbdoor/ahk-hs-chara/blob/master/utility.ahk
	TheValue := -1

	Loop % TheList.Length() {
		If (TheCurrent == TheList[A_Index]) {
			TheValue := A_Index
			Break
		}
	}
	TheList := JoinArray(TheList, "|")

	Return {"Index": TheValue, "Choices": TheList}
}
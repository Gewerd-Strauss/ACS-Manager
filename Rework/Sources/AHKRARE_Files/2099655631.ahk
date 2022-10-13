MouseDpi(mode_speed:=0) {                                                                                      	;-- Change the current dpi setting of the mouse

	; https://github.com/Lateralus138/OnTheFlyDpi/blob/master/ontheflydpi_funcs.ahk
	DllCall("SystemParametersInfo","UInt",0x70,"UInt",0,"UIntP",_current_,"UInt",0)
	If mode_speed Is Not Number
		{
			If (InStr(mode_speed,"reset") And (_current_!=10)){
                DllCall("SystemParametersInfo","UInt",0x71,"UInt",0,"UInt",10,"UInt",0)
                DllCall("SystemParametersInfo","UInt",0x70,"UInt",0,"UIntP",_current_,"UInt",0)
			}
			Return _current_
		}
	mode_speed	:=(mode_speed!=0 And mode_speed>20)?20
                :(mode_speed!=0 And mode_speed<0)?1
                :mode_speed
	If (mode_speed!=0 And (_current_!=mode_speed))
		DllCall("SystemParametersInfo","UInt",0x71,"UInt",0,"UInt",mode_speed,"UInt",0)
	Return !mode_speed?_current_:mode_speed
}
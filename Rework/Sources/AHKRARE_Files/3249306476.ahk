DisableMinimizeAnim(disable) {                                                                              	;-- disables or restores original minimize anim setting

	static original,lastcall
	if (disable && !lastcall) ;Backup original value if disabled is called the first time after a restore call
	{
		lastcall := 1
		RegRead, original, HKCU, Control Panel\Desktop\WindowMetrics , MinAnimate
	}
	else if (!disable) ;this is a restore call, on next disable backup may be created again
		lastcall := 0
	;Disable Minimize/Restore animation
	VarSetCapacity(struct, 8, 0)
	NumPut(8, struct, 0, "UInt")
	if (disable || !original)
		NumPut(0, struct, 4, "Int")
	else
		NumPut(1, struct, 4, "UInt")
	DllCall("SystemParametersInfo", "UINT", 0x0049,"UINT", 8,"Ptr", &struct,"UINT", 0x0003) ;SPI_SETANIMATION            0x0049 SPIF_SENDWININICHANGE 0x0002
}
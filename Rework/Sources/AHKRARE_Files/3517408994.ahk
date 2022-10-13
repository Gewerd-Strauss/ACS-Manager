DPIFactor() {                                                                                                            	;-- determines the Windows setting to the current DPI factor

	RegRead, DPI_value, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
	; the reg key was not found - it means default settings
	; 96 is the default font size se
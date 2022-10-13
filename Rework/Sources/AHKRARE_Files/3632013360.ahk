BlockKeyboard(block=-1) {                                                         	;-- block keyboard, and unblock it through usage of keyboard

	;Thanks to Lexikos
	 ; -1, true or false.

	static hHook = 0, cb = 0
	if !cb ; register callback once only.
		cb := RegisterCallback("BlockKeyboardProc","Fast")
	if (block = -1) ; toggle
		block := (hHook=0)
	if ( (hHook!=0) = (block!=0) ) ; already (un)blocked, no action necessary.
		return
	if (block)
		{
		hHook := DllCall("SetWindowsHookEx"
		, "int", 13 ; WH_KEYBOARD_LL
		, "uint", cb ; lpfn (callback)
		, "uint", 0 ; hMod (NULL)
		, "uint", 0) ; dwThreadId (all threads)
		}
	else
		{
		DllCall("UnhookWindowsHookEx", "uint", hHook)
		hHook = 0
		}
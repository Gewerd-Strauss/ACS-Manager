IsClosed(win, wait) {																										;-- AHK function (WinWaitClose) wrapper

	WinWaitClose, ahk_id %win%,, %wait%
	return ((ErrorLevel = 1) ? False : True)
}
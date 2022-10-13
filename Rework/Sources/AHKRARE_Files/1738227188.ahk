enumChildCallback(hwnd, pid) {                                                                                 	;-- i think this retreave's the child process ID for a known gui hwnd and the main process ID
	DllCall("GetWindowThreadProcessId", "Int", hwnd, "int*", child_pid)
	if (child_pid != pid)
		global true_pid := child_pid
	return 1
}
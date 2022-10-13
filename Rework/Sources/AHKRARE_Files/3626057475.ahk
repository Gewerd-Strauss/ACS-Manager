EnumWindows(hWnd := 0, HiddenWindows := true, Flags := "") {								;-- Get a list with all the top-level windows on the screen or controls in the window

	/*                              	DESCRIPTION

			Get a list with all the top-level windows on the screen or controls in the window
			Syntax: 						EnumWindows ([hWnd], [HiddenWindows], [Flags])
			---------------------------- Parameters -------------------------
			hWnd:	 						specify the hWnd of a window to get a list with all its controls
			HiddenWindows: 		set false to not recover hidden windows. by default it obtains all the windows.
			Flags: 							additional filter options. Specify an object with one or more of the following keys and their respective value.
												ProcessPath = 			specify the path of the file to which the process belongs.
												ProcessName = 			specify the name of the file to which the process belongs.
												WindowClass = 			class of the window.
												WindowTitle = 			title of the window.
												ProcessId = 				PID of the window process.
			 Return: 						returns an array with all hWnds
			------------------------------ Notes -----------------------------
			in WIN_8  only the top-level windows of desktop applications are retrieved.
			When using the 3rd parameter, when checking strings such as WindowClass, WindowTitle, it is not case sensitive, use StringCaseSense to change this.
			Example: get a list with all the windows whose path of the executable file matches explorer.exe
	       	-------------------------------------------------------------------

	EnumAddress := RegisterCallback("EnumWindowsProc", "Fast", 2)
	, _gethwnd(hWnd), Data := {List: [], HiddenWindows: HiddenWindows, Flags: Flags}
	, DllCall("User32.dll\EnumChildWindows", "Ptr", hWnd, "Ptr", EnumAddress, "Ptr", &Data)
	return Data.List, GlobalFree(EnumAddress)
} EnumWindowsProc(hWnd, Data) { ;https://msdn.microsoft.com/en-us/library/windows/desktop/ms633494(v=vs.85).aspx
	if !(Data := Object(Data)) || ((Data.HiddenWindows = 0) && !WinVisible(hWnd))
		return true
	if IsObject(Data.Flags) {
		if Data.Flags.HasKey("WindowTitle") && (GetWindowTitle(hWnd) != Data.Flags.WindowTitle)
			return true
		if Data.Flags.HasKey("WindowClass") && (GetWindowClass(hWnd) != Data.Flags.WindowClass)
			return true
		if Data.Flags.HasKey("ProcessPath") || Data.Flags.HasKey("ProcessId") || Data.Flags.HasKey("ProcessName") {
			GetWindowThreadProcessId(hWnd, ProcessId)
			if Data.Flags.HasKey("ProcessPath") || Data.Flags.HasKey("ProcessName") {
				ProcessPath := GetModuleFileName("/" ProcessId)
				if Data.Flags.HasKey("ProcessPath") && (ProcessPath != Data.Flags.ProcessPath)
					return true
				if Data.Flags.HasKey("ProcessName") {
					SplitPath, ProcessPath, ProcessName
					if (ProcessName != Data.Flags.ProcessName)
						return true
			}	} if Data.Flags.HasKey("ProcessId") && (ProcessId != Data.Flags.ProcessId)
				return true
	}	} return true, Data.List.Push(hWnd)
}
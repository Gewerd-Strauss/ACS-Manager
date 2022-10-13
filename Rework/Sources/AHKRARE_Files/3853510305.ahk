GetFocusedControl()  {                                                                                            	;-- retrieves the ahk_id (HWND) of the active window's focused control.

        ; This script requires Windows 98+ or NT 4.0 SP3+.
        /*
        typedef struct tagGUITHREADINFO {
        DWORD cbSize;
        DWORD flags;
        HWND  hwndActive;
        HWND  hwndFocus;
        HWND  hwndCa
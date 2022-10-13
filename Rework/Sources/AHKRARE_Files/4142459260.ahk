CheckWindowStatus(hwnd, timeout=100) {																;-- check's if a window is responding or not responding (hung or crashed) -

 /* 									Description

					check's if a window is responding or not responding (hung or crashed)
					 timeout milliseconds to wait before deciding it is not responding - 100 ms seems reliable under 100% usage
					 WM_NULL =0x0000
					 SMTO_ABORTIFHUNG =0x0002
					;  * SendMessageTimeout values
					;
					; #define SMTO_NORMAL         0x0000
					; #define SMTO_BLOCK          0x0001
					; #define SMTO_ABORTIFHUNG    0x0002
					; #if (WINVER >= 0x0500)
					; #define SMTO_NOTIMEOUTIFNOTHUNG 0x0008
					; #endif /* WINVER >= 0x0500 */
					; #endif /* !NONCMESSAGES */
					;
					;
					; SendMessageTimeout(
					;     __in HWND hWnd,
					;     __in UINT Msg,
					;     __in WPARAM wParam,
					;     __in LPARAM lParam,
					;     __in UINT fuFlags,
					;     __in UINT uTimeout,
					;     __out_opt PDWORD_PTR lpdwResult);
*/

	NR_temp =0 ; init
	return DllCall("SendMessageTimeout", "UInt", hwnd, "UInt", 0x0000, "Int", 0, "Int", 0, "UInt", 0x0002, "UInt", TimeOut, "UInt *", NR_temp)
}
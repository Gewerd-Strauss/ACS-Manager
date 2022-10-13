IE_TabActivateByHandle(hwnd, tabName) {																;-- activates a tab by hwnd in InternetExplorer

	/*                              	DESCRIPTION

			Link: http://www.autohotkey.com/forum/topic37651.html&p=231093

	*/

   ControlGet, hTabUI , hWnd,, DirectUIHWND1, ahk_id %hwnd%
   Acc := Acc_ObjectFromWindow(hTabUI) ;// access "Tabs" control
   If (Acc.accChildCount > 1) ;// more than 1 tab
      tabs := Acc.accChild(3) ;// access just "IE document tabs"
   While (tabs.accChildCount >= A_Index) {
      tab :=
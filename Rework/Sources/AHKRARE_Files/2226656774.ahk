IE_TabWinID(tabName) {																								;-- find the HWND of an IE window with a given tab name

	/*                              	DESCRIPTION

			Link: https://autohotkey.com/board/topic/52685-winactivate-on-a-specific-ie-browser-tab

	*/
   WinGet, winList, List, ahk_class IEFrame
   While, winList%A_Index% {
      n:=A_Index, ErrorLevel:=0
      While, !ErrorLevel {
         ControlGetText, tabText, TabWindowClass%A_Index%, % "ahk_id" winList%n%
         if InStr(tabText, tabName)
            return, winList%n%
      }
   }
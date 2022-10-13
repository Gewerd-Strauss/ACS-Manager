WinWaitCreated( WinTitle:="", WinText:="", Seconds:=0, 											;-- Wait for a window to be created, returns 0 on timeout and ahk_id otherwise
ExcludeTitle:="", ExcludeText:="" ) {

	/*                              	DESCRIPTION

			Wait for a window to be created, returns 0 on timeout and ahk_id otherwise
			Parameter are the same as WinWait, see http://ahkscript.org/docs/commands/WinWait.htm
			Link: 					http://ahkscript.org/boards/viewtopic.php?f=6&t=1274&p=8517#p8517
			Dependencies: 	none

	*/
    ; HotKeyIt - http://ahkscript.org/boards/viewtopic.php?t=1274
    static Found := 0, _WinTitle, _WinText, _ExcludeTitle, _ExcludeText
         , init := DllCall( "RegisterShellHookWindow", "UInt",A_ScriptHwnd )
         , MsgNum := DllCall( "RegisterWindowMessage", "Str","SHELLHOOK" )
         , cleanup:={base:{__Delete:"WinWaitCreated"}}
  If IsObject(WinTitle)   ; cleanup
    return DllCall("DeregisterShellHookWindow","PTR",A_ScriptHwnd)
  else if (Seconds <> MsgNum){ ; User called the function
    Start := A_TickCount, _WinTitle := WinTitle, _WinText := WinText
    ,_ExcludeTitle := ExcludeTitle, _ExcludeText := ExcludeText
    ,OnMessage( MsgNum, A_ThisFunc ),  Found := 0
    While ( !Found && ( !Seconds || Seconds * 1000 < A_TickCount - Start ) )
      Sleep 16
    Return Found,OnMessage( MsgNum, "" )
  }
  If ( WinTitle = 1   ; window created, check if it is our window
    && ExcludeTitle = A_ScriptHwnd
    && WinExist( _WinTitle " ahk_id " WinText,_WinText,_ExcludeTitle,_ExcludeText))
    WinWait % "ahk_id " Found := WinText ; wait for window to be shown
}
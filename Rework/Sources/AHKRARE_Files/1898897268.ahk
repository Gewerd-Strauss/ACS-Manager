LoadScriptResource(ByRef Data, Name, Type = 10) {                                                 	;-- loads a resource into memory (e.g. picture, scripts..)

	;https://autohotkey.com/board/topic/77519-load-and-display-imagespng-jpg-with-loadscriptresource/

	/*	 example script demonstrates showing an icon image from the resource. It requires sample.ico with the size 64x64 in the script folder.

		#NoEnv
		SetWorkingDir %A_ScriptDir%

		if A_IsCompiled {
			If size := LoadScriptResource(buf,".\sample.ico")
                hIcon := HIconFromBuffer(buf, 64, 64)
			else MsgBox Resource could not be loaded!
		} else {
			FileRead, buf, *c %A_ScriptDir%\sample.ico
			hIcon := HIconFromBuffer(buf, 64, 64)
		}

		Gui, Margin, 20, 20
		Gui, Add, Picture, w64 h64 0x3 hWndPic1      	;0x3 = SS_ICon
		SendMessage, STM_SETICON := 0x0170, hIcon, 0,, ahk_id %Pic1%
		Gui, Show

		Return
		GuiClose:
		   Gui, Destroy
		   hIcon := hIcon := ""
		   ExitApp
		Return
	*/

	; originally posted by Lexikos, modified by HotKeyIt
	; http://www.autohotkey.com/forum/post-516086.html#516086

    lib := DllCall("GetModuleHandle", "ptr", 0, "ptr")
    res := DllCall("FindResource", "ptr", lib, "str", Name, "ptr", Type, "ptr")
    DataSize := DllCall("SizeofResource", "ptr", lib, "ptr", res, "uint")
    hresdata := DllCall("LoadResource", "ptr", lib, "ptr", res, "ptr")
    VarSetCapacity(Data, DataSize)
    DllCall("RtlMoveMemory", "PTR", &Data, "PTR", DllCall("LockResource", "ptr", hresdata, "ptr"), "UInt", DataSize)
    return DataSize
}
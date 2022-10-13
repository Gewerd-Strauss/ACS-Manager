getNextControl(winHwnd, controlName="", accName="", classNN="", accHelp="") {	;-- I'm not sure if this feature works could be an AHK code for the Control.GetNextControl method for System.Windows.Forms

	winget, list, controllisthwnd, ahk_id %winHwnd%

	bufSize=1024
	winget, processID, pid, ahk_id %winHwnd%
	VarSetCapacity(var1,bufSize)
	getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )
	dwResult:=DllCall("GetWindowThreadProcessId", "UInt", winHwnd)
	hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID)
	otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")

	count=0
	;~ static hModule := DllCall("LoadLibrary", "Str", "oleacc", "Ptr")
	;~ static hModule2 := DllCall("LoadLibrary", "Str", "Kernel32", "Ptr")
	;~ static AccessibleObjectFromWindowProc := DllCall("GetProcAddress", Ptr, DllCall("GetModuleHandle", Str, "oleacc", "Ptr"), AStr, "AccessibleObjectFromWindow", "Ptr")
	;~ static ReadProcessMemoryProc:=DllCall("ReadProcessMemory", Ptr, DllCall("GetModuleHandle", Str, "Kernel32", "Ptr"), AStr, "AccessibleChildren", "Ptr")
	;~ msgbox % AccessibleObjectFromWindowProc
	;~ static idObject:=-4
	loop,parse,list,`n
	{
		SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%
        DllCall("ReadProcessMemory","UInt",hProcess,"UInt",otherMem,"Str",var1,"UInt",bufSize,"UInt *",0)

		;~ acc:=acc_objectfromwindow2(a_loopfield)

		;~ if !DllCall(AccessibleObjectFromWindowProc, "Ptr", a_loopfield, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)
			;~ acc:=ComObjEnwrap(9,pacc,1)
		;~ else
			;~ acc:=""
	;&&(accParentHwnd=""||acc_windowfromobject(acc.accParent)=accParentHwnd)
		if ((var1&&var1=controlName)&&(accName=""||(acc:=Acc_ObjectFromWindow(a_loopfield)).accName=accName)){
			WinGetClass,cl,ahk_id %a_loopfield%
			if (instr(cl,classNN)=1&&(accHelp=""||acc.accHelp=accHelp)) {
				ret:=a_loopfield
				break
			}
		}

		var1:=""
	}

    DllCall("VirtualFreeEx","Ptr", hProcess,"UInt",otherMem,"UInt", 0, "UInt", 0x8000)
	DllCall("CloseHandle","Ptr",hProcess)
	DllCall("FreeLibrary", "Ptr", hModule)
	return ret
}
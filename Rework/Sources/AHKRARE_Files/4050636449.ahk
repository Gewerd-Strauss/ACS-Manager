TaskList(delim:="|", getArray:=0, sort:=0) {		                                                            	;-- list all running tasks (no use of COM)

		;https://github.com/Lateralus138/Task-Lister

		d := delim
		s := 4096
		Process, Exist
		h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")
		DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)
		VarSetCapacity(ti, 16, 0)
		NumPut(1, ti, 0, "UInt")
		DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
		NumPut(luid, ti, 4, "Int64")
		NumPut(2, ti, 12, "UInt")
		r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
		DllCall("CloseHandle", "Ptr", t)
		DllCall("CloseHandle", "Ptr", h)
		hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")
		s := VarSetCapacity(a, s)
		c := 0
		DllCall("Psapi.dll\EnumProcesses", "Ptr", &a, "UInt", s, "UIntP", r)
		Loop, % r // 4
		{
		   id := NumGet(a, A_Index * 4, "UInt")
		   h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")
		   if !h
			  continue
		   VarSetCapacity(n, s, 0)
		   e := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
		   if !e
			  if e := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
                {
                	 SplitPath, n, n
                }
		   DllCall("CloseHandle", "Ptr", h)
		   if (n && e)
			  l .= n . d, c++
		}
		DllCall("FreeLibrary", "Ptr", hModule)
		l:=SubStr(l,1,StrLen(l)-1) " " ndir
		If getArray
			{
                proc:=!proc?Object():""
                Loop, Parse, l, |
                	proc.Push(A_LoopField)
			}
		If sort
			Sort, l, D%deli
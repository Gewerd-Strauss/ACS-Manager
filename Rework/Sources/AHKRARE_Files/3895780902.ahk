WatchDirectory(WatchFolder="", WatchSubDirs=true) {					                                                                    	;-- it's different from above not tested

	static
	local hDir, hEvent, r, Action, FileNameLen, pFileName, Restart, CurrentFolder, PointerFNI, option
	static nReadLen := 0, _SizeOf_FNI_:=65536
	If (Directory=""){
		Gosub, StopWatchingDirectories
		SetTimer,TimerDirectoryChanges,Off
	} else if (Directory=Chr(2) or IsFunc(Directory) or IsLabel(Directory)){
		Gosub, ReportDirectoryChanges
	} else {
		Loop % (DirIdx) {
			If InStr(Directory, Dir%A_Index%Path){
				If (Dir%A_Index%Subdirs)
					Return
			} else if InStr(Dir%A_Index%Path, Directory) {
				If (SubDirs){
					DllCall( "CloseHandle", UInt,Dir%A_Index% )
					DllCall( "CloseHandle", UInt,NumGet(Dir%A_Index%Overlapped, 16) )
					Restart := DirIdx, DirIdx := A_Index
				}
			}
		}
		If !Restart
			DirIdx += 1
		r:=DirIdx
		hDir := DllCall( "CreateFile"
					 , Str  , Directory
					 , UInt , ( FILE_LIST_DIRECTORY := 0x1 )
					 , UInt , ( FILE_SHARE_READ     := 0x1 )
							| ( FILE_SHARE_WRITE    := 0x2 )
							| ( FILE_SHARE_DELETE   := 0x4 )
					 , UInt , 0
					 , UInt , ( OPEN_EXISTING := 0x3 )
					 , UInt , ( FILE_FLAG_BACKUP_SEMANTICS := 0x2000000  )
							| ( FILE_FLAG_OVERLAPPED       := 0x40000000 )
					 , UInt , 0 )
		Dir%r%         := hDir
		Dir%r%Path     := Directory
		Dir%r%Subdirs  := SubDirs
		If (options!="")
			Loop,Parse,options,%A_Space%
				If (option:= SubStr(A_LoopField,1,1))
					Dir%r%%option%:= SubStr(A_LoopField,2)
		VarSetCapacity( Dir%r%FNI, _SizeOf_FNI_ )
		VarSetCapacity( Dir%r%Overlapped, 20, 0 )
		DllCall( "CloseHandle", UInt,hEvent )
		hEvent := DllCall( "CreateEvent", UInt,0, Int,true, Int,false, UInt,0 )
		NumPut( hEvent, Dir%r%Overlapped, 16 )
		if ( VarSetCapacity(DirEvents) < DirIdx*4 and VarSetCapacity(DirEvents, DirIdx*4 + 60))
			Loop %DirIdx%
			{
				If (SubStr(Dir%A_Index%Path,1,1)!="-"){
					action++
					NumPut( NumGet( Dir%action%Overlapped, 16 ), DirEvents, action*4-4 )
				}
			}
		NumPut( hEvent, DirEvents, DirIdx*4-4)
		Gosub, ReadDirectoryChanges
		If Restart
			DirIdx = %Restart%
		If (Dir%r%T!="")
			SetTimer,TimerDirectoryChanges,% Dir%r%T
	}
	Return
	TimerDirectoryChanges:
		WatchDirectory(Chr(2))
	Return
	ReportDirectoryChanges:
		r := DllCall("MsgWaitForMultipleObjectsEx", UInt, DirIdx, UInt, &DirEvents, UInt, -1, UInt, 0x4FF, UInt, 0x6) ;Timeout=-1
		if !(r >= 0 && r < DirIdx)
			Return
		r += 1
		CurrentFolder := Dir%r%Path
		PointerFNI := &Dir%r%FNI
		DllCall( "GetOverlappedResult", UInt, hDir, UInt, &Dir%r%Overlapped, UIntP, nReadLen, Int, true )
		Loop {
			pNext   	:= NumGet( PointerFNI + 0  )
			Action      := NumGet( PointerFNI + 4  )
			FileNameLen := NumGet( PointerFNI + 8  )
			pFileName :=       ( PointerFNI + 12 )
			If (Action < 0x6){
				VarSetCapacity( FileNameANSI, FileNameLen )
				DllCall( "WideCharToMultiByte",UInt,0,UInt,0,UInt,pFileName,UInt,FileNameLen,Str,FileNameANSI,UInt,FileNameLen,UInt,0,UInt,0)
				path:=CurrentFolder . (SubStr(CurrentFolder,0)="\" ? "" : "\") . SubStr( FileNameANSI, 1, FileNameLen/2 )
				SplitPath,path,,,EXT
				SplitPath,frompath,,,EXTFrom
				If ((FileExist(path) and InStr(FileExist(path),"D") and Dir%r%E!="" and Dir%r%E!="?") or (Dir%r%A!="" and !InStr(Dir%r%A, action)) or (FileExist(path) and !InStr(FileExist(path),"D") and Dir%r%E="?")){
					If (!pNext or pNext = 4129024)
						Break
					Else
						frompath:=path, PointerFNI := (PointerFNI + pNext)
					Continue
				}
				option:=Dir%r%E="" ? "|" : Dir%r%E
				Loop,Parse,option,.
					If (Dir%r%E="" or Dir%r%E="?" or Dir%r%E="*" or A_LoopField=EXT or A_LoopField=ExtFrom){
						If action in 2,3
							before:=path,after:=(action=3 ? path : "")
						else if action in 1,5
							before:=(action=5 ? frompath : ""),after:=path
						If (Directory and IsFunc(Directory))
							%Directory%(action,path)
						else if (action!=4){
							If IsFunc(Dir%r%F){
								F:=Dir%r%F
								%F%(before,after)
							}
						}
						If IsLabel(Dir%r%G){
								ErrorLevel:=action . "|" . path
								Gosub % Dir%r%G
							}
						break
					}
			}
			If (!pNext or pNext = 4129024)
				Break
			Else
				frompath:=path, PointerFNI := (PointerFNI + pNext)
		}
		DllCall( "ResetEvent", UInt,NumGet( Dir%r%Overlapped, 16 ) )
		Gosub, ReadDirectoryChanges
	Return
	StopWatchingDirectories:
		Loop % (DirIdx) {
			DllCall( "CloseHandle", UInt,Dir%A_Index% )
			DllCall( "CloseHandle", UInt,NumGet(Dir%A_Index%Overlapped, 16) )
			DllCall( "CloseHandle", UInt, NumGet(Dir%A_Index%Overlapped,16) )
			VarSetCapacity(Dir%A_Index%Overlapped,0)
			Dir%A_Index%=
			Dir%A_Index%Path=
			Dir%A_Index%Subdirs=
			Dir%A_Index%FNI=
		}
		DirIdx=
		VarSetCapacity(DirEvents,0)
	Return
	ReadDirectoryChanges:
		DllCall( "ReadDirectoryChangesW"
			, UInt , Dir%r%
			, UInt , &Dir%r%FNI
			, UInt , _SizeOf_FNI_
			, UInt , Dir%r%SubDirs
			, UInt , ( FILE_NOTIFY_CHANGE_FILE_NAME   := 0x1   )
					| ( FILE_NOTIFY_CHANGE_DIR_NAME    := 0x2   )
					| ( FILE_NOTIFY_CHANGE_ATTRIBUTES  := 0x4   )
					| ( FILE_NOTIFY_CHANGE_SIZE        := 0x8   )
					| ( FILE_NOTIFY_CHANGE_LAST_WRITE  := 0x10  )
					| ( FILE_NOTIFY_CHANGE_CREATION    := 0x40  )
					| ( FILE_NOTIFY_CHANGE_SECURITY    := 0x100 )
			, UInt , 0
			, UInt , &Dir%r%Overlapped
			, UInt , 0  )
	Return
}
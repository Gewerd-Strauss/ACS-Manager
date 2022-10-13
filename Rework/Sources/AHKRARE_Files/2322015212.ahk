GetCPA_file_name( p_hw_target ) {                                                                         	;-- retrieves Control Panel applet icon

   WinGet, pid_target, PID, ahk_id %p_hw_target%
   hp_target := DllCall( "OpenProcess", "uint", 0x18, "int", false, "uint", pid_target, "Ptr")
   hm_kernel32 := GetModuleHandle("kernel32.dll")
   pGetCommandLine := DllCall( "GetProcAddress", "Ptr", hm_kernel32, "Astr", A_IsUnicode ? "GetCommandLineW"  : "GetCommandLineA")
   buffer_size := 6
   VarSetCapacity( buffer, buffer_size )
   DllCall( "ReadProcessMemory", "Ptr", hp_target, "uint", pGetCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   loop, 4
      ppCommandLine += ( ( *( &buffer+A_Index ) ) << ( 8*( A_Index-1 ) ) )
   buffer_size := 4
   VarSetCapacity( buffer, buffer_size, 0 )
   DllCall( "ReadProcessMemory", "Ptr", hp_target, "uint", ppCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   loop, 4
      pCommandLine += ( ( *( &buffer+A_Index-1 ) ) << ( 8*( A_Index-1 ) ) )
   buffer_size := 260
   VarSetCapacity( buffer, buffer_size, 1 )
   DllCall( "ReadProcessMemory", "Ptr", hp_target, "uint", pCommandLine, "uint", &buffer, "uint", buffer_size, "uint", 0 )
   DllCall( "CloseHandle", "Ptr", hp_target )
   IfInString, buffer, desk.cpl ; exception to usual string format
     return, "C:\WINDOWS\system32\desk.cpl"

   ix_b := InStr( buffer, "Control_RunDLL" )+16
   ix_e := InStr( buffer, ".cpl", false, ix_b )+3
   StringMid, CPA_file_name, buffer, ix_b, ix_e-ix_b+1
   if ( ix_e )
      return, CPA_file_name
   else
      return, false
}
SetTrayIcon( Gui0=0 ) {                                                                                      	;-- sets a hex coded icon to as try icon
 Hex := "W1Y1Z10101X1Y4Z2801X16V28V1U2T1Y4RCKMFF9C9CZFFA2A2ZFFAAAAZFFB0BYFFB4B4ZFFBABAZFF"
 . "BFBFZFFC4C4ZFFCACAZFFD1D1ZFFD6D6ZFFDDDDZFFE4E4ZFFEBEBZFFFFFFKWBDVCEVADVCEV9DVCEV7BVCE"
 . "V5AVCDV37ABA988ACV246765458AV13V58V12V37V12V25V12V24V22V23KYFFFFXC3C3XC3C3XC3C3XC3C3X"
 . "C3C3XCZ3XCZ3XCZ3XCZ3XC3C3XC3C3XC3C3XC3C3XC3C3XFFFFX"
 VarSetCapacity(Z,512,48), Nums:="512|256|128|64|32|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2"
 Loop, Parse, Nums, |                                  ;  uncompressing nulls in hex data
  StringReplace,hex,hex,% Chr(70+A_Index),% SubStr(Z,1,A_LoopField),All
 VarSetCapacity( IconData,( nSize:=StrLen(Hex)//2) )
 Loop %nSize%
   NumPut( "0x" . SubStr(Hex,2*A_Index-1,2), IconData, A_Index-1, "Char" )
 hICon := DllCall( "CreateIconFromResourceEx", UInt,&IconData+22, UInt,0, Int,1
                   ,UInt,196608, Int,16, Int,16, UInt,0 )
 PID := DllCall("GetCurrentProcessId"), VarSetCapacity( NID,444,0 ), NumPut( 444,NID )
 NumPut( Gui0,NID,4 ), NumPut( 1028,NID,8 ), NumPut( 2,NID,12 ), NumPut( hIcon,NID,20 )
 Menu, Tray, Icon,,, 1
 DllCall( "shell32\Shell_NotifyIcon", UInt,0x1, UInt,&NID )
}
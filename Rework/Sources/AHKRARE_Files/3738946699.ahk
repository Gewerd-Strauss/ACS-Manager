LocalIps() {										            													;-- with small changes to HostToIP() this can be used to retrieve all LocalIP's
	/*                              	DESCRIPTION

			Link: https://autohotkey.com/board/topic/9051-host-to-ip-address-using-winsock-20-dll/

	*/

	 ; returns -1 if unsuccessfull or a newline seperated list of valid IP addresses on success
   VarSetCapacity(wsaData, 32)  ; The struct is only about 14 in size, so 32 is conservative.
   result := DllCall("Ws2_32\WSAStartup", "UShort", 0x0002, "UInt", &wsaData) ; Request Winsock 2.0 (0x0002)
   if ErrorLevel   ; check ErrorLevel to see if the OS has Winsock 2.0 available:
   {
      MsgBox WSAStartup() could not be called due to error %ErrorLevel%. Winsock 2.0 or higher is required.
      return -1
   }
   if result  ; Non-zero, which means it failed (most Winsock functions return 0 on success).
   {
      MsgBox % "WSAStartup() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError") ; %
      return -1
   }
   ; convert ip to Inet Address
   Inet_address := DllCall("Ws2_32\inet_addr", Str, "0")
   PtrHostent := DllCall("Ws2_32\gethostbyaddr", "int *", %Inet_address%, "int", 4, "int", 2)
   if (PtrHostent = 0)
      Return -1
   VarSetCapacity(hostent,16,0)
   DllCall("RtlMoveMemory",UInt,&hostent,UInt,PtrHostent,UInt,16)
   h_addr_list := ExtractInteger(hostent,12,false,4)

   VarSetCapacity(AddressList,12,0)
   DllCall("RtlMoveMemory",UInt,&AddressList,UInt,h_addr_list,UInt,12)
   Loop, 3
   {
      offset := ((A_Index-1)*4)
      PtrAddress%A_Index% := ExtractInteger(AddressList,offset,false,4)
      If (PtrAddress%A_Index% =0)
         break
      VarSetCapacity(address%A_Index%,4,0)
      DllCall("RtlMoveMemory" ,UInt,&address%A_Index%,UInt,PtrAddress%A_Index%,Uint,4)
      i := A_Index
      Loop, 4
      {
         if Straddress%i%
            Straddress%i% := Straddress%i% "." ExtractInteger(address%i%,(A_Index-1 ),false,1)
         else
            Straddress%i% := ExtractInteger(address%i%,(A_Index-1 ),false,1)
      }
      Straddress0 = %i%
   }
   loop, %Straddress0% ; put them together and return them
   {
      _this := Straddress%A_Index%
      if _this <>
         IPs = %IPs%%_this%
      if A_Index = %Straddress0%
         break
      IPs = %IPs%`n
   }
   return IPs
}
GetAdaptersInfo() {																	            			;-- GetAdaptersAddresses function & IP_ADAPTER_ADDRESSES structure
	/*                              	DESCRIPTION

				Link: https://autohotkey.com/boards/viewtopic.php?t=18768
				Dependencies: none
	*/
    ; initial call to GetAdaptersInfo to get the necessary size
    if (DllCall("iphlpapi.dll\GetAdaptersInfo", "ptr", 0, "UIntP", size) = 111) ; ERROR_BUFFER_OVERFLOW
        if !(VarSetCapacity(buf, size, 0))  ; size ==>  1x = 704  |  2x = 1408  |  3x = 2112
            return "Memory allocation failed for IP_ADAPTER_INFO struct"

    ; second call to GetAdapters Addresses to get the actual data we want
    if (DllCall("iphlpapi.dll\GetAdaptersInfo", "ptr", &buf, "UIntP", size) != 0) ; NO_ERROR / ERROR_SUCCESS
        return "Call to GetAdaptersInfo failed with error: " A_LastError

    ; get some information from the data we received
    addr := &buf, IP_ADAPTER_INFO := {}
    while (addr)
    {
        IP_ADAPTER_INFO[A_Index, "ComboIndex"]          		:= NumGet(addr+0, o := A_PtrSize, "UInt")   , o += 4
        IP_ADAPTER_INFO[A_Index, "AdapterName"]         	:= StrGet(addr+0 + o, 260, "CP0")           , o += 260
        IP_ADAPTER_INFO[A_Index, "Description"]         		:= StrGet(addr+0 + o, 132, "CP0")           , o += 132
        IP_ADAPTER_INFO[A_Index, "AddressLength"]       		:= NumGet(addr+0, o, "UInt")                , o += 4
        loop % IP_ADAPTER_INFO[A_Index].AddressLength
									mac .= Format("{:02X}",                       NumGet(addr+0, o + A_Index - 1, "UChar")) "-"
        IP_ADAPTER_INFO[A_Index, "Address"]             			:= SubStr(mac, 1, -1), mac := ""            , o += 8
        IP_ADAPTER_INFO[A_Index, "Index"]               			:= NumGet(addr+0, o, "UInt")                , o += 4
        IP_ADAPTER_INFO[A_Index, "Type"]                			:= NumGet(addr+0, o, "UInt")                , o += 4
        IP_ADAPTER_INFO[A_Index, "DhcpEnabled"]         		:= NumGet(addr+0, o, "UInt")                , o += A_PtrSize
																					Ptr 	:= NumGet(addr+0, o, "UPtr")                , o += A_PtrSize
        IP_ADAPTER_INFO[A_Index, "CurrentIpAddress"]   	:= Ptr ? StrGet(Ptr + A_PtrSize, "CP0") : ""
        IP_ADAPTER_INFO[A_Index, "IpAddressList"]       		:= StrGet(addr + o + A_PtrSize, "CP0")
        IP_ADAPTER_INFO
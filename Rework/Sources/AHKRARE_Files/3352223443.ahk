DNS_QueryName(IP, ByRef NameArray := "") {						            			;--

   Static OffRR := (A_PtrSize * 2) + 16 ; offset of resource record (RR) within the DNS_RECORD structure
   HDLL := DllCall("LoadLibrary", "Str", "Dnsapi.dll", "UPtr")
   NameArray := []
   IPArray := StrSplit(IP, ".")
   RevIP := IPArray.4 . "." . IPArray.3 . "." . IPArr
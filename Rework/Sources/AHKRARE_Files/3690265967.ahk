DNSQuery(AddrOrName, ByRef ResultArray := "", ByRef CNAME := "") {		;-- retrieve IP adresses or host/domain names from DNS
   Static OffRR := (A_PtrSize * 2) + 16 ; offset of resource record (RR) within the DNS_RECORD structure
   HDLL := DllCall("LoadLibrary", "Str", "Dnsapi.dll", "UPtr")
   CNAME := ""
   Error := 0
   ResultArray := []
   If RegExMatch(AddrOrName, "^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$", IP) {
      RevIP := IP4 . "." . IP3 . "." . IP2 . "." . IP1 . ".IN-ADDR.ARPA"
      If !(Error := DllCall("Dnsapi.dll\DnsQuery_", "Str", RevIP, "Short", 0x0C, "UInt", 0, "Ptr", 0, "PtrP", PDNS, "Ptr", 0)) {
         REC_TYPE := NumGet(PDNS + 0, A_PtrSize * 2, "UShort")
         If (REC_TYPE = 0x0C) { ; DNS_TYPE_PTR
            PDR := PDNS
            While (PDR) {
               Name := StrGet(NumGet(PDR + 0, OffRR, "UPtr"))
               ResultArray.Push(Name)
               PDR := NumGet(PDR + 0, "UPtr")
            }
         }
         DllCall("Dnsapi.dll\DnsRecordListFree", "Ptr", PDNS, "Int", 1) ; DnsFreeRecordList
      }
   }
   Else {
      CNAME := AddrOrName
      Loop {
         If !(Error := DllCall("Dnsapi.dll\DnsQuery_", "Str", CNAME, "Short", 0x01, "UInt", 0, "Ptr", 0, "PtrP", PDNS, "Ptr", 0)) {
            REC_TYPE := NumGet(PDNS + 0, A_PtrSize * 2, "UShort")
            If (REC_TYPE = 0x05) { ; DNS_TYPE_CNAME
               CNAME := StrGet(NumGet(PDNS + OffRR, "UPtr"))
               DllCall("Dnsapi.dll\DnsRecordListFree", "Ptr", PDNS, "Int", 1) ; DnsFreeRecordList
               Continue
            }
            If (REC_TYPE = 0x01) { ; DNS_TYPE_A
               PDR := PDNS
               While (PDR) {
                  Addr := ""
                  Loop, 4
                     Addr .= NumGet(PDR + OffRR + (A_Index - 1), "UChar") . "."
                  ResultArray.Push(RTrim(Addr, "."))
                  PDR := NumGet(PDR + 0, "UPtr")
               }
               DllCall("Dnsapi.dll\DnsRecordListFree", "Ptr", PDNS, "Int", 1) ; DnsFreeRecordList
               Break
            }
         }
         Break
      }
   }
   DllCall("FreeLibrary", "Ptr", HDLL)
   ErrorLevel := Error
   Return ResultArray[1]
}
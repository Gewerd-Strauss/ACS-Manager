NetStat() {                                                                                                    	;--passes information over network connections similar to the netstat -an CMD command.

	/*	Description: a function by jNizM

		https://autohotkey.com/boards/viewtopic.php?t=4372

		this function returns an array:
		- array[x].proto ;(Das Protokoll der Verbindung -> TCP oder UDP)
		- array[x].ipv ;(Die IP-Version -> 4 oder 6)
		- array[x].localIP ;(Lokale IP Adresse)
		- array[x].localPort ;(Lokaler Port)
		- array[x].localScopeId ;(Lokale Scope ID... nur IPv6)
		- array[x].remoteIP ;(Remote IP Adresse... nur TCP)
		- array[x].remotePort ;(Remote Port :HeHe: ... nur TCP)
		- array[x].remoteScopeId ;(nur TCP/IPv6)
		- array[x].status ;(der Status der Verbindung -> LISTEN, ESTABLISHED, TIME-WAIT, etc...)

	*/

	c := 32
	static status := {1:"CLOSED", 2:"LISTEN", 3:"SYN-SENT", 4:"SYN-RECEIVED"
	, 5:"ESTABLISHED", 6:"FIN-WAIT-1", 7:"FIN-WAIT-2", 8:"CLOSE-WAIT"
	, 9:"CLOSING", 10:"LIST-ACK", 11:"TIME-WAIT", 12:"DELETE-TCB"}

	iphlpapi := DllCall("LoadLibrary", "str", "iphlpapi", "ptr")
	list := []

	VarSetCapacity(tbl, 4+(s := (20*c)), 0)
	while (DllCall("iphlpapi\GetTcpTable", "ptr", &tbl, "uint*", s, "uint", 1)=122)
	VarSetCapacity(tbl, 4+s, 0)

	Loop, % NumGet(tbl, 0, "uint")
	{
		o := 4+((A_Index-1)*20)
		t := {proto:"TCP", ipv:4}
		t.localIP := ((dw := NumGet(tbl, o+4, "uint"))&0xff) "." ((dw&0xff00)>>8) "." ((dw&0xff0000)>>16) "." ((dw&0xff000000)>>24)
		t.localPort := (((dw := NumGet(tbl, o+8, "uint"))&0xff00)>>8)|((dw&0xff)<<8)
		t.remoteIP := ((dw := NumGet(tbl, o+12, "uint"))&0xff) "." ((dw&0xff00)>>8) "." ((dw&0xff0000)>>16) "." ((dw&0xff000000)>>24)
		t.remotePort := (((dw := NumGet(tbl, o+16, "uint"))&0xff00)>>8)|((dw&0xff)<<8)
		t.status := status[NumGet(tbl, o, "uint")]
		list.insert(t)
	}

	if (DllCall("GetProcAddress", "ptr", iphlpapi, "astr", "GetTcp6Table", "ptr"))
	{
		VarSetCapacity(tbl, 4+(s := (52*c)), 0)
		while (DllCall("iphlpapi\GetTcp6Table", "ptr", &tbl, "uint*", s, "uint", 1)=122)
			VarSetCapacity(tbl, 4+s, 0)

		Loop, % NumGet(tbl, 0, "uint")
		{
			VarSetCapacity(str, 94, 0)
			o := 4+((A_Index-1)*52)
			t := {proto:"TCP", ipv:6}
			t.localIP := (DllCall("ws2_32\InetNtop", "uint", 23, "ptr", &tbl+o+4, "ptr", &str, "uint", 94)) ? StrGet(&str) : ""
			t.localScopeId := (((dw := NumGet(tbl, o+20, "uint"))&0xff)<<24) | ((dw&0xff00)<<8) | ((dw&0xff0000)>>8) | ((dw&0xff000000)>>24)
			t.localPort := (((dw := NumGet(tbl, o+24, "uint"))&0xff00)>>8)|((dw&0xff)<<8)
			t.remoteIP := (DllCall("ws2_32\InetNtop", "uint", 23, "ptr", &tbl+o+28, "ptr", &str, "uint", 94)) ? StrGet(&str) : ""
			t.remoteScopeId := (((dw := NumGet(tbl, o+44, "uint"))&0xff)<<24) | ((dw&0xff00)<<8) | ((dw&0xff0000)>>8) | ((dw&0xff000000)>>24)
			t.remotePort := (((dw := NumGet(tbl, o+48, "uint"))&0xff00)>>8)|((dw&0xff)<<8)
			t.status := status[NumGet(tbl, o, "uint")]
			list.insert(t)
		}
	}

	VarSetCapacity(tbl, 4+(s := (8*c)), 0)
	while (DllCall("i
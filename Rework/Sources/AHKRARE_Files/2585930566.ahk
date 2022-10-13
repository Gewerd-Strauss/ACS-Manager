GetCommState(ComPort) {																							;-- this function retrieves the configuration settings of a given serial port
global
local h, cs, ch, port, DCB, Str, Uint

port=com%comport%
h := DllCall("CreateFile","Str", port,"Uint",0x80000000,"Uint",3,"UInt",0,"UInt",3,"Uint",0,"UInt",0)
If (h = -1 or h = 0 or ErrorLevel != 0)
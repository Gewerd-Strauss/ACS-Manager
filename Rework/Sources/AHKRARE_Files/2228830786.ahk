GetHFONT(Options := "", Name := "") {                                                                      	;-- gets a handle to a font used in a AHK gui for example

   ; source: https://github.com/aviaryan/Clipjump/blob/master/lib/anticj_func_labels.ahk
   ; dependings: no

   Gui, New
   Gui, Font, % Options, % Name
   Gui, Add, Text, +hwndHTX, Dummy
   HFONT := DllCall("User32.dll\SendMessage", "Ptr", HTX, "UInt", 0x31, "Ptr", 0, "Ptr", 0, "UPtr") ; WM_GETFONT
   Gui, Destroy
   Return HFONT
}
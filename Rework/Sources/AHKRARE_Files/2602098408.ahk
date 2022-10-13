IEGet(name:="") {																							     			;-- AutoHotkey_Basic
   IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame ; Get active window if no parameter
   Name := (Name="New Tab - Windows Internet Explorer") ? "about:Tabs":RegExReplace(Name, " - (Windows|Microsoft) Internet Explorer")
   oShell := COM_CreateObject("Shell.Application") ; Contains reference to all explorer windows
   Loop, % COM_Invoke(oShell, "Windows.Count
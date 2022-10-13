IEGet(name:="") {																							    			;-- AutoHotkey_L
   IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame ; Get active window if no parameter
   Name := (Name="New Tab - Windows Internet Explorer")? "about:Tabs":RegExReplace(Name, " - (Windows|Microsoft) Internet Explorer")
   for WB in ComObjCreate("Shell.Application").Windows
      if WB.LocationName=Name and InStr(WB.FullName, "iexplore.exe")
         return WB
}
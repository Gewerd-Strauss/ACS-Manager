LV_SetExplorerTheme(HCTL) { 																						;-- set 'Explorer' theme for ListViews & TreeViews on Vista+
; HCTL : handle of a ListView or TreeView control
If (DllCall("GetVersion", "UChar") > 5) {
VarSetCapacity(ClassName, 1024, 0)
If DllCall("GetClassName", "Ptr", HCTL, "Str", ClassName, "Int", 512, "Int")
If (ClassName = "SysListView32") || (ClassName = "SysTreeView32")
Return !DllCall("UxTheme.dll\SetWindowTheme", "Ptr", HCTL, "WStr", "Explorer", "Ptr", 0)
}
Return False
}
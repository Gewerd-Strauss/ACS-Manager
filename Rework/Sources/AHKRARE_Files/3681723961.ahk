LV_SetBackgroundURL(URL, ControlID) {																		;-- set a ListView's background image - please pay attention to the description

/*											Function: LV_SetBackgroundURL

Origin 	: https://autohotkey.com/board/topic/20588-adding-pictures-to-controls-eg-as-background/#entry135365
Author	: Lexikos

The function below tiles the background, since the only alternative is to attach it to the top-left of the very first item (in which
case it scrolls with the ListView's contents.)

Since LVM_SETBKIMAGE (internally) uses COM, CoInitialize() must be called when the script starts:

DllCall("ole32\CoInitialize", "uint", 0)

..and CoUninitialize() when the script exits:

DllCall("ole32\CoUninitialize")Important: The ListView/GUI should be destroyed before calling CoUninitialize(),
otherwise the script will crash on exit for some versions of Windows.

LVM_SETBKIMAGE can be made to accept a bitmap handle, so it would be possible to manually stretch an image to fit the
ListView rather than tiling it. (Search MSDN for LVM_SETBKIMAGE.)

*/
; URL:          URL or file path (absolute, not relative)
; ControlID:    ClassNN or associated variable of a ListView on the default GUI.

GuiControlGet, hwnd, Hwnd, %ControlID%
VarSetCapacity(bki, 24, 0)
NumPut(0x2|0x10, bki, 0)  ; LVBKIF_SOURCE_URL | LVBKIF_STYLE_TILE
NumPut(&URL, bki, 8)
SendMessage, 0x1044, 0, &bki,, ahk_id %hwnd%  ; LVM_SETBKIMAGE
SendMessage, 0x1026, 0, -1,, ahk_id %ControlID%  ; LVM_SETTEXTBKCOLOR,, CLR_NONE
}
LV_GetExStyle(hWnd) {																									;-- get / remove / alternate extended styles to the listview control
return SendMessage(hWnd, 0x1037,,,,, "UInt")
}
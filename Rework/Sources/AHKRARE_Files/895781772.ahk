LV_RedrawItem(hWnd, ItemFirst := 0, ItemLast := "") {													;-- this one redraws on listview item
If (ItemFirst > 0)
ItemLast := ItemLast=""?ItemFirst:ItemLast
else ItemLast := (ItemFirst:=SendMessage(hWnd, 0x1027))+SendMessage(hWnd, 0x1028)
return SendMessage(hWnd, 0x1000+21, "Int", ItemFirst-1, "Int", ItemLast-1), DllCall("User32.dll\UpdateWindow", "Ptr", hWnd)
}
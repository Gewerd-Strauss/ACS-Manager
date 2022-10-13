LV_Update(hWnd, Item) {																								;-- update one listview item
return SendMessage(hWnd, 0x1000+42, "Int", Item-1)
}
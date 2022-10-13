IndexOfIconResource_EnumIconResources(hModule, lpszType, lpszName, lParam) {  ;-- subfunction of IndexOfIconResource()
    NumPut(NumGet(lParam+4)+1, lParam+4)

    if (lpszName = NumGet(lParam+0))
    {
        NumPut(1, lParam+8)
        return false    ; break
    }
    return true
}
GetWindowOrder(hwnd="",visibleWin=1) {                                                            	;-- determines the window order for a given (parent-)hwnd
	if !hwnd
		hwnd:=winexist("ahk_pid " DllCall("GetCurrentProcessId"))

	arr1:=[]
	arr2:=[]

	hwndP:=hwnd
	loop {
		hwndP:=GetNextWindow(hwndP,1,visibleWin)
		if(hwndP=hwnd || !hwndP)
			break
		else
			arr1.insert(hwndP)
	}

	hwndN:=hwnd
	loop {
		hwndN:=GetNextWindow(hwndN,1,visibleWin)
		if(hwndN=hwnd || !hwndP)
			break
		else
			arr2.insert(hwndN)
	}

	arr:=[],max:=arr1.maxIndex()
	loop % max
		arr.insert(arr1[max+1-a_index])
	for k,v in arr2
		arr.insert(v)

	return {array: arr, index: max+1}
}
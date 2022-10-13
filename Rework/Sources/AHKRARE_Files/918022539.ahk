ListControls(hwnd, obj=0, arr="") {                                                                         	;-- similar function to GetControls but returns a comma seperated list

	if !isobject(arr)
		arr:=[]

	if isobject(hwnd){
		for k,v in hwnd
			arr:=ListControls(v, 1, arr)
		goto ListControlsReturn
	}

	str=
	arr:=GetControls(hwnd)
ListControlsReturn:
	if obj
		return arr

	for k,v in arr
		str.="""" v["Hwnd"] """,""" v["ClassNN"] """,""" v["text"] """`n"
	return str
}
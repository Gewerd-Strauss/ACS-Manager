MouseGetText(x := "", y := "", Encoding := "UTF-16") {                                                      	;-- get the text in the specified coordinates, function uses Microsoft UIA

	/*                              	DESCRIPTION

			; get the text in the specified coordinates
			; Syntax: MouseGetText ([x], [y])

	*/
	static uia
	if (x="") || (y="")
		CursorGetPos(_x, _y), x := x=""?_x:x, y := y=""?_y:y
	if !(uia) ;https://msdn.microsoft.com/en-us/library/windows/desktop/ff384838%28v=vs.85%29.aspx
		uia := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
	Item := {}, DllCall(_vt(uia,7),"Ptr",uia,"int64",x|y<<32,"Ptr*",element)
	if !(element)
		return "", ErrorLevel := true
	DllCall(_vt(element,23),"Ptr",element,"Ptr*",name),DllCall(_vt(element,10),"Ptr",element,"UInt",30045,"Ptr",_variant(var))
	,DllCall(_vt(element,10),"Ptr",element,"uint",30092,"Ptr",_variant(lname)), DllCall(_vt(element,10),"Ptr",element,"uint",30093,"Ptr",_variant(lval))
	,a:=StrGet(name,"utf-16"),b:=StrGet(NumGet(val,8,"Ptr"),Encoding),c:=StrGet(NumGet(lname,8,"Ptr"),Encoding)
	,d:=StrGet(NumGet(lval,8,"Ptr"),Encoding),a?Item.Push(a):0,b&&_vas(Item,b)?Item.Push(b):0,c&&_vas(Item,c)?Item.Push(c):0
	,d&&_vas(Item,d)?Item.Push(d):0,DllCall(_vt(element,21),"Ptr",element,"Uint*",type)
	if (type=50004)
		e:=MouseGetText_ElementWhole(uia,element),e&&_vas(item,e)?item.Push(e):false
	return Item, ObjRelease(element), ErrorLevel := false
} MouseGetText_ElementWhole(uia, element) {
	static init := 1, trueCondition, walker
	if (init)
		init:=DllCall(_vt(uia,21),"ptr",uia,"ptr*",trueCondition),init+=DllCall(_vt(uia,14),"ptr",uia,"ptr*",walker)
	DllCall(_vt(uia,5),"ptr",uia,"ptr*",root), DllCall(_vt(uia,3),"ptr",uia,"ptr",element,"ptr",root,"int*",same), ObjRelease(root)
	if (same)
		return
	hr:=DllCall(_vt(walker,3),"ptr",walker,"ptr",element,"ptr*",parent)
	if !(e:="") && !(parent)
		return
	DllCall(_vt(parent,6),"ptr",parent,"uint",2,"ptr",trueCondition,"ptr*",array), DllCall(_vt(array,3),"ptr",array,"int*",length)
	Loop % (length)
		DllCall(_vt(array,4),"ptr",array,"int",A_Index-1,"ptr*",newElement), DllCall(_vt(newElement,23),"ptr",newElement,"ptr*",name)
		, e.=StrGet(name,"utf-16"), ObjRelease(newElement)
	return e, ObjRelease(array), ObjRelease(parent)
} _vas(obj,ByRef txt) {
	for k,v in obj
		if (v=txt)
			return false
	return true
}_variant(ByRef var,type:=0,val:=0) {
	return (VarSetCapacity(var,8+2*A_PtrSize)+NumPut(type,var,0,"short")+NumPut(val,var,8,"ptr"))*0+&var
}_vt(p,n) {
	return NumGet(NumGet(p+0,"ptr")+n*A_PtrSize,"ptr")
}
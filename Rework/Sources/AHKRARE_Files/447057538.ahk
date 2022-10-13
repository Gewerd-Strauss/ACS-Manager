GetElementByName(AccObj, name) {                                                                          	;-- search for one element by name
if (AccObj.accName(0) = name)
	return AccObj
for k, v in Acc_Children(AccObj)
	if IsObject(obj := GetElementByName(v, name))
		return obj
}
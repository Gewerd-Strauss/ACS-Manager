GetEnumIndex(Acc, ChildId=0) {                                                                                  	;-- for Acc child object
	if Not ChildId {
		ChildPos := Acc_Location(Acc).pos
		For Each, child in Acc_Children(Acc_Parent(Acc))
			if IsObject(child) and Acc_Location(child).pos=ChildPos
				return A_Index
	}
	else {
		ChildPos := Acc_Location(Acc,ChildId).pos
		For Each, child in Acc_Children(Acc)
			if Not IsObject(child) and Acc_Location(Acc,child).pos=ChildPos
				return A_Index
	}
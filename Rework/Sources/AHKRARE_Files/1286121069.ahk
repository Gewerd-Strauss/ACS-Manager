ObjMerge(OrigObj, MergingObj, MergeBase=True) {                    	;-- merge two objects

    If !IsObject(OrigObj) || !IsObject(MergingObj)
        Return False
    For k, v in MergingObj
        ObjInsert(OrigObj, k, v)
    if MergeBase && IsObject(MergingObj.base) {
        If !IsObject(Orig
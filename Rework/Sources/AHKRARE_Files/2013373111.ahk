monitorInfo() {																										;-- shows infos about your monitors
	sysget,monitorCount,monitorCount
	arr:=[],sorted:=[]
	loop % monitorCount {
		sysget,mon,monitor,% a_index
		arr.insert({l:monLeft,r:monRight,b:monBottom,t:monTop,w:monRight-monLeft+1,h:monBottom-monTop+1})
		k:=a_index
		while strlen(k)<3
			k:="0" k
		sorted[monLeft k]:=a_index
	}
	arr2:=[]
	for k,v in sorted
		arr2.insert(arr[v])
	return arr2
}
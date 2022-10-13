winfade(w:="",t:=128,i:=1,d:=10) {                                                                           	;-- another winfade function

	; https://github.com/joedf/AEI.ahk/blob/master/AEI.ahk
	w:=(w="")?("ahk_id " WinActive("A")):w
	t:=(t>255)?255:(t<0)?0:t
	WinGet,s,Transparent,%w%
	s:=(s="")?255:s ;prevent trans unset bug
	WinSet,Transparent,%s%,%w%
	i:=(s<t)?abs(i):-1*abs(i)
	while(k:=(i<0)?(s>t):(s<t)&&WinExist(w)) {
		WinGet,s,Transparent,%w%
		s+=i
		WinSet,Transparent,%s%,%w%
		sleep %d%
	}
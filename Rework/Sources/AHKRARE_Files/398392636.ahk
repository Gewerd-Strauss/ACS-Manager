Time(to,from="",units="d",params="") {	                                                            	;-- calculate with time, add minutes, hours, days - add or subtract time

	/*                              	DESCRIPTION
				Link: https://autohotkey.com/board/topic/42668-time-count-days-hours-minutes-seconds-between-dates/
	*/

	static _:="0000000000",s:=1,m:=60,h:=3600,d:=86400
				,Jan:="01",Feb:="02",Mar:="03",Apr:="04",May:="05",Jun:="06",Jul:="07",Aug:="08",Sep:="09",Okt:=10,Nov:=11,Dec:=12
	r:=0
	units:=units ? %units% : 8640
	If (InStr(to,"/") or InStr(to,"-") or InStr(to,".")){
		Loop,Parse,to,/-.,%A_Space%
			_%A_Index%:=RegExMatch(A_LoopField,"\d+") ? A_LoopField : %A_LoopField%
			,_%A_Index%:=(StrLen(_%A_Index%)=1 ? "0" : "") . _%A_Index%
		to:=SubStr(A_Now,1,8-StrLen(_1 . _2 . _3)) . _3 . (RegExMatch(SubStr(to,1,1),"\d") ? (_2 . _1) : (_1 . _2))
		_1:="",_2:="",_3:=""
	}
	If (from and InStr(from,"/") or InStr(from,"-") or InStr(from,".")){
		Loop,Parse,from,/-.,%A_Space%
			_%A_Index%:=RegExMatch(A_LoopField,"\d+") ? A_LoopField : %A_LoopField%
			,_%A_Index%:=(StrLen(_%A_Index%)=1 ? "0" : "") . _%A_Index%
		from:=SubStr(A_Now,1,8-StrLen(_1 . _2 . _3)) . _3 . (RegExMatch(SubStr(from,1,1),"\d") ? (_2 . _1) : (_1 . _2))
	}
   count:=StrLen(to)<9 ? "days" : StrLen(to)<11 ? "hours" : StrLen(to)<13 ? "minutes" : "seconds"
	to.=SubStr(_,1,14-StrLen(to)),(from ? from.=SubStr(_,1,14-StrLen(from)))
	Loop,Parse,params,%A_Space%
		If (unit:=SubStr(A_LoopField,1,1))
			 %unit%1:=InStr(A_LoopField,"-") ? SubStr(A_LoopField,2,InStr(A_LoopField,"-")-2) : ""
			,%unit%2:=SubStr(A_LoopField,InStr(A_LoopField,"-") ? (InStr(A_LoopField,"-")+1) : 2)
	count:=!params ? count : "seconds"
	add:=!params ? 1 : (S2="" ? (M2="" ? (H2="" ? ((D2="" and B2="" and W="") ? d : h) : m) : s) : s)
	While % (from<to){
		FormatTime,year,%from%,YYYY
		FormatTime,month,%from%,MM
		FormatTime,day,%from%,dd
		FormatTime,hour,%from%,H
		FormatTime,minute,%from%,m
		FormatTime,second,%from%,s
		FormatTime,WDay,%from%,WDay
		EnvAdd,from,%add%,%count%
		If (W1 or W2){
			If (W1=""){
				If (W2=WDay or InStr(W2,"." . WDay) or InStr(W2,WDay . ".")){
					Continue=1
				}
			} else If WDay not Between %W1% and %W2%
				Continue=1
			;else if (Wday=W2)
			;	Continue=1
			If (Continue){
				tempvar:=SubStr(from,1,8)
				EnvAdd,tempvar,1,days
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				Continue=
				continue
			}
		}
		If (D1 or D2 or B2){
			If (D1=""){
				If (D2=day or B2=(day . month) or InStr(B2,"." . day . month) or InStr(B2,day . month . ".") or InStr(D2,"." . day) or InStr(D2,day . ".")){
					Continue=1
				}
			} else If day not Between %D1% and %D2%
				Continue=1
			;else if (day=D2)
			;	Continue=1
			If (Continue){
				tempvar:=SubStr(from,1,8)
				EnvAdd,tempvar,1,days
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				Continue=
				continue
			}
		}
		If (H1 or H2){
			If (H1=""){
				If (H2=hour or InStr(H2,hour . ".") or InStr(H2,"." hour)){
					Continue=1
				}
			} else If hour not Between %H1% and %H2%
				continue=1
			;else if (hour=H2)
			;	continue=1
			If (continue){
				tempvar:=SubStr(from,1,10)
				EnvAdd,tempvar,1,hours
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				continue=
				continue
			}
		}
		If (M1 or M2){
			If (M1=""){
				If (M2=minute or InStr(M2,minute . ".") or InStr(M2,"." minute)){
					Continue=1
				}
			} else If minute not Between %M1% and %M2%
				continue=1
			;else if (minute=M2)
			;	continue=1
			If (continue){
				tempvar:=SubStr(from,1,12)
				EnvAdd,tempvar,1,minutes
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				continue=
				continue
			}
		}
		If (S1 or S2){
			If (S1=""){
				If (S2=second or InStr(S2,second . ".") or InStr(S2,"." second)){
					Continue
				}
			} else if (second!=S2)
				If second not Between %S1% and %S2%
					continue
		}
		r+=add
	}
	tempvar:=SubStr(count,1,1)
	tempvar:=%tempvar%
	Return (r*tempvar)/units
}
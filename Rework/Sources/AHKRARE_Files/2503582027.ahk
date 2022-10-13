TimeCode(MaT) {	                                                                                                	;-- TimCode can be used for protokoll or error logs

	;Month & Time (MaT) = 1 - it's clear!

	If MaT = 1
		TC:= A_DD "." A_MM "." A_YYYY "`, "

	TC.= A_Hour ":" A_Min ":" A_Sec "`." A_MSec

return TC
}
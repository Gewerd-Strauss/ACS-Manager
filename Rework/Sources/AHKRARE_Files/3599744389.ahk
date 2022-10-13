Mean(List) {																						;-- returns Average values in comma delimited list

	;https://autohotkey.com/board/topic/4858-mean-median-mode-functions/

	Loop, Parse, List , `,
	{
		Total += %A_LoopField%
		D = %A_Index%
	}
	R := Total/D

	Return R
}
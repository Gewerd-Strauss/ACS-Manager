Mode(List) {																						;-- returns the mode from a list of numbers

	;https://autohotkey.com/board/topic/4858-mean-median-mode-functions/

	StringSplit, Cont, List, `,

	Loop, %Cont0% {

		i := A_Index
		C := Cont%i%
		If ModeArr%C% =
			ModeArr%C% = 1
		Else {
			Amt := ModeArr%C%
			ModeArr%C% := Amt + 1
		}
	}

	Loop %i%	{
		LMC = %CMC%
		CMC := ModeArr%A_Index%
		If CMC > %LMC%
			Mode = %A_Index%
	}

	Return Mode
}
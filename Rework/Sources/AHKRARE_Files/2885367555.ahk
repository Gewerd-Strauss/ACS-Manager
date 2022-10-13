SoundExC(Wrd="") {	;-- phonetic algorithm for indexing names by sound
	Static A=0, B=1, C=2, D=3, E=0, F=1, G=2, H=0, I=0, J=2, K=2, L=4, M=5
	Static N=5, O=0, P=1, Q=2, R=6, S=2, T=3, U=0, V=1, W=0, X=2, Y=0, Z=2

	Wrd:= Format("{:U}", Wrd)
	Pre:= SubStr(Wrd, 1, 1)
	Prv:= %Pre%
	Word:= SubStr(Wrd, 2)

	Loop, Parse, Word
		If (Asc(A_LoopField) > 64 && Asc(A_LoopField) < 91)
			Word:= StrReplace(Word, A_LoopField, % %A_LoopField%)
		Else
			Word:= StrReplace(Word, A_LoopField)

	Loop, Parse, Word
		SE .= A_LoopField = Prv ? "" : Prv:=A_LoopField

	 SE:= StrReplace(SE, 0,, All)

Return Pre . SubStr(SE "000", 1, 3)
}
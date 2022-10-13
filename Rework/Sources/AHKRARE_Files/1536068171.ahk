InVar(Haystack, Needle, Delimiter := ",", OmitChars := "") {										;-- sub of SetTaskbarProgress, parsing list search
	Loop, Parse, % Needle, %Delimiter%, %OmitChars%
		if (A_LoopField = Haystack)
			return 1
	return 0
}
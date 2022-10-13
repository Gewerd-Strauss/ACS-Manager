GetWordsNumbered(string, conditions) {										;-- gives back an array of words from a string, you can specify the position of the words you want to keep

	/*                              	DESCRIPTION

			by Ixiko 2018 - i know there's a better way, but I needed a function quickly

			Parameters:
			string:						the string to split in words
			conditions:				it's not the best name for this parameter, conditions must be a comma separated list of numbers like : "1,2,5,6"

	*/

	;this lines are not mine, they remove some chars i didn't need and they remove repeated space chars to one
	new:= RegExReplace(string, "(\s+| +(?= )|\s+$)", A_Space)
	new:= RegExReplace(new, "(,+)", A_Space)
	word:= StrSplit(new, A_Space)

	Loop, % word.MaxIndex()
	{
		If A_Index not in %conditions%
				word[A_Index]:= " "
	}

	Loop, % word.MaxIndex()
	{
		If (word[A_Index] = " ")
				word.Delete(A_Index)
	}

return word
}
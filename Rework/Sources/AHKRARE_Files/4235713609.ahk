evalRPN(s) {                                                                                     	;-- Parsing/RPN calculator algorithm
	stack := []
	out := "For RPN expression: '" s "'`r`n`r`nTOKEN`t`tACTION`t`t`tSTACK`r`n"
	Loop Parse, s
		If A_LoopField is number
			t .= A_LoopField
		else
		{
			If t
				stack.Insert(t)
				, out .= t "`tPush num onto top of stack`t" stackShow(stack) "`r`n"
				, t := ""
			If InStr("+-/*^", l := A_
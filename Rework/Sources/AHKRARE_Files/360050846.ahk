StackShow(stack){																			;--
	for each, value in stack
		out .= A_Space value
	return subStr(out, 2)
}
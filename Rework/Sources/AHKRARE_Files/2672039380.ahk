DrawLine(hdc, rX1, rY1, rX2, rY2) {																			;-- used DLLCall to draw a line

	DllCall("MoveToEx", Int, hdc, Int, rX1, Int, rY1, UInt, 0)
	DllCall("LineTo", Int, hdc, Int, rX2, Int, rY2)
}
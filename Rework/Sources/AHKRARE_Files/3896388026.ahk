DrawRectangle(hdc, left, top, right, bottom) {                                                    	;-- used DLLCall to draw a rectangle

	DllCall("MoveToEx", Int, hdc, Int, left, Int, top, UInt, 0)

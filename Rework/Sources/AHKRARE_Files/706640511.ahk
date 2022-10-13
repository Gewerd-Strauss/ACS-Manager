GetCaretPos(ByRef x, ByRef y) {                                                                                	;-- Alternative to A_CaretX & A_CaretY (maybe not better)
	/* typedef struct tagGUITHREADINFO {
	  DWORD cbSize;        //4
	  DWORD flags;         //4
	  HWND  hwndActive;    //A_PtrSize
	  HWND  hwndFocus;     //A_PtrSize
	  HWND  hwndCapture;   //A_PtrSize
	  HWND  hwndMenuOwner; //A_PtrSize
	  HWND  hwndMoveSize;  //A_PtrSize
	  HWND  hwndCaret;     //A_PtrSize
	  RECT  rcCaret;       //16
	} GUITHREADINFO
	*/

  static Size:=8+(A_PtrSize*6)+16, hwndCaret:=8+A_PtrSize*5
  Static CaretX:=8+(A_PtrSize*6), CaretY:=CaretX+4
  VarSetCapacity(Info, Size, 0), NumPut(Size, Info, "Int")
  DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", &Info), x:=y:=""
  if !(HWND:=NumGet(Info, hwndCaret, "Ptr"))
    return, 0
  x:=NumGet(Info, CaretX, "Int"), y:=NumGet(Info, CaretY, "Int")
  VarSetCapacity(pt, 8), NumPut(y, NumPut(x, pt, "Int"), "Int")
  DllCall("ClientToScreen", "Ptr", HWND, "Ptr", &pt)
  x:=NumGet(pt, 0, "Int"), y:=NumGet(pt, 4, "Int")
  return, 1
}
SetButtonF(p*) {																											;-- Set a button control to call a function instead of a label subroutine

	/*			FUNCTION: SetButtonF
		_________________________________________________________________________________________

		FUNCTION: SetButtonF
		DESCRIPTION: Set a button control to call a function instead of a label subroutine
		PARAMETER(s):
			hButton := Button control's handle
			FunctionName := Name of fucntion to associate with button
		USAGE:
			Setting a button:
				SetButtonF(hButton, FunctionName)

			Retrieving the function name associated with a particular button:
				Func := SetButtonF(hButton) ; note: 2nd parameter omitted

			Disabling a function for a particular button(similar to "GuiControl , -G" option):
				SetButtonF(hButton, "") ; note: 2nd parameter not omitted but explicitly blank

			Disabling all functions for all buttons:
				SetButtonF() ; No parameters
		NOTES:
			The function/handler must have atleast two parameters, this function passes the
			GUI's hwndas the 1st parameter and the button's hwnd as the 2nd.
			Forum: http://www.autohotkey.com/board/topic/88553-setbuttonf-set-button-to-call-function/
		_________________________________________________________________________________________

	*/

	static WM_COMMAND := 0x0111 , BN_CLICKED := 0x0000
	static IsRegCB := false , oldNotify := {CBA: "", FN: ""} , B := [] , tmr := []
	if (A_EventInfo == tmr.CBA) { ; Call from timer
		DllCall("KillTimer", "UInt", 0, "UInt", tmr.tmr) ; Kill timer, one time only
		, tmr.func.(tmr.params*) ; Call function
		return DllCall("GlobalFree", "Ptr", tmr.CBA, "Ptr") , tmr := []
	}
	if (p.3 <> WM_COMMAND) { ; Not a Windows message ; call from user
		if !ObjHasKey(p, 1) { ; No passed parameter ; Clear all button-function association
			if IsRegCB {
				if B.MinIndex()
					B.Remove(B.MinIndex(), B.MaxIndex())
				, IsRegCB := false
				, OnMessage(WM_COMMAND, oldNotify.FN) ; reset to previous handler(if any)
				, oldNotify.CBA := "" , oldNotify.FN := "" ; reset
				return true
			}
		}
		if !WinExist("ahk_id " p.1) ; or !DllCall("IsWindow", "Ptr", p.1) ; Check if handle is valid
			return false ; Not a valid handle, control does not exist
		WinGetClass, c, % "ahk_id " p.1 ; Check if it's a button control
		if (c == "Button") {
			if p.2 { ; function name/reference has been specified, store/associate it
				if IsFunc(p.2) ; Function name is specified
					B[p.1, "F"] := Func(p.2)
				if (IsObject(p.2) && IsFunc(p.2.Name)) ; Function reference/object is specified
					B[p.1, "F"] := p.2
				if !IsRegCB { ; No button(s) has been set yet , callback has not been registered
					fn := OnMessage(WM_COMMAND, A_ThisFunc)
					if (fn <> A_ThisFunc) ; if there's another handler
						oldNotify.CBA := RegisterCallback((oldNotify.FN := fn)) ; store it
					IsRegCB := true
				}
			} else { ; if 2nd parameter(Function name) is explicitly blank or omitted
				if ObjHasKey(B, p.1) { ; check if button is in the list
					if !ObjHasKey(p, 2) ; Omitted
						return B[p.1].F.Name ; return Funtion Name associated with button
					else { ; Explicitly blank
						B.Remove(p.1, "") ; Disassociate button with function, remove from internal array
						if !B.MinIndex() ; if last button in array
							SetButtonF() ; Reset everything
					}
				}
			}
			return true ; successful
		} else
			return false ; not a button control
	} else { ; WM_COMMAND
		if ObjHasKey(B, p.2) { ; Check if control is in internal array
			lo := p.1 & 0xFFFF ; Control identifier
			hi := p.1 >> 16 ; notification code
			if (hi == BN_CLICKED) { ; Normal, left button
				tmr := {func: B[p.2].F, params: [p.4, p.2]} ; store button's associated function ref and params
				, tmr.CBA := RegisterCallback(A_ThisFunc, "F", 4) ; create callback address
				; Create timer, this allows the function to finish processing the message immediately
				, tmr.tmr := DllCall("SetTimer", "UInt", 0, "UInt", 0, "Uint", 120, "UInt", tmr.CBA)
			}
		} else { ; Other control(s)
			if (oldNotify.CBA <> "") ; if there is a previous handler for WM_COMMAND, call it
				DllCall(oldNotify.CBA, "UInt", p.1, "UInt", p.2, "UInt", p.3, "UInt", p.4)
		}
	}
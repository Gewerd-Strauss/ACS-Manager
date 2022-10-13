EditBox(Text, Title="", Timeout=0, Permanent=False,                             				;-- Displays an edit box with the given text, tile, and options
GUIOptions="Resize MaximizeBox Minsize420x320", ControlOptions="VScroll W400 H300", Margin=10) {
    Static EditBoxInfo := [], WindowHideStack := []
    Gui, New, LabelEditBox HWNDHwndEdit %GUIOptions%, % Title     ;v1.1.04+
    Gui, Margin, %Margin%, %Margin%
    Gui, Add, Edit, HwndHwndEditControl %ControlOptions%, % Text
    ControlFocus,, ahk_id %HwndEditControl%
    Gui, Show
    If Timeout {
        WindowHideStack[A_TickCount + Timeout * 1000] := HwndEdit
        SetTimer, EditBoxClose, % Timeout * -1 * 1000
    }
    EditBoxInfo[HwndEdit] := { HwndWindow : HwndEdit, Margin : Margin, HwndEditControl : HwndEditControl }
Return HwndEdit

    EditBoxSize:
        If (A_EventInfo = 1)  ; The window has been minimized.  No action needed.
            Return
        GuiControl, Move, % EditBoxInfo[Trim(A_GUI)].HwndEditControl
                  , % "H" (A_GuiHeight - EditBoxInfo[A_GUI].margin * 2) " W" ( A_GuiWidth - EditBoxInfo[A_GUI].margin * 2)
    Return
    EditBoxEscape:
    EditBoxClose:
        if (HwndEdit := WindowHideStack.Remove(WindowHideStack.MinIndex(), "")) { ;this means it's called from the timer, so the least index is removed
            if (NextTimer := WindowHideStack.MinIndex())        ;this means a next timer exists
                SetTimer,, % A_TickCount - NextTimer < 0 ? A_TickCount - NextTimer : -1        ;v1.1.01+
        } else
            HwndEdit := EditBoxInfo[A_GUI].HwndWindow
        if !Permanent {
            Gui, %HwndEdit%:Destroy
            EditBoxInfo.Remove(HwndEdit, "")
        } else
            Gui, %HwndEdit%:Hide
    Return
}
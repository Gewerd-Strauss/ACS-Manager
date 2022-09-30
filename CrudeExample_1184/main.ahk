#Warn All, OutputDebug

SetWorkingDir % A_ScriptDir

scripts := ""
loop Files, metadata\Lib\*.ahk, F
    scripts .= A_LoopFileName "|"

Gui Test_:New, -ToolWindow -caption
Gui Add, ListBox, gTest_ChooseScript r5, % scripts
Gui Show

return ; End of auto-execute

Test_ChooseScript(hCtrl, GuiEvent, EventInfo, ErrLevel := "")
{
    if (GuiEvent != "DoubleClick")
        return
    GuiControlGet script,, ListBox1
    Gui Hide
    Script(script)
}

Test_GuiClose()
{
    Gui Destroy
    ExitApp
}

Test_GuiEscape()
{
    Test_GuiClose()
}


Script(ScriptName)
{
    name := SubStr(ScriptName, 1, -4)
    Gui Script_:New, -ToolWindow
    IniRead metadata, % "metadata\" name ".ini", Info
    loop Parse, % metadata, `n
    {
        pair := StrSplit(A_LoopField, "=")
        Gui Add, Text, xm, % pair[1]
        Gui Add, Edit, yp-3 x80, % pair[2]
    }
    Gui Add, Text, Section xm
    x := ""
    loop Files, % "metadata\" name ".example*", F
    {
        Gui Add, Button, % "xp" x, % "Example " A_Index
        fnObj := Func("Example").Bind(name, A_Index)
        GuiControl +g, % "Button" A_Index, % fnObj
        x := "+70"
    }
    FileRead metadata, % "metadata\Lib\" name ".ahk"
    Gui Add, Edit, r30 xm w600 -Wrap, % metadata
    Gui Show
}

Script_GuiClose()
{
    Gui Destroy
    Gui Test_:Show
}

Script_GuiEscape()
{
    Script_GuiClose()
}

Example(File, Num)
{
    scriptFile := "metadata\" File ".example" Num ".ahk"
    Gui Script_:Hide
    Gui Example_:New, -ToolWindow
    Gui Add, Button,, Run
    fnObj := Func("Example_Run").Bind(scriptFile)
    GuiControl +g, Button1, % fnObj
    FileRead metadata, % scriptFile
    Gui Add, Edit, r30 xm w600 -Wrap, % metadata
    Gui Show
}

Example_Run(Script)
{
    Run % Script
}

Example_GuiClose()
{
    Gui Destroy
    Gui Script_:Show
}

Example_GuiEscape()
{
    Example_GuiClose()
}

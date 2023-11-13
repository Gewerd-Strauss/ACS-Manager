TotalConverted:=0
TotalCount:=675
Starttime:="20221009 19 4723"
  Ended:="20221009 20 00 58"
Starttime:="20221009194723"
  Ended:="20221009200058"
        TimeDur:=Ended-Starttime
        FormatTime, Readabletime, TimeDur,"hh:mm:ss"
        FormatTime, ReadableStart, Starttime,"hh:mm:ss"
        FormatTime, ReadableEnd, Ended,"HH:mm:ss"
         m("Conversion has finished.","Started:" SubStr(StartTime,9,2) ":" SubStr(StartTime,11,2) ":" SubStr(StartTime,13,2),"Ended:" SubStr(Ended,9,2) ":" SubStr(Ended,11,2) ":" SubStr(Ended,13,2))
return
Numpad1::
Starttime:=A_NOw
loop, 
{
    if GetKeyState("Esc")
        ExitApp
    WinActivate, AHK-Rare_TheGui
    WinWaitActive, AHK-Rare_TheGui
    SendInput, {Down}
    ; CurrFocus:=GetFocusedControl()
    ; guicontrol, focus, LVFunc
    ; if (CurrFocusName!="LVvalue")
        fFocusListView()
    ; SendInput, 
    ControlGetText,Code,RICHEDIT50W1,AHK-Rare_TheGui
    ControlGetText,Example,RICHEDIT50W2,AHK-Rare_TheGui
    ControlGetText,Description,RICHEDIT50W3,AHK-Rare_TheGui
    ControlGetText,ShortDesc,edit2,AHK-Rare_TheGui
    ; m(Code)
    ; m(Example)
    ; m(description)
    ; m(ShortDesc)
    DescVals:=[]
    Lines:=strsplit(ShortDesc,"`n")
    Lines2:=strsplit(Description,"`n")
    SnippetsStructure:=[]
    Snippet:={}
    Snippet.MetaData:={}
    Snippet.Code:=Code
    DescriptionPairs:=strsplit(Description,"`r`n`r`n")
    for k,v in DescriptionPairs
    {
        reassembly:=""
        out:=strsplit(v,"`r`n")
        loop,% out.Count()
        {
            if A_Index>1
                reassembly.="| "out[A_Index]
        }
        reassembly:=SubStr(reassembly, 2)
        if (out.2="--") || (out.1="") || (out.2="")
            continue
        DescVals[substr(out.1,1,StrLen(out.1)-1)]:=TRIM(reassembly)
    }
    Snippet.Example:=Example
    Snippet.Description:=Lines[5] "`n`n" Description

    ; if REs:=RegExMatch(Description,"((?<Key>AUTHOR)\:\r\n)(?<Value>.*)",v)
    ; if REs:=RegExMatch(Description,"((?<Key>DATE)\:\r\n)(?<Value>.*)",v)
        ; Snippet.Metadata.Date:=vValue
    Snippet.Metadata.Hash:=""
    Snippet.Metadata.License:=""
                                            Snippet.Metadata.Name:=Trim(strreplace(Lines[2],"`r"))
                                            Snippet.Metadata.Section:=Trim(strreplace(strreplace(Lines[8],"`r"),"Command Line","Command CommandLine"))
                                            Snippet.Metadata.SubSection:=Trim(strreplace(strreplace(Lines[14],"`r"),"Command Line","Command CommandLine"))
    if DescVals.HasKey("AHK-Version")
        Snippet.Metadata.URL:=DescVals["AHK-VERSION"]
    if DescVals.HasKey("AUTHOR")
        Snippet.Metadata.Author:=DescVals.Author
    if DescVals.HasKey("DATE")
        Snippet.Metadata.Date:=DateParse(DescVals.DATE)
    if DescVals.HasKey("dependencies")
        Snippet.Metadata.Dependencies:=DescVals.dependencies
    if DescVals.HasKey("KeyWords")
        Snippet.Metadata.KeyWords:=DescVals.KeyWords
    if DescVals.HasKey("Link")
        Snippet.Metadata.URL:=DescVals.Link
    ; if DescVals.HasKey("PARAMETER(s)")
    ;     Snippet.Metadata.Parameters:=DescVals["PARAMETER(s)"]
    ; if DescVals.HasKey("REMARK(s)")
    ;     Snippet.Metadata.Parameters:=DescVals["REMARK(s)"]
    ; if DescVals.HasKey("RETURN VALUE")
    ;     Snippet.Metadata.Parameters:=DescVals["RETURN VALUE"]
    if DescVals.HasKey("License")
    {
        license:=strsplit(DescVals["license"]," - ht").1
    }
        Snippet.Metadata.License:=License
    ; if DescVals.Count()!=Snippet.MetaData.Count()






    Snippet.MetaData.Library:="AHKRARE_Files"
    Snippet.Metadata.Version:=""
    if REs:=RegExMatch(Description,"((?<Key>AHK-Version)\:\r\n)(?<Value>.*)",v)
    Snippet.MetaData.AHK_Version:=vValue
    if REs:=RegExMatch(Description,"((?<Key>DEPENDENCIES)\:\r\n)(?<Value>.*)",v)
        Snippet.MetaData.Dependencies:=vValue
    SnippetsStructure[2]:=strsplit("|graphic|Varius get|Date or Time|Command CommandLine|Clipboard|gui - icon|gui - menu|gui - customise|gui - control type|gui - to change","|")
    global ConvertingAHKRARE:=true
    EditorImporter(Snippet,SnippetsStructure,true)
    ACS_ttip("Current:" TotalConverted++ "`nTotal:" TotalCount "`nTo go:" TotalCount-TotalConverted)
    if TotalConverted==TotalCount
    {
        Ended:=A_Now
        TimeDur:=Ended-Starttime
        FormatTime, Readabletime, TimeDur,"HH:ss"
        FormatTime, ReadableStart, Starttime,"HH:ss"
        FormatTime, ReadableEnd, Ended,"HH:ss"
        m("Conversion has finished.","Started:" ReadableStart,"Ended:" ReadableEnd,"Duration:"Readabletime)
    }
}
return
Starttime:=A_NOw
; "20221009194723"
; "20221009200058"
#Include %A_ScriptDir%\Editor\Editor.ahk
#Include %A_ScriptDir%\REWORK_AHK_LibraryGUI.ahk

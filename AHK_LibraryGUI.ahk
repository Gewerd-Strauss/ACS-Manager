#SingleInstance, Force
; #Warn,,Off 
#persistent
SetTitleMatchMode, 2
SendMode Input
SetWorkingDir, %A_ScriptDir%
CurrentMode:="Instr"
; Add scriptObj-template and convert Code to use it - maybe, just a thought. Syntax of the Library-File is probably way too special for doing so, and there are no real configs to save anyways
; separate library-files and settings-files, take a peek at ahk-rare to see what they store in settings
#Include <scriptObj>
FileGetTime, ModDate,%A_ScriptFullPath%,M
FileGetTime, CrtDate,%A_ScriptFullPath%,C
CrtDate:=SubStr(CrtDate,7,  2) "." SubStr(CrtDate,5,2) "." SubStr(CrtDate,1,4)
ModDate:=SubStr(ModDate,7,  2) "." SubStr(ModDate,5,2) "." SubStr(ModDate,1,4)
global script := {   base         : script
                    ,name         : regexreplace(A_ScriptName, "\.\w+")
                    ,version      : FileOpen(A_ScriptDir "\version.ini","r").Read()
                    ,author       : "Gewerd Strauss"
					,authorID	  : "Laptop-C"
					,authorlink   : ""
                    ,email        : ""
                    ,credits      : "Ixiko"
					,creditslink  : "https://github.com/Ixiko/AHK-Rare"
                    ,crtdate      : CrtDate
                    ,moddate      : ModDate
                    ,homepagetext : ""
                    ,homepagelink : ""
                    ,ghtext 	  : "GH-Repo"
                    ,ghlink       : "https://github.com/Gewerd-Strauss/AHK-Code-Snippets"
                    ,doctext	  : ""
                    ,doclink	  : ""
                    ,forumtext	  : ""
                    ,forumlink	  : ""
                    ,donateLink	  : ""
                    ,resfolder    : A_ScriptDir "\res"
                    ,iconfile	  : A_ScriptDir "\res\sct.ico"
					,rfile  	  : "https://github.com/Gewerd-Strauss/AHK-Code-Snippets/archive/refs/heads/Update()-Test.zip"
					,vfile_raw	  : "https://raw.githubusercontent.com/Gewerd-Strauss/AHK-Code-Snippets/Update()-Test/version.ini" 
					,vfile 		  : "https://raw.githubusercontent.com/Gewerd-Strauss/AHK-Code-Snippets/Update()-Test/version.ini" 
					,vfile_local  : A_ScriptDir "\version.ini" 
                    ,config:		[]
					,configfile   : A_ScriptDir "\INI-Files\" regexreplace(A_ScriptName, "\.\w+") ".ini"
                    ,configfolder : A_ScriptDir "\INI-Files"}
script.Load()
script.Update(,,1) ;; DO NOT ACTIVATE THISLINE UNTIL YOU DUMBO HAS FIXED THE DAMN METHOD. God damn it.
global Regex:={	 NewSnippet:"`r`n\\\\\\---NewSnippet---\\\\\\`r`n"
				,IDSearch:"id\\:\(\?<Ind>\\d\+\)"
				,SecSearch:"s\:(?<Ind>\d+)"
				,SnippetInd:"SnippetInd\:(?<SearchedInd>\d+)"
				,SectionInd:"Sec\:(?<SearchedInd>\d+)"
				,DescriptionLong:"ims)\s*\/\*\s*description(\(s\))*(?:\S+)?\n.*?\*\/"
				,Example:"ims)\s*\/\*\s*example(\(s\))*(?:\S+)?\n.*?\*\/"
				,StripFunctionName:"(\(.*\)\{*\s*)*\;*"
				,SnippetFinder:"(\\\\\\---NewSnippet---\\\\\\\n)*((?<FunctionName>.*)(\((?<Parameters>.*)\))*(?<BraceOnNameLine>\{?)\s?\;?\|\|\|SnippetInd\:(?<SnippetInd>.*),Section:(?<Section>\d*(\.\d*)*)\,Description:(?<Description>.*))"}
global Hashes:=[]
if IsObject(script.config.libraries)
{
	for k,v in script.config.libraries ; expand relative paths of Snippet libraries to full paths. So far only tested for libraries located within A_ScriptDir
	{
		if Instr(script.config.libraries.k,"%A_ScriptDir%")
			script.config.libraries[k]:=strreplace(script.config.libraries.v,"%A_ScriptDir%",A_ScriptDir)
		Else
			script.config.libraries[k]:=A_ScriptDir "\" v 
	}
	Arr:=fLoadFiles(script.config.libraries,Identifier:="\\ Script-settings \\")

}
else
	Arr:=fLoadFiles(script.config.libraries,Identifier:="\\ Script-settings \\")
Clipboard:=Arr.4
Arr.1:=Arr.1
global SectionNames:=fCreateIniObj(Arr.2) ;; contains SectionNames

Arr:=fParseArr(Arr.1,Identifier,Arr.3)
Snippets:=Arr.1
OrderKey:=Arr.2
GuiNameMain:="TotallyNotAHKRAre"
GuiNameIngestion:="Ingestion Helper"
FileRead, TODO, % A_ScriptDir "\Other\Todo-List.md"

; MsgBox, % TODO
RESettings :=
		( LTrim Join Comments
		{
		"TabSize"         	: 4,
		"Indent"           	: "`t",
		"FGColor"         	: 0xEDEDCD,
		"BGColor"        	: 0x172842,
		"Font"              	: {"Typeface": "Bitstream Vera Sans Mono", "Size": 10},
		"WordWrap"    	: False,

		"UseHighlighter"	: True,
		"HighlightDelay"	: 200,

		"Colors": {
			"Comments"		:	0x7F9F7F,
			"Functions"  	:	0x7CC8CF,
			"Keywords"  	:	0xE4EDED,
			"Multiline"   	:	0x7F9F7F,
			"Numbers"   	:	0xF79B57,
			"Punctuation"	:	0x97C0EB,
			"Strings"      	:	0xCC9893,

			; AHK
			"A_Builtins"   	:	0xF79B57,
			"Commands"		:	0xCDBFA3,
			"Directives"  	:	0x7CC8CF,
			"Flow"          :	0xE4EDED,
			"KeyNames"		:	0xCB8DD9,
			"Descriptions"	:	0xF0DD82,
			"Link"          :	0x47B856,

			; PLAIN-TEXT
			"PlainText"		:	0x7F9F7F
			}
		}
		)
RESettings2 :=
( LTrim Join Comments
{
	"TabSize": 4,
	"Indent": "`t",
	"FGColor": 0xEDEDCD,
	"BGColor": 0x3F3F3F,
	"Font": {"Typeface": "Consolas", "Size": 11},
	"WordWrap": False,
	
	"UseHighlighter": True,
	"HighlightDelay": 200,
	"Colors": {
		"Comments":     0x7F9F7F,
		"Functions":    0x7CC8CF,
		"Keywords":     0xE4EDED,
		"Multiline":    0x7F9F7F,
		"Numbers":      0xF79B57,
		"Punctuation":  0x97C0EB,
		"Strings":      0xCC9893,
		
		; AHK
		"A_Builtins":   0xF79B57,
		"Commands":     0xCDBFA3,
		"Directives":   0x7CC8CF,
		"Flow":         0xE4EDED,
		"KeyNames":     0xCB8DD9,
		
		; CSS
		"ColorCodes":   0x7CC8CF,
		"Properties":   0xCDBFA3,
		"Selectors":    0xE4EDED,
		
		; HTML
		"Attributes":   0x7CC8CF,
		"Entities":     0xF79B57,
		"Tags":         0xCDBFA3,
		
		; JS
		"Builtins":     0xE4EDED,
		"Constants":    0xF79B57,
		"Declarations": 0xCDBFA3
	}
}
)


; gosub, lGUICreate_1 ; Old hard coded form
gosub, lGUICreate_1New
return

lGuiCreate_2:
		gui, 2: destroy
		gui, 2: new, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border
		gui, +hwndIngestGUI
		if vsdb || (A_DebuggerName="Visual Studio Code")
			gui, -AlwaysOnTop
		gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
		gui_control_options2 :=  cForeground . " -E0x200"
		Gui, Margin, 16, 16
		
		; Gui,  -SysMenu -ToolWindow -caption +Border
		cBackground := "c" . "1d1f21"
		cCurrentLine := "c" . "282a2e"
		cSelection := "c" . "373b41"
		cForeground := "c" . "c5c8c6"
		cComment := "c" . "969896"
		cRed := "c" . "cc6666"
		cOrange := "c" . "de935f"
		cYellow := "c" . "f0c674"
		cGreen := "c" . "b5bd68"
		cAqua := "c" . "8abeb7"
		cBlue := "c" . "81a2be"
		cPurple := "c" . "b294bb"
		gui, font, s9 cWhite, Segoe UI
		vLastCreationScreenHeight:=vGuiHeight
		vLastCreationScreenWidth:=vGuiWidth
		if (!vGUIWidth and !vGuiHeight) || (vGUIWidth!=(A_ScreenWidth-20)) || (vGuiHeight!=(A_ScreenHeight)) ; assign outer gui dimensions either if they don't exist or if the resolution of the active screen has changed - f.e. when undocking or docking to a higher resolution display. The lGuiCreate_1-subroutine is also invoked in total if the resolution changes, but this is the necessary inner check to reassign dimensions.
		{ 
			vGUIWidth:=A_ScreenWidth - 20  ;-910
			vGUIHeight:=A_ScreenHeight 
		}
        	; vGUIWidth:=1920 - 20  ;-910
			; vGUIHeight:=1080
		vGuiHeight_Reduction:=60 
		vGuiHeightControl:=A_ScreenHeight-vGuiHeight_Reduction
		
		; if (vGUIHeight>vGuiHeightControl)
		; {
		; 	vGuiHeightOriginal:=vGuiHeight
		; 	vGUIHeight:=vGUIHeight-vGuiHeight_Reduction
		; }
		
		if vGUIWidth<1000
			f_ThrowError(A_ThisFunc,"Screen Width is smaller than 1000 pixels. As a result, the gui cannot be properly shown.`nIf this error is shown after opening the IniSettingsCreator, ignore it and open the gui again.",A_ScriptNameNoExt . "_"3, Exception("",-1).Line)

		vGUITabWidth:=vGUIWidth-30
        vGUITabRightEdge:=vGUITabWidth+15
        vGuiTabLeftEdge:=15
        vGUITabHeight:=vGUIHeight-45
        
        vGuiGroupBoxSearchBoxWidth:=vGUITabWidth*0.65-360

        vLV_LeftEdge:=vGuiTabLeftEdge+15
        vLV_RightEdge:=vGUITabRightEdge-15
        vLV_Width:=vLV_RightEdge-vLV_LeftEdge 


        ; vGuiGroupBoxSearchBoxWidth:= vLV_RightEdge-
        vxPosGroupBoxSearchBox:=vLV_RightEdge-(vLV_Width*0.65)
        vWidthGroupBoxSearchBox:=(vLV_Width*0.65)

        ; vxPosGroupBoxSearchBox:=vLV_RightEdge-vLV_Width*0.35
        vxPosGuiGroupBoxSearchBoxTRC:=vGUITabWidth-15-vGuiGroupBoxSearchBoxWidth+25

        ; vxPosGuiGroupBoxSearchBoxTRC
        vxDDLSearchBox:=vxPosGroupBoxSearchBox+20
        WidthDDL:=80
        xPosEdit:=(vxPosGroupBoxSearchBox+20)+90
        vWidthEditSearchBox:=vWidthGroupBoxSearchBox
        ; vWidthEditFSearchBox

        ; Position Left Edge SearchBox: vxPosGroupBoxSearchBox
        ; Position Right Edge SearchBox: vxPosGroupBoxSearchBox+vWidthGroupBoxSearchBox
        ; + Space To DDL: vxDDLSearchBox (+20)
        ; + Width DDL : + WidthDDLSearchBox
        ; + Space to Edit: vXDDLSearchBox + WidthDDLSearchBox + 20
        ; + Width Edit Field ??
        
        ; + Margin To groupBox 
        vLeftEdgeSearchBox:=vxPosGroupBoxSearchBox
        vRightEdgeSearchBox:=vxPosGroupBoxSearchBox+vWidthGroupBoxSearchBox
        vWidthSearchBox:=vRightEdgeSearchBox-vLeftEdgeSearchBox
        vInterElementAndBordeMargin:=3*15
        vSpaceAvaliableforEditAndDDL:=vWidthSearchBox-vInterElementAndBordeMargin
       
        vxPosDDL:=vLeftEdgeSearchBox+(vInterElementAndBordeMargin/3)
        WidthDDL:=WidthDDL
     
        vXPosEditField:=vLeftEdgeSearchBox + (vInterElementAndBordeMargin/3) + WidthDDL + (vInterElementAndBordeMargin/3)
        WidthEditField:=vRightEdgeSearchBox-vXPosEditField-(vInterElementAndBordeMargin/3)
        vRightEdgeEditToGroupBox_SearchBox:= (vxPosGroupBoxSearchBox+vWidthGroupBoxSearchBox)-20

        

        
        gui, font, s7 cRed, Segoe UI
        gui, add, Text, x0 y0 w0 h0, AnchorTopLeft2
        ; MAIN GUI GROUPBOX
        gui, add, groupbox, x15 y20 w%VGuiTabWidth% h%vGUITabHeight%

        ; GUI Search Box GroupBox
        gui, add, groupbox, x%vxPosGroupBoxSearchBox% y30 w%vWidthGroupBoxSearchBox% h90
        gui, font, s14 cRed, Segoe UI
        gui, add, text,x%vXPosDDL% y40, Search snippets
        gui, font, s11 cWhite, Segoe 
        gui, add, DDL,vSearchMethod x%vxPosDDL% y70 w%WidthDDL% vCurrentMode2 glSetSearchMethod2, Instr||RegEx
        gui, font, s11 cBlack, Segoe 
        vwEditSearchBox:=vxDDLSearchBox-120
        vGuiHeightAnchorHeightOfSearchBoxWidth:=55+70 ; 70is die Summe der y-verschiebung bis hierher

        gui, add, edit, x%vXPosEditField% y70 w%WidthEditField% cBlack glCheckStringForLVRestore2 vSearchString2 ,  New ; Search here
        gui, add, text, y%vGuiHeightAnchorHeightOfSearchBoxWidth% x0 w0                 vAnkerLV,  

        
        gui, font, s6
        gui, add, Listview, xp y%vGuiHeightAnchorHeightOfSearchBoxWidth% +Report ReadOnly x%vLV_LeftEdge% w%vLV_Width% h500 -vScroll vLVvalue2 glLV_Callback2, Section|Snippet Name|Short description|Snippet Identifier|Hash
		gui, show
		guicontrol, font, LVvalue2
        yAnkerLV2:=vGuiHeightAnchorHeightOfSearchBoxWidth+500
        gui, add, text, y%yAnkerLV2% x0                  vAnkerLV2,  
        yTopListView:=0+20+10+30+vGuiHeightAnchorHeightOfSearchBoxWidth
        ; yPosDescriptionField:=135+500+10
        yPosDescriptionField:=yAnkerLV2+15 ;vGUITabHeight
        hDescriptionField:=vGUITabHeight-yPosDescriptionField
        gui, font, s12, Segoe UI
        ;RC:=new RichCode(Settings,"ARG",1,200,"Highlighter" :Func("HighlightAHK"))
        gui, add, edit, y%yPosDescriptionField% x%vLV_LeftEdge% w300 h%hDescriptionField% disabled, Edit1
        yPosCodeField:=yPosDescriptionField
        xCodeField:=vLV_LeftEdge+300+15
        WidthCopyField:=vLV_RightEdge-xCodeField
        xPositionCopyField:=vLV_LeftEdge+100+300
        yAnchorREField:=yPosDescriptionField-20
        gui, add, text, y%yAnchorREField% xp+315 w0 h0, 
        ; gui, add, edit, yp x%xCodeField% w%WidthCopyField% h%hDescriptionField% vhiddenfield
        guicontrol, hide, %vhiddenfield%
        												; RC:=new RichCode(Settings,"ARG",1,200,"Highlighter" :Func("HighlightAHK"))
		global RC2:=new RichCode(RESettings2, yp " w" WidthCopyField " " xp " h" hDescriptionField,"IngestGui", HighlightBound=Func("HighlightAHK"))
        RC2.HighlightBound:=Func("HighlightAHK")
        ; gui, add, statusbar, -Theme vStatusBarMainWindow BackGround373b41 glCallBack_StatusBarMainWindow
        GuiControl, -Redraw, LVvalue2

        fPopulateLV(Snippets,SectionNames)

        GuiControl, +Redraw, LVvalue2
        SearchIsFocused:=Func("ControlIsFocused").Bind("Edit1")
        ListViewIsFocused:=Func("ControlIsFocused").Bind("SysListView321")
        EditFieldIsClicked:=Func("ControlIsFocused").Bind("Edit3")
        RCFieldIsClicked:=Func("ControlIsFocused").Bind("RICHEDIT50W1")

        GuiXPos:=(A_ScreenWidth-vGuiWidth)/2
        GuiYPos:=(A_ScreenHeight-vGuiHeight)/2
		gosub, lGuiShow_1
        Hotkey, IfWinActive, % "ahk_id " IngestGUI
        Hotkey, ^f, lFocusSearchBar
        Hotkey, ^s, lFocusSearchBar
        Hotkey, ^k, lFocusListView
		Hotkey, ^r, lGuiCreate_2
        Hotkey, if, % SearchIsFocused
        HotKey, ^BS, lDeleteWordFromSearchBar
        Hotkey, ^k, lFocusListView
        Hotkey, ~Enter, lSearchSnippetsEnter
        ; Hotkey, Del, lClearSearchbar


        Hotkey, if, % ListViewIsFocused
        Hotkey, ~Up, ListViewUp
        Hotkey, ~Down, ListViewDown
        
        hotkey, if, % RCFieldIsClicked
        Hotkey, ~RButton, lCopyScript
        Hotkey, ~LButton, lCopyScript
        hotkey, if, % EditFieldIsClicked
        Hotkey, ~RButton, lCopyScript
        Hotkey, ~LButton, lCopyScript
		; 1. RichEdit-Field to paste Code into
		; 2. DDL to choose Secion Name (allow for new ones to be added by string manually)
		; 3. Edit Field to addit Short Description String
		; 4. Edit Field to paste Snippet Name (if not a function)


		; snippet ind is global, not restricted to section
        ; GUI Search Box GroupBox
        ; gui, add, groupbox, x%vxPosGroupBoxSearchBox% y30 w%vWidthGroupBoxSearchBox% h90
        ; gui, font, s14 cRed, Segoe UI
        ; gui, add, text,x%vXPosDDL% y40, Search functions
        ; gui, font, s11 cWhite, Segoe 
        ; gui, add, DDL,vSearchMethod x%vxPosDDL% y70 w%WidthDDL% vCurrentMode glSetSearchMethod, Basic||RegEx
        ; gui, font, s11 cBlack, Segoe 
        ; vwEditSearchBox:=vxDDLSearchBox-120
        ; vGuiHeightAnchorHeightOfSearchBoxWidth:=55+70 ; 70is die Summe der y-verschiebung bis hierher

        ; gui, add, edit, x%vXPosEditField% y70 w%WidthEditField% cBlack glCheckStringForLVRestore vIngestionEdit1 ,  New ; Search here
        ; gui, add, text, y%vGuiHeightAnchorHeightOfSearchBoxWidth% x0 w0                 vAnkerLV,  

        
        ; gui, font, s9 cOrange, Segoe UI
        ; gui, add, Listview, xp y%vGuiHeightAnchorHeightOfSearchBoxWidth% +Report ReadOnly x%vLV_LeftEdge% w%vLV_Width% h500 -vScroll vLVvalueIngestion glLV_Callback, Section|Snippet Name|Short description|Snippet Identifier
        ; yAnkerLV2:=vGuiHeightAnchorHeightOfSearchBoxWidth+500
        ; gui, add, text, y%yAnkerLV2% x0                  vAnkerLV2,  
        ; yTopListView:=0+20+10+30+vGuiHeightAnchorHeightOfSearchBoxWidth
        ; yPosDescriptionField:=135+500+10
        ; yPosDescriptionField:=yAnkerLV2+15 ;vGUITabHeight
        ; hDescriptionField:=vGUITabHeight-yPosDescriptionField
        ; gui, font, s12, Segoe UI
        ;RC:=new RichCode(Settings,"ARG",1,200,"Highlighter" :Func("HighlightAHK"))
        ; gui, add, edit, y%yPosDescriptionField% x%vLV_LeftEdge% w300 h%hDescriptionField% disabled, Edit1
        ; yPosCodeField:=yPosDescriptionField
        ; xCodeField:=vLV_LeftEdge+300+15
        ; WidthCopyField:=vLV_RightEdge-xCodeField
        ; xPositionCopyField:=vLV_LeftEdge+100+300
        ; yAnchorREField:=yPosDescriptionField-20
        ; gui, add, text, y%yAnchorREField% xp+315 w0 h0, 
        ; ; gui, add, edit, yp x%xCodeField% w%WidthCopyField% h%hDescriptionField% vhiddenfield
        ; guicontrol, hide, %vhiddenfield%
        ; gui, add, tab, yp w%WidthCopyField% x%xCodeField% h%hDescriptionField%, CODE|Examples
        ; gui, add, text, yp x%xCodeField% w%WidthCopyField% h%hDescriptionField%, Text1
        ; GuiControl, Focus, % RC.hWnd
        ; gui, add, edit, yp w%WidthCopyField% x%xCodeField% h%hDescriptionField% v%vCopyField%,
        												; RC:=new RichCode(Settings,"ARG",1,200,"Highlighter" :Func("HighlightAHK"))
		; global RC:=new RichCode(RESettings2, yp " w" WidthCopyField " " xp " h" hDescriptionField,"MainGui", HighlightBound=Func("HighlightAHK"))
        ; RC.HighlightBound:=Func("HighlightAHK")
        gui, add, statusbar, -Theme vStatusBarMainWindow BackGround373b41 glCallBack_StatusBarMainWindow
        GuiControl, -Redraw, LVvalue

        fPopulateLV(Snippets,SectionNames)

        GuiControl, +Redraw, LVvalue
        SearchIsFocused:=Func("ControlIsFocused").Bind("Edit1")
        ListViewIsFocused:=Func("ControlIsFocused").Bind("SysListView321")
        EditFieldIsClicked:=Func("ControlIsFocused").Bind("Edit3")
        RCFieldIsClicked:=Func("ControlIsFocused").Bind("RICHEDIT50W1")

        GuiXPos:=(A_ScreenWidth-vGuiWidth)/2
        GuiYPos:=(A_ScreenHeight-vGuiHeight)/2
		; guicontrol, 1+Background1d1f21,vLVvalueIngestion
        Gui, Color, 1d1f21, 282a2e
		gosub, lGuiShow_2
		

; gui, 2: show,, IngestGui
		
return
lGuiShow_2:
gui, 1: hide
; hwndOT:=ObjTree(Snippets)
gui, 2: show, w%vGuiWidth% h%vGuiHeight%, % GuiNameIngestion
return


lGUICreate_1New: ;; Fully Parametric-form
		gui, 1: destroy
		gui, 1: new, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border +labelgResizing +Resize ;+MinSize1000x		
		gui, 1: default
		gui, +hwndMainGUI
		if vsdb || (A_DebuggerName="Visual Studio Code")
			gui, 1: -AlwaysOnTop
		gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
		gui_control_options2 :=  cForeground . " -E0x200"
		; Gui, Margin, 16, 16
		; Gui, Margin, 0,0
		
		; Gui,  -SysMenu -ToolWindow -caption +Border
		cBackground := "c" . "1d1f21"
		cCurrentLine := "c" . "282a2e"
		cSelection := "c" . "373b41"
		cForeground := "c" . "c5c8c6"
		cComment := "c" . "969896"
		cRed := "c" . "cc6666"
		cOrange := "c" . "de935f"
		cYellow := "c" . "f0c674"
		cGreen := "c" . "b5bd68"
		cAqua := "c" . "8abeb7"
		cBlue := "c" . "81a2be"
		cPurple := "c" . "b294bb"
		gui, font, s9 cWhite, Segoe UI
		vLastCreationScreenHeight:=vGuiHeight  
		vLastCreationScreenWidth:=vGuiWidth
		SysGet, Mon,MonitorWorkArea 
		if (!vGUIWidth and !vGuiHeight) || (vGUIWidth!=(A_ScreenWidth-20)) || (vGuiHeight!=(A_ScreenHeight)) ; assign outer gui dimensions either if they don't exist or if the resolution of the active screen has changed - f.e. when undocking or docking to a higher resolution display. The lGuiCreate_1-subroutine is also invoked in total if the resolution changes, but this is the necessary inner check to reassign dimensions.
		{ 
			vGUIWidth:=A_ScreenWidth*1.0 - 20  ;-910 ; 0.6@1440 starts clipping
			vGUIHeight:=MonBottom*1.0 - 20 
		}
		; vGuiHeight:=100
		; vGuiWidth:=100
		gui, font, s7 cRed, Segoe UI
		{
					; checked values will be indented unto this level

			; Define Parameters - Margins
				WidthMargin_Global:=vGuiWidth*0.01
				HeightMargin_Global:=vGuiHeight*0.01

			; Define Parameters - SearchBox:										
				;; ratio's checked on 100%-model
		xPos_Search_GroupBox:=vGuiWidth*0.47 
		yPos_Search_GroupBox:=vGuiHeight*0.01
		Height_Search_GroupBox:=vGuiHeight*0.08
					Width_Search_GroupBox:=vGuiWidth-(xPos_Search_GroupBox+WidthMargin_Global)
					gui, add, groupbox, x%xPos_Search_GroupBox% y%yPos_Search_GroupBox% w%Width_Search_GroupBox% h%Height_Search_GroupBox%
				
			; Define Parameters - Text XX Snippets
					xPos_Text_XXSnippetsLoaded:=xPos_Search_GroupBox											+WidthMargin_Global
					yPos_Text_XXSnippetsLoaded:=yPos_Search_GroupBox											+(HeightMargin_Global/2)
		Width_Text_XXSnippetsLoaded:=Width_Search_GroupBox*0.3
		Height_Text_XXSnippetsLoaded:=Height_Search_GroupBox*0.3
					gui, font, s14 cRed, Segoe UI
        			gui, add, text,x%xPos_Text_XXSnippetsLoaded%  y%yPos_Text_XXSnippetsLoaded% vvSearchFunctions, _____________________________________________

			; Define Parameters - DDL Searchmode:
					xPos_DDL_SearchMode:=xPos_Text_XXSnippetsLoaded
					yPos_DDL_SearchMode:=yPos_Text_XXSnippetsLoaded+Height_Text_XXSnippetsLoaded				+(HeightMargin_Global/2)
				Width_DDL_SearchMode:=Width_Text_XXSnippetsLoaded ;; note: this seems extensively too large
					Height_DDL_SearchMode:=Height_Search_GroupBox-yPos_DDL_SearchMode							-(HeightMargin_Global/2)
					gui, font, s11 cWhite, Segoe 
        			gui, add, DDL,vSearchMethod x%xPos_DDL_SearchMode% y%yPos_DDL_SearchMode% h%Height_DDL_SearchMode% vCurrentMode glSetSearchMethod HwndCurrentModeHWND, Instr||RegEx
					AddToolTip(CurrentModeHWND,"Select between Normal Instr()- and Regex-Search")
			; Define Parameters: Edit Searchmode
					xPos_Edit_SearchMode:=xPos_DDL_SearchMode+Width_DDL_SearchMode+WidthMargin_Global
					yPos_Edit_SearchMode:=yPos_DDL_SearchMode
					Width_Edit_SearchMode:=Width_Search_GroupBox-Width_DDL_SearchMode-3*WidthMargin_Global
					Height_Edit_SearchMode:=Height_DDL_SearchMode
					gui, font, s11 cBlack, Segoe 
        			gui, add, edit, x%xPos_Edit_SearchMode% y%yPos_Edit_SearchMode% w%Width_Edit_SearchMode% r1 cBlack glCheckStringForLVRestore vSearchString HwndSearchStringHWND,  ; Search here
					AddToolTip(SearchStringHWND,"Enter search string. Use key 'ID:xx' to search by function ID, and key 's:xx' to search by section index")
			; Define Parameters - ListView
					xPos_ListView:=WidthMargin_Global
	yFraction_ListView:=0.1
	HeightFraction_ListView:=0.40
					yPos_ListView:=vGuiHeight*yFraction_ListView
					Width_ListView:=vGuiWidth-2*WidthMargin_Global
					Height_ListView:=vGuiHeight*HeightFraction_ListView
        			gui, font,s8
					gui, add, Listview, x%xPos_ListView% y%yPos_ListView% w%Width_ListView% h%Height_ListView% +Report ReadOnly  -vScroll vLVvalue glLV_Callback, Section|Snippet Name|Short description|Hash|Snippet Identifier
					guicontrol, font, LVvalue
			; Define Parameters - Description Box
					xPos_DescriptionBox:=WidthMargin_Global
		yPos_DescriptionBox:=(yPos_ListView+Height_ListView+(HeightMargin_Global))			;;vGuiHeight*HeightFraction_UpToDescriptionBox:=(HeightFraction_ListView+yFraction_ListView+(HeightMargin_Global/100))		;; yPos_ListView+HeightListView+1*Margin
		Width_DescriptionBox:=vGuiWidth*(0.135+0.02+0.005)
		Height_DescriptionBox:= vGuiHeight*((vGuiHeight-(yPos_DescriptionBox+2*HeightMargin_Global))/vGuiHeight)  ;vGuiHeight*d:=(1-(HeightFraction_UpToDescriptionBox+(HeightMargin_Global/100)))
													; yPos_DescriptionBox:=vGuiHeight*(0.71)
													; Width_DescriptionBox:=vGuiWidth*(0.135+0.02+0.005)
													; Height_DescriptionBox:=vGuiHeight*0.275
					gui, font, s12, Segoe UI
					gui, add, edit, y%yPos_DescriptionBox% x%xPos_DescriptionBox% w%Width_DescriptionBox% h%Height_DescriptionBox% vvEdit1 disabled, Edit1
			; Define Parameters - Tab3

					xPos_Tab3:=xPos_DescriptionBox+Width_DescriptionBox+(WidthMargin_Global/1)
					yPos_Tab3:=yPos_DescriptionBox
					; FractionTab3:=(100-((xPos_Tab3-2*WidthMargin_Global)))
					Width_Tab3:=((vGuiWidth-(Width_DescriptionBox+3*WidthMargin_Global)))
					Height_Tab3:=Height_DescriptionBox
					gui, font,
					gui, add, tab,y%yPos_Tab3% x%xPos_Tab3% w%Width_Tab3%  h%Height_Tab3%, CODE||Examples|Description
			; Define Parameters - Richfields
			{		;; Definition set 1
		xPos_RichCode:=xPos_Tab3+WidthMargin_Global*2
		yPos_RichCode:=yPos_Tab3+HeightMargin_Global*2
				Width_RichCode:=Width_Tab3-2*WidthMargin_Global
				Height_RichCode:=Height_Tab3-2*HeightMargin_Global
			; RichField1
			gui, tab, CODE
			global RC:=new RichCode(RESettings2, "y" yPos_RichCode " x" xPos_RichCode  " w" Width_RichCode " h" Height_RichCode,"MainGui", HighlightBound=Func("HighlightAHK"))

			}

        	RC.HighlightBound:=Func("HighlightAHK")
        	GuiControl, -Redraw, LVvalue
        	fPopulateLV(Snippets,SectionNames)
        	GuiControl, +Redraw, LVvalue
			gosub, lGuiShow_1

		}
/*


        	; vGUIWidth//=2
  			; vGUIHeight//=2
		; vGuiHeight_Reduction:=60 
		; vGuiHeightControl:=A_ScreenHeight-vGuiHeight_Reduction
		
		; if (vGUIHeight>vGuiHeightControl)
		; {
		; 	vGuiHeightOriginal:=vGuiHeight
		; 	vGUIHeight:=vGUIHeight-vGuiHeight_Reduction
		; }
		
		if vGUIWidth<1000
			f_ThrowError(A_ThisFunc,"Screen Width is smaller than 1000 pixels. As a result, the gui cannot be properly shown.`nIf this error is shown after opening the IniSettingsCreator, ignore it and open the gui again.",A_ScriptNameNoExt . "_"3, Exception("",-1).Line)

		; vGUITabWidth:=vGUIWidth-30
        ; vGUITabRightEdge:=vGUITabWidth+15
        ; vGuiTabLeftEdge:=15
        ; vGUITabHeight:=vGUIHeight-45
        
        ; vGuiGroupBoxSearchBoxWidth:=vGUITabWidth*0.65-360

        ; vLV_LeftEdge:=vGuiTabLeftEdge+15
        ; vLV_RightEdge:=vGUITabRightEdge-15
        ; vLV_Width:=vLV_RightEdge-vLV_LeftEdge 
		; vLV_Height:=(vGuiHeight*0.3)


        ; ; vGuiGroupBoxSearchBoxWidth:= vLV_RightEdge-
        ; vxPosGroupBoxSearchBox:=vLV_RightEdge-(vLV_Width*0.65)
		; vyPosGroupBoxSearchBox:=vGuiHeight*0.01
        ; vWidthGroupBoxSearchBox:=(vLV_Width*0.65)
		; vHeightGroupBoxSearchBox:=vGUIHeight*0.1

        ; ; vxPosGroupBoxSearchBox:=vLV_RightEdge-vLV_Width*0.35
        ; vxPosGuiGroupBoxSearchBoxTRC:=vGUITabWidth-15-vGuiGroupBoxSearchBoxWidth+25

        ; ; vxPosGuiGroupBoxSearchBoxTRC
        ; vxDDLSearchBox:=vxPosGroupBoxSearchBox+20
        ; WidthDDL:=80
        ; xPosEdit:=(vxPosGroupBoxSearchBox+20)+90
        ; vWidthEditSearchBox:=vWidthGroupBoxSearchBox
        ; ; vWidthEditFSearchBox

        ; ; Position Left Edge SearchBox: vxPosGroupBoxSearchBox
        ; ; Position Right Edge SearchBox: vxPosGroupBoxSearchBox+vWidthGroupBoxSearchBox
        ; ; + Space To DDL: vxDDLSearchBox (+20)
        ; ; + Width DDL : + WidthDDLSearchBox
        ; ; + Space to Edit: vXDDLSearchBox + WidthDDLSearchBox + 20
        ; ; + Width Edit Field ??
        
        ; ; + Margin To groupBox 
        ; vLeftEdgeSearchBox:=vxPosGroupBoxSearchBox
        ; vRightEdgeSearchBox:=vxPosGroupBoxSearchBox+vWidthGroupBoxSearchBox
        ; vWidthSearchBox:=vRightEdgeSearchBox-vLeftEdgeSearchBox
        ; vInterElementAndBordeMargin:=3*15
        ; vSpaceAvaliableforEditAndDDL:=vWidthSearchBox-vInterElementAndBordeMargin
       
        ; vxPosDDL:=vLeftEdgeSearchBox+(vInterElementAndBordeMargin/3)
        ; WidthDDL:=WidthDDL
     
        ; vXPosEditField:=vLeftEdgeSearchBox + (vInterElementAndBordeMargin/3) + WidthDDL + (vInterElementAndBordeMargin/3)
        ; WidthEditField:=vRightEdgeSearchBox-vXPosEditField-(vInterElementAndBordeMargin/3)
        ; vRightEdgeEditToGroupBox_SearchBox:= (vxPosGroupBoxSearchBox+vWidthGroupBoxSearchBox)-20

        
*/
        
        
        ; gui, add, Text, x0 y0 w0 h0, AnchorTopLeft1awdawdwad
        ; MAIN GUI GROUPBOX
        ; gui, add, groupbox, x15 y20 w%VGuiTabWidth% h%vGUITabHeight% ;; activating this line will result in the Tab-control not showing. I have no clue _why_ that is the case, but it is.

        ; GUI Search Box GroupBox
       
		; vHeightTextSearchFunctions:=vHeightGroupBoxSearchBox*0.3
		; vyPosSearchFunctionsText:=vyPosGroupBoxSearchBox+5
		; vyPosSearchFunctionsDDL
        
        
        ; vwEditSearchBox:=vxDDLSearchBox-120
        ; vGuiHeightAnchorHeightOfSearchBoxWidth:=55+70 ; 70is die Summe der y-verschiebung bis hierher

        
        ; gui, add, text, y%vGuiHeightAnchorHeightOfSearchBoxWidth% x0 w0                 vAnkerLV,  

      
        ; yAnkerLV2:=vGuiHeightAnchorHeightOfSearchBoxWidth
        ; gui, add, text, y%yAnkerLV2% x0                  vAnkerLV2,  
        ; yTopListView:=0+20+10+30+vGuiHeightAnchorHeightOfSearchBoxWidth
        ; yPosDescriptionField:=135+500+10
        ; yPosDescriptionField:=yAnkerLV2+20 ;vGUITabHeight
		; yPosDescriptionField:=vLV_Height
        ; hDescriptionField:=vGUITabHeight-yPosDescriptionField+5
        ;RC:=new RichCode(Settings,"ARG",1,200,"Highlighter" :Func("HighlightAHK"))
        
        ; yPosCodeField:=yPosDescriptionField
        ; xCodeField:=vLV_LeftEdge+300+15
        ; WidthCopyField:=vLV_RightEdge-xCodeField
        ; xPositionCopyField:=vLV_LeftEdge+100+300
        ; yAnchorREField:=yPosDescriptionField-15
        ; gui, add, text, y%yAnchorREField% xp+315 w0 h0, 
        ; gui, add, edit, yp x%xCodeField% w%WidthCopyField% h%hDescriptionField% vhiddenfield
        ; guicontrol, hide, %vhiddenfield%
		; xGuiTab:=vLV_RightEdge-(vLV_LeftEdge)
		
		; guicontrol, hide, vEdit1
		
		
		gui, tab, Examples
		global RC2:=new RichCode(RESettings2, "y" yPos_RichCode " x" xPos_RichCode  " w" Width_RichCode " h" Height_RichCode,"MainGui", HighlightBound=Func("HighlightAHK"))
        RC2.HighlightBound:=Func("HighlightAHK")
        
		gui, tab, Description
		global RC3:=new RichCode(RESettings2, "y" yPos_RichCode " x" xPos_RichCode  " w" Width_RichCode " h" Height_RichCode,"MainGui", HighlightBound=Func("HighlightAHK"))
        RC3.HighlightBound:=Func("HighlightAHK")
		; gui, add, statusbar, -Theme vStatusBarMainWindow BackGround373b41 glCallBack_StatusBarMainWindow
        
        SearchIsFocused:=Func("ControlIsFocused").Bind("Edit1")
        ListViewIsFocused:=Func("ControlIsFocused").Bind("SysListView321")
        EditFieldIsClicked:=Func("ControlIsFocused").Bind("Edit3")
        RCFieldIsClicked:=Func("ControlIsFocused").Bind("RICHEDIT50W1")
		gui, tab

		gui, add, statusbar, -Theme vStatusBarMainWindow BackGround373b41 glCallBack_StatusBarMainWindow ; finish up statusbar - settings, updating library/adding additional libraries
		gosub, lGuiShow_1
        Hotkey, IfWinActive, % "ahk_id " MainGUI
		Hotkey, ^Tab,lTabThroughTabControl
        Hotkey, ^f, lFocusSearchBar
        Hotkey, ^s, lFocusSearchBar
        Hotkey, ^k, lFocusListView
		Hotkey, ^r, lGuiCreate_2
        Hotkey, if, % SearchIsFocused
        HotKey, ^BS, lDeleteWordFromSearchBar
        Hotkey, ^k, lFocusListView
        Hotkey, ~Enter, lSearchSnippetsEnter
        Hotkey, Del, lClearSearchbar

        Hotkey, if, % ListViewIsFocused
        Hotkey, ~Up, ListViewUp
        Hotkey, ~Down, ListViewDown
        
        hotkey, if, % RCFieldIsClicked
        Hotkey, ~RButton, lCopyScript
        Hotkey, ~LButton, lCopyScript
        hotkey, if, % EditFieldIsClicked
        Hotkey, ~RButton, lCopyScript
        Hotkey, ~LButton, lCopyScript
		; Gui, Color, 4f1f21, 432a2e
		; gosub, lFocusListView
		; sleep, 300
		gosub, ListViewDown
		LastScaledSize:=[vGUIWidth,vGUIHeight]
return
Resizing:
ResizeSub:
gui,1: submit, NoHide
m(Resizing)
return
lGuiHide_1:
gui, 1: hide
return
lGuiShow_1:
gui, 1: show, w%vGuiWidth% h%vGuiHeight%, % GuiNameMain
gosub, lFocusListView
return
; Original: http://ahkscript.org/boards/viewtopic.php?t=1079
AutoSize(DimSize, cList*) {				; retrieved from https://www.autohotkey.com/boards/viewtopic.php?p=417609#p417609
    Static cInfo := {}
    Local

    If (DimSize = "reset") {
        Return cInfo := {}
    }

    For i, ctrl in cList {
        ctrlID := A_Gui . ":" . ctrl
        If (cInfo[ctrlID].x = "") {
            GuiControlGet i, %A_Gui%: Pos, %ctrl%
            MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
            fx := fy := fw := fh := 0
            For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) {
                If (!RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)) {
                    f%dim% := 1
                }
            }

            If (InStr(DimSize, "t")) {
                GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
                hWndParent := DllCall("GetParent", "Ptr", hWnd, "Ptr")
                VarSetCapacity(RECT, 16, 0)
                DllCall("GetWindowRect", "Ptr", hWndParent, "Ptr", &RECT)
                DllCall("MapWindowPoints", "Ptr", 0, "Ptr"
                , DllCall("GetParent", "Ptr", hWndParent, "Ptr"), "Ptr", &RECT, "UInt", 1)
                ix -= (NumGet(RECT, 0, "Int") * 96) // A_ScreenDPI
                iy -= (NumGet(RECT, 4, "Int") * 96) // A_ScreenDPI
            }

            cInfo[ctrlID] := {x: ix, fx: fx, y: iy, fy: fy, w: iw, fw: fw, h: ih, fh: fh, gw: A_GuiWidth, gh: A_GuiHeight, a: a, m: MMD}

        } Else If (cInfo[ctrlID].a.1) {
            dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw
            dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh

            Options := ""
            For i, dim in cInfo[ctrlID]["a"] {
                Options .= dim . (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) . A_Space
            }

            GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
        }
    }
}
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
	static cInfo := {}
	
	If (DimSize = "reset")
		Return cInfo := {}
	
	For i, ctrl in cList {
		ctrlID := A_Gui ":" ctrl
		If ( cInfo[ctrlID].x = "" ){
			GuiControlGet, i, %A_Gui%:Pos, %ctrl%
			MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
			fx := fy := fw := fh := 0
			For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
				If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
					f%dim% := 1
			cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
		}Else If ( cInfo[ctrlID].a.1) {
			dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
			For i, dim in cInfo[ctrlID]["a"]
				Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
			GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
} } }
lFocusListView:
guicontrol, focus, LVvalue
return
lDeleteWordFromSearchBar:
SendInput, ^+{Left}{Del}{ShiftUp}{CtrlUp}}
return
lClearSearchbar:
guicontrol,,SearchString
return

lTabThroughTabControl:
SendINput, ^{PgDn}
return
lFocusSearchBar:
guicontrol, focus, SearchString
lCopyScript:
SelectedLVEntry:=f_GetSelectedLVEntries()
res:=Snippets[SelectedLVEntry.1.1.Hash].Code
ClipBoard:=RegExReplace(res,Regex.NewSnippet)
if (Clipboard==RegExReplace(res,Regex.NewSnippet))
	ttip("Snippet " SelectedLVEntry.1.1.SelectedEntryName " copied")
return
lSetSearchMethod: 
lSetSearchMethod2: 
gui, submit, NoHide
return

lCallBack_StatusBarMainWindow:
; not implemented yet
return
lLV_Callback:
lLV_Callback2:
gui, submit, Nohide
if (A_GuiControlEvent="ColClick")
	return
SelectedLVEntry:=f_GetSelectedLVEntries()		
Data:=Snippets[d:=SelectedLVEntry.1.1.Hash]		;; using name could be problematic when having multiple snippets  of same name
f_FillFields(Data)
return

lCheckStringForLVRestore: 
lCheckStringForLVRestore2: 
gosub, lSearchSnippets
Gui, 1: Submit, NoHide
if (SearchString!="")
    return
GuiControl, -Redraw, LVvalue
fPopulateLV(Snippets,SectionNames)
GuiControl, +Redraw, LVvalue
return

lSearchSnippetsEnter:
; A_GuiControl A_ThisHotkey A_ThisFunc A_THisLabel A_GuiControlEvent A_GuiEvent | always useful having these here when checking annoying states
lSearchSnippets:
Gui, 1: Submit, NoHide
if (A_ThisLabel="lSearchSnippetsEnter")
{
	guicontrol, focus, SysListView321
	sleep, 1200
	SendInput, {Down Down} 
	Sleep, 100
	SendInput, {Down Up} 
}
results:=[]
prelimresults:=[]
if Instr(SearchString,"s:") && Instr(SearchString,"id:") 		; search both sectionID and snippetID
{
	if RegExMatch(SearchString,Regex.IDSearch,s)			
	{
		prelimresults:=f_FindOccurences("SnippetInd:" sInd,Arr.1,CurrentMode) ;; first search for snippetID
		if RegExMatch(SearchString,Regex.SecSearch,s)
			results:=f_FindOccurences("Sec:"sInd,prelimresults,CurrentMode) ;; next search for sectionID
	}
	if RegExMatch(SearchString,Regex.SecSearch,s)			
	{
		prelimresults:=f_FindOccurences("Sec:" sInd,Arr.1,CurrentMode) ;; first search for sectionID
		if RegExMatch(SearchString,Regex.IDSearch,s)
			results:=f_FindOccurences("SnippetInd:"sInd,prelimresults,CurrentMode) ;; next search for snippetID
	}		
}
else if Instr(SearchString,"id:") && !Instr(SearchString,"s:") 			; search only snippetID
{
	if RegExMatch(SearchString,Regex.IDSearch,s)
		prelimresults:=f_FindOccurences("SnippetInd:" sInd,Arr.1,CurrentMode) ;; search snippet code ||  MISSING: Find in Section
}
else if Instr(SearchString,"s:") && !Instr(SearchString,"id:") 		; search only sectionID
{
	if RegExMatch(SearchString,Regex.SecSearch,s)
		prelimresults:=f_FindOccurences("Sec:"sInd,Arr.1,CurrentMode) ;; search snippet code ||  MISSING: Find in Section
}
else																; search neither
	prelimresults:=f_FindOccurences(SearchString,Arr.1,CurrentMode) ;; search snippet code ||  MISSING: Find in Section

/*
TODO: figure out how to combine results from id/sec-search with actual string searches - need to decide on a syntax to strip away the s:/id: portion, and then continue on the found snippets with the remainder of the string.
*/
if results.Length()=0
	results:=prelimresults.Clone()		;; make sure the right set is used 
GuiControl, -Redraw, LVvalue
fPopulateLV(results,SectionNames)
rcount:=results.Count()
str:=rcount " snippets found." 
GuiControl,,vSearchFunctions,% str
GuiControl, +Redraw, LVvalue
Settimer, lResetSearchFunctionsString, -2300
return

lResetSearchFunctionsString:
GuiControlGet, ContentsSearchField,,SearchString
if (ContentsSearchField="")
	GuiControl,, vSearchFunctions,% "Search in " snippets.count() " snippets"
return

Numpad0::
if WinActive(GuiNameMain)
    gosub, lGuiHide_1
else
    gosub, lGuiShow_1
return 

ShowFunctionsOnUpDown:
ListViewUp:
ListViewDown:
If Instr(A_ThisLabel, "ListViewUp")
		Send, {Up}
else
		Send, {Down}
ttip("Pressing enter should immediately select the LV, then load the very first result and stay focused on it - not sure what's going on" Exception.Line())  ;; TODO - replace this by a tooltip attached to the LV-control
selRow:= LV_GetNext("F")
gosub, lLV_Callback
return

#If WinActive(GuiNameMain)
Esc::
gui, 1: hide
return
#if Winactive(GuiNameIngestion)
Esc::
gui, 2: destroy
gui, 1: show
return
#If (A_ComputerName=script.AuthorID?1:0) 
!esc::
reload
return ; yes I know this is not actually needed. I don't care.

f_CollectMatchingEntries(results,Arr)
{	; probably Deprecated
    SearchResults:={}
    for FunctionName, FunctionArray in Arr[1]
    {
        for ind, FoundLineInd in results
        {
            if (FoundLineInd>=FunctionArray.StartLine && FoundLineInd<=FunctionArray.LastLine) 
            {
                SearchResults[FunctionName]:=FunctionArray
            }
            if (FoundLineInd=FunctionArray.StartLine) 
            {
                SearchResults[FunctionName]:=FunctionArray
            }
            if (FoundLineInd=FunctionArray.LastLine)
            {
                SearchResults[FunctionName]:=FunctionArray
            }
        }

        ; ; IndNextFunctionName:=""
        ; ; IndNextFunctionName:=HasVal(Arr[2],FunctionName)
        ; ; IndNextFunctionName++
        ; ; NextFunctionName:=Arr[2 , IndNextFunctionName]

        ; SearchResults[NextFunctionName]:=Arr[1 , NextFunctionName]
    }
    return SearchResults
}

f_GetLastFuncLines(Arr)
{
    FirstFuncLines:=[]
    for k,v in Arr[2]
    {
        FirstFuncLines.push(Arr.1[v].StartLine)
    }
    LastFuncLines:=[]
}

f_FindOccurences(String,Array,Mode=1)
{
	SnippedOccurences:=[]
	if RegexMatch(String, Regex.SnippetInd,s)
	{	
		for SnippetIndex, Snippet in Array
		{
			if Instr(Snippet.Ind,sSearchedInd) || Instr(Snippet.Ind,Ltrim(sSearchedInd,0))
				SnippedOccurences.push(Snippet)
		}
	}
	else if RegexMatch(String, Regex.SectionInd,s)
	{	
		for SnippetIndex, Snippet in Array
		{
			if Instr(Snippet.Section,sSearchedInd) || Instr(Snippet.Section,Ltrim(sSearchedInd,0))
				SnippedOccurences.push(Snippet)
		}
	}
	else
	{

		if (Mode=1) || (Mode="Instr") ; normal
		{
			for SnippetIndex, Snippet in Array
			{
				if (String="") || (Snippet="")
					continue
				If instr(Snippet.Code,String)
					SnippedOccurences.push(Snippet)

			}
		}
		else if (Mode=2) || (Mode="Regex") ; Regex
		{
			for SnippetIndex, Snippet in Array
			{
				if (String="") || (v="")
					continue
				If RegExMatch(Snippet.Code, String)
					SnippedOccurences.push(Snippet)
			}
		}
	}
    return SnippedOccurences
}

HasVal(haystack, needle) 
	{	; code from jNizM on the ahk forums: https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
 		if !(IsObject(haystack)) || (haystack.Length() = 0)
			return 0
		for index, value in haystack
			if (value = needle)
				return index
		return 0
	}
	

f_GetSelectedLVEntries()
{ ;A_DefaultListView
    vRowNum:=0
    sel:=[]
    loop 
    {
        vRowNum:=LV_GetNext(vRowNum)
        if not vRowNum  ; The above returned zero, so there are no more selected rows.
            break
        LV_GetText(sCurrText1,vRowNum,1)
        LV_GetText(sCurrText2,vRowNum,2)
        LV_GetText(sCurrText3,vRowNum,3)
        LV_GetText(sCurrText4,vRowNum,4)
        LV_GetText(sCurrText5,vRowNum,5)
		; LV_GetText(sCurrText6,vRowNum,6)
        sel[A_Index]:={SelectedEntrySection:sCurrText1,SelectedEntryName:sCurrText2,SelectedEntryDescription:sCurrText3,SelectedEntrySnippetIdentifier:sCurrText5,Hash:sCurrText4}
        return [sel,vRowNum]
    }
}

fPopulateLV(Snippets,SectionNames)
{
    LV_Delete()
	Snips:=Snippets.Clone()
	NewSnippetsSorted:=[]
	SectionIndexLength:=1
	SectionPad:=""
	for k,v in Snippets
		SectionIndexLength:=(StrLen(SectionNames.MaxIndex())>SectionIndexLength?StrLen(SectionNames.MaxIndex()):SectionIndexLength)
	loop, % SectionIndexLength
		SectionPad.="0"
	if (2>1)
	{				;; new Snippet Indexing ensures that snippet identifiers across each section constitute a list from 1 → Section.Count(), instead of treating section and snippet identifier separately.
		for SecInd,thisSec in SectionNames
		{
			SectionSpecificIndex:=1
			for k,v in Snippets
				if (v.Section==SecInd) ;; 
				{
					v.FileInd:=v.Ind
					v.Ind:=fPadIndex(SectionSpecificIndex++,Snippets.Count())	;; v.Ind is now section-specific, and this is the one being displayed
				}
		}
		for k,v in Snippets
		{
			Addition:=[]
			Addition.Section:=(fPadIndex(v.Section,SectionPad)) " - " (SectionNames[strsplit(v.Section,".").1]=""?"-1 INVALIDSECTIONKEY":SectionNames[strsplit(v.Section,".").1])
			Addition.Name:=RegExReplace(v.Name,Regex.StripFunctionName)
			Addition.Description:=v.Description
			Addition.Hash:=v.Hash
			; Addition.LVInd:=fPadIndex(v.Section,Snippets.Count())"." fPadIndex((Instr(A_ThisLabel,"lSearchSnippets")?v.FileInd:v.Ind),"00")	;; WORKING VERSION; EXCEPT SECTION ID NOT PADDED
			Addition.LVInd:=fPadIndex(v.Section,SectionPad)"." fPadIndex((Instr(A_ThisLabel,"lSearchSnippets")?v.FileInd:v.Ind),"00")
			LV_Add("-E0x200",		Addition.Section,		Addition.Name,		Addition.Description,		Addition.Hash,		Addition.LVInd		)
		}
	}
	LV_ModifyCol(4,0) 
	LV_ModifyCol(5,"Right")
    LV_ModifyCol(3,"AutoHdr")
    LV_ModifyCol(1,"AutoHdr")
    LV_ModifyCol(4,"Right")
	LV_ModifyCol(5,"AutoHdr")
    LV_ModifyCol(2,"AutoHDr")
	LV_ModifyCol(5,"Sort")
	str:=snippets.count() " snippets loaded" 
	guicontrol,,vSearchFunctions,% str
    return
}

f_FillFields(Data)
{
	RC.Settings.Highlighter := "HighlightAHK"
	RC.Value := []
	code:=RegExReplace(Data.code,Regex.NewSnippet)
	code:=RegexReplace(code,Regex.DescriptionLong)
	RC.Value:=RegexReplace(code,Regex.Example)
	RC2.Value:=out:=LTrim(Data.HasKey("DescriptionLong")?Data.Example:"","`n`t")
	RC3.Value:=LTrim(Data.HasKey("Example")?Data.DescriptionLong:"","`n`t")
    Name:=RegExReplace(Data.Name,Regex.StripFunctionName)
    SectionName:=FindSectionName(Data.Section)
    MainSecDescription:=Data.Description
    e=
    (LTrim
        FUNCTION:
        %name%
        -------------------------------------------
        MAIN SECTION:
        %SectionName%
        -------------------------------------------
        SHORT DESCRIPTION:
        %MainSecDescription%
        -------------------------------------------
    )
    if MainSecDescription
    {
        e.=		;; wtf is this for?
        (
                HELLO WORLD
        )
    }
    guicontrol,1:, Edit2,% e
}

FindSectionName(ThisSec)
{
    return SectionNames[strsplit(ThisSec,".").1]
}

ControlIsFocused(ControlID) {                                                                  	;-- true or false if specified gui control is active or not

	GuiControlGet, FControlID, 1:Focus
	If Instr(FControlID, ControlID)
			return true

return false
}



fLoadFiles(File,Identifier)
{		; loads multitude of files into the GUI
 	if IsObject(File)
	{
		Ret:=[]
		; Ind:=1
		for k,v in File
		{
			FileRead, f, % v
			Clipboard:=f0:=f
			if !Instr(f,Identifier)
        		f_ThrowError(A_ThisFunc,"Settings for " script.name " could not be loaded. The string '" Identifier "'  is missing.",A_ThisFunc . "_" 1, Exception("",-1).Line)
			f:=strsplit(f,Identifier)
    		Ret[k]:=[strsplit(f.1,"`n"),f.2,strsplit(f.1,"\\\---NewSnippet---\\\"),f0,v]
			; Ind++
		}
 		if (Ret.count()>1)
			return d:=fMergeFileData(Ret,Identifier)	
		Else
			return ret
	}
	else
	{		;; single file only
		FileRead, f, % File
		f0:=f
		if !Instr(f,Identifier)
			f_ThrowError(A_ThisFunc,"Settings for A_ScriptNameNoExt could not be loaded. The string '" Identifier "'  is missing.",A_ThisFunc . "_" 1, Exception("",-1).Line)
		f:=strsplit(f,Identifier)
		return [strsplit(f.1,"`n"),f.2,strsplit(f.1,"\\\---NewSnippet---\\\"),f0,File]
	}

}

fMergeFileData(Files,Identifier)
{  ;; merge Libraries. Note that the Index which is shown in the GUI does not correspond to the Index the snippet has on disk. This is necessary to accomodate several libs to be mergeable.
	
	Ind:=1
	Main:=[]
	EditSections:=[]
 	for File,v in Files
	{
		if (Ind==1)
		{
			Main:=v.Clone()
			MainOld:=Main.Clone()
			Ind++
			continue
		}

		SectionNames2:=strsplit(strsplit(v.2,":=").2,", ") ;; get the section names of the added file
		for i,SName in SectionNames2
			if !Instr(Main.2,SName)	;; combine Section Names
			{
				Main.2.=", " SName 
				EditSections.push(File " - " i "`:`:" Sname)			;; get a map of which section identifiers must be changed when indexing the scripts
			}
		
		de:=
		da:=
		AllSectionString:=Main.2
		AllSections:=(Strsplit(StrSplit(Main.2,":=").2,", "))
	}
	LastSnippetIndLine:=Main[3,Main[3].MaxIndex()]
	LastSnippetInd:=strsplit(strsplit(LastSnippetIndLine,"|||SnippetInd:").2,",").1+0
	; SnippetIndex:=1
	for k,v in EditSections
	{	; update Section-Identifiers in added libraries to point at the right position in Main.2	
		
		if NewInd:=HasVal(AllSections,s:=(z0:=strsplit(v,"`:`:")).2)
		{ ; get New Index of the respective Section To Edit
			Map:=Strsplit(z0.1," - ")

			; Map.1:=FileName of file to edit within
			; Map.2:=Old index
			; NewInd:=new index to replace Old Index with in Map.1 contents
			FileArrayToEdit:=Files[Map.1]
			for Index,StringToEdit in FileArrayToEdit[1]
			{
				if Instr(StringToEdit,",Section:" Map.2 ",")
				{ ;; this step only works because FileArrayToEdit is just a map to Files. The two objects are linked, and thus altering one alters the other.
					FileArrayToEdit[1,Index]:=StrReplace(StringToEdit,",Section:" Map.2 ",",",Section:" NewInd ",")
					FileArrayToEdit[4]:=StrReplace(FileArrayToEdit[4],",Section:" Map.2 ",",",Section:" NewInd ",")
					for Index2,StringToEdit2 in FileArrayToEdit[3]
					{
						if (PrevSection==Map.2)
						{

						}
						FileArrayToEdit[3,Index2]:=Strreplace(FileArrayToEdit[3,Index2],",Section:" Map.2 ",",",Section:" NewInd ",")
						PrevSection:=Map.2
						
						; if Instr(StringToEdit2,",Section:" Map.2 ",")
						; {

						; }
					}
				}
			}
		}
		; Clipboard:=Object2String()
	}
	; Clipboard:=Files.L
	; MsgBox, ","
 	Ind:=1
	/*
	; now we have 
	Files.LibraryFile containing synced-up sections
	Now we need to adjust:

	Main.1 - insert all entries from Files.k
	Main.2 - rebuild from AllSections
	Main.3 - insert all entries from Files.K
	Main.4 - concatenate together
	*/
	Main:=[]
	; m(Files)
				;; now find Which 
	for File,v in Files
	{
		HashedFile:=f_AddHashedFilePath(v)
		Files[File]:=HashedFile
		if (Ind==1)
		{
			Main:=v.Clone()
			; Main:=f_AddHashedFilePath(Main)
			MainOld:=Main.Clone()
			Ind++
			Main.4:=strsplit(v.4,"\\ Script-settings \\").1 ; strip off Script-settings-section
			Clipboard:=Main.4
			continue
		}
		; SectionNames2:=strsplit(strsplit(v.2,":=").2,",")
		; for i,SName in SectionNames2
		; 	if !Instr(Main.2,SName)	;; combine Section Names
		; 	{
		; 		Main.2.=", " SName 
		; 		EditSections.push(i "`:`:" Sname)			;; get a map of which 
		; 	}
		; 	; update Section-Identifiers in added libraries to point at the right position in Main.2
		; 	AllSections:=Strsplit(StrSplit(Main.2,":=").2,", ")
		
		Main.1:=ObjM(Main.1,v.1)
		; Main.2:=

		Main.3:=ObjM(Main.3,v.3)
		; Main.4:=""
		; Main.4:=Strreplace()
		Main.4.=Strsplit(v.4,"\\ Script-settings \\").1 ; strip Script-settings-section	
		; Clipboard:=Main.4:=Strsplit(Main.4,"\\ Script-settings \\").1 ; strip Script-settings-section
		 ;.=v.4
		; Main:=f_AddHashedFilePath(Main)
		Ind++
		
	}
	Main.4.= Identifier AllSectionString
	Main.2:=AllSectionString
	; ClipBoard:=Main.4
	; ; Main.2:=ClipBoard:=AllSectionString
	ClipBoard:=Main.4
		return Main
}
f_AddHashedFilePath(File)
{	; required to make every snippet unique, and thus distinguishable.
	ret:=f_IncorporateHash(File)
	return ret.1
}

f_IncorporateHash(File)
{	; incorporate Hash into file struct
	Number:=1 ;; make each Hash Unique
	; if (Hashes="")
		
	for ind, line in File.1
	{
		if RegExMatch(Line,Regex.SnippetFinder,c)
		{
			Hashes.Push(Hash:=Object_HashmapHash(File.5 " - " Line "-" Number++)) ; generate Hash based upon Filepath and Runtime of script  as distinguisher ; || )
			File[1,ind]:=ST_Insert("Hash_" Hash ",",oLine:=File[1,ind],Loc:=Instr(File[1,ind],",Description:")+StrLen(",Description:"))
			for k, val in File.3
				if Instr(val,oLine)
					File[3,k]:=  ST_Insert("Hash_" Hash ",",oLine:=val,Loc:=Instr(val,",Description:")+StrLen(",Description:"))
		}
	}
	; rebuild File.4 ;; maybe stop building File.4 before this point so as to save some runs
	OldF4:=File.4
	File.4:=""
	for k, v in File.1
		File.4.=	v "`n"
	File.4.=File.2
	; Clipboard:=File.4
	if (File.4==OldF4)
		f_ThrowError(A_ThisFunc,"Critical error while creating unique hashes for snippet-differentiation. A specific Hash has been incoprorated more than once. " )
	; Clipboard:=File.4
	return [File,Hashes]
}
ST_Insert(insert,input,pos=1)
{
	Length := StrLen(input)
	((pos > 0) ? (pos2 := pos - 1) : (((pos = 0) ? (pos2 := StrLen(input),Length := 0) : (pos2 := pos))))
	output := SubStr(input, 1, pos2) . insert . SubStr(input, pos, Length)
	If (StrLen(output) > StrLen(input) + StrLen(insert))
		((Abs(pos) <= StrLen(input)/2) ? (output := SubStr(output, 1, pos2 - 1) . SubStr(output, pos + 1, StrLen(input))) : (output := SubStr(output, 1, pos2 - StrLen(insert) - 2) . SubStr(output, pos - StrLen(insert), StrLen(input))))
	return, output
}

Object_HashmapHash(Key)
{		;; thank you to u/anonymous1184 for writing this for me for an old project, certainly helped a lot here.
	if !StrLen(Key)
		throw Exception("No key provided", -2)
	if IsObject(Key)
		return key
	if Key is integer
		Key:=Format("{:d}", Key)
	else if Key is float
		Key:=Format("{:f}", Key)
	return DllCall("Ntdll\RtlComputeCrc32"
		, "Ptr",0
		, "WStr",Key
		, "Int",StrLen(Key) * 2
		, "UInt")
}



ObjM(DestinationObj,MergedObj)
{
	If !IsObject(DestinationObj) || !IsObject(MergedObj)
        Return False

	for k,v in MergedObj
		DestinationObj.push(v)



	return DestinationObj	
}
ObjMerge(OrigObj, MergingObj, MergeBase=True) {                    	;-- merge two objects

    If !IsObject(OrigObj) || !IsObject(MergingObj)
        Return False
    For k, v in MergingObj
        ObjInsert(OrigObj, k, v)
    if MergeBase && IsObject(MergingObj.base) {
        If !IsObject(OrigObj.base)
            OrigObj.base := []
        For k, v in MergingObj.base
            ObjInsert(OrigObj.base, k, v)
    }
    Return True
} ;</12.01.000001>
Object2String(Obj,FullPath:=1,BottomBlank:=0){
	static String,Blank
	if(FullPath=1)
		String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		for a,b in Obj{
			if(IsObject(b))
				Object2String(b,FullPath "." a,BottomBlank)
			else{
				if(BottomBlank=0)
					String.=FullPath "." a " = " b "`n"
				else if(b!="")
					String.=FullPath "." a " = " b "`n"
				else
					Blank.=FullPath "." a " =`n"
			}
	}}
	return String Blank
}

fParseArr(Arr,SettingsIdentifier,ArrSnippetStrings)
{
    aDescriptions:={}
    aCodeBodies:={}
    aKeys:={}
    aKeys2:={}
    Snippets:=[]
    bFirstFunctionDefLine:=0
	LastSnippetInd:=0
	TotalSnippetInd:=0
	Clipboard:=ArrSnippetStrings.1
    loop, % Arr.MaxIndex()
    {   
        snippet:={Name:"",Code:""}
        CurrentLine:=Arr[A_Index]
        if (CurrentLine=SettingsIdentifier)
            break
        LastSnippetInd:=(cSnippetInd=""?LastSnippetInd:cSnippetInd)
        cFunctionName:=cParameters:=cSnippetInd:=cSection:=cSubSection:=cDescription:=cOpts:=""
		RegExMatch(CurrentLine,Regex.SnippetFinder,c)
        sFirstCharCurrentLine:=SubStr(CurrentLine,1)
        if (sFirstCharCurrentLine!="`r") && (sFirstCharCurrentLine!="`t")   ; not in ["`r","`n","`t"]
        {
            ; snippet.Name:=[]
            if cFunctionName
            {  
                snippet.FullDefLine:=Trim(strsplit(strsplit(CurrentLine, "|||").1, ";").1)
                snippet.Name:=cFunctionName
                snippet.StartLine:=A_Index
                sLastFunctionName:=cFunctionName
				
            }
            FDL:=""
            if cParameters
                snippet.Parameters:=cParameters
            if cSnippetInd
			{
                snippet.Ind:=(cSnippetInd>TotalSnippetInd?cSnippetInd:TotalSnippetInd) ;cSnippetInd
				; TotalSnippetInd
				
			}
			if (cSection>d:=SectionNames.Count())
 				f_ThrowError(A_ThisFunc,"Section index of of snippet """ regexreplace(snippet.Name,Regex.StripFunctionName) """ does not correspond to any section. Please add section name at corresponding location into the csv at the bottom of the LibraryFile.`n`nSnippet begins at line " snippet.StartLine ".",A_ThisFunc . "_" 1, Exception("",-1).Line)
            if cSection
                snippet.Section:=cSection
            if cSubSection
                snippet.Section:=cSubSection
            if cDescription
                snippet.Description:=cDescription
            aKeys.push(cFunctionName)
            if (cFunctionName!="")
                aKeys2.push(cFunctionName)
            if aKeys[aKeys.MaxIndex()]!=""
                sCurrentFunction:=cFunctionName
			snippet.Hash:=strsplit(snippet.Description,",").1
			snippet.Description:=strsplit(snippet.Description,",").2
            if (aKeys[A_Index]="")
            {
            ; (snippets[snippets.MaxIndex]!="") && (snippets[snippets.MaxIndex].name)

                {
            ; m("Script fundamentally broken: figure out how to create Code-String")
                    ; if (snippet.Name!=sCurrentFunc) || (snippet.Name && sCurrentFunc="")
                    ; {
                    ;     ; sCurrentFunc:=snippet.Func
                    ; }
                    ; ; Snippets[sCurrentFunction].Code.=CurrentLine "`n"
                    ; ; Snippets[sCurrentFunction].LastLine:=A_Index
					e:=Snippets.Count()
					d:=Snippets[Snippets.Count()]
 					Snippets[LastHash].Code.=CurrentLine "`n"
                     Snippets[LastHash].LastLine:=A_Index
                }
            }
        }
		; if (snippet.Ind==8)
		; {

		; }
        if snippet.Name
        {
 			TotalSnippetInd++
			LastHash:=snippet.Hash
            Snippets[snippet.Hash]:=[] 																									; RegExReplace(sCurrentFunction,"(\(.*\)\{*\s*)*\;*")
            Snippets[snippet.Hash]:=snippet
			snippet.Ind:=TotalSnippetInd
            sCurrentFunc:=snippet.Name
			if (snippet.Ind<=LastSnippetInd) ;throw error if snippet ind is not incremented:
			{
				snippet.Ind:=LastSnippetInd+1
			}
				; MsgBox, % "SnippetIndex " snippet.Ind " not unique.`nViolating second Snippet: """ snippet.Name "" "`nSnippet starts on line: " snippet.StartLine "`nPlease edit the respective snippet via the editor or manually - editor not yet implemented for doing so."
			LastSnippetInd:=snippet.ind
        }
		if snippet.HasKey("Ind")
			snippet:=fPadIndex(snippet,ArrSnippetStrings)
    }
    for k,v in Snippets
    {
        DefLine:=snippets[k,Name] "(" ")"
        Snippets[k].Code:=strsplit(Snippets[k].FullDefLine "`n" Snippets[k].Code,"\\\---NewSnippet---\\\").1

		Clipboard:=Snippets[k].Code
    }
    
    
	for k,v in Snippets
	{ 	; grab description and example sections and store in respective obj.
		; thank you to u/anonymous1184 on reddit for helping me with the needles for this section
		if Regexmatch(v.Code,Regex.DescriptionLong,e) 
			Snippets[k,"DescriptionLong"]:=e
		if RegExMatch(v.Code,Regex.Example,f)				
 			Snippets[k,"Example"]:=f
	}
    return [Snippets,aKeys2]
}

fPadIndex(snippet,aSnippets)
{		;; pads snippet indeces to the maximum number of snippets loaded.
	if IsObject(snippet)
	{
		IndLength:=StrLen(snippet.Ind)
		global MaxLenNecessary:=StrLen(aSnippets.MaxIndex())
		StrLenDiff:=MaxLenNecessary-IndLength
		if (StrLenDiff>0)
			snippet.Ind:=st_pad(snippet.Ind,"0","",StrLenDiff,0) +0
		return snippet
	}
	else
	{
		ret:=st_pad(snippet,"0","",(StrLen(aSnippets)-StrLen(snippet)))
		return ret ; + 0
	}
}


; bracketCount taken from AHKRARE
BracketCount(str, brackets:="{}") {                                                       	;-- helps to find the last bracket of a function
	RegExReplace(str, SubStr(brackets, 1, 1), "", open)
	RegExReplace(str, SubStr(brackets, 2, 1), "", closed)
return open - closed
}

st_pad(string, left="0", right="", LCount=1, RCount=1)
{
   if (LCount>0)
   {
      if (LCount>1)
         loop, %LCount%
            Lout.=left
      Else
         Lout:=left
   }
   if (RCount>0)
   {
      if (RCount>1)
         loop, %RCount%
            Rout.=right
      Else
         Rout.=right
   }
   Return Lout string Rout
}
f_ThrowError(Source,Message,ErrorCode:=0,ReferencePlace:="S")
	{ ; throws an error-message, possibly with further postprocessing
		if (ReferencePlace="D")
			Reference:="Documentation"
		else 
			Reference:="Source Code: Function called on line " ReferencePlace "`nError invoked in function body on line " Exception("", -1).Line
		if (ErrorCode!=0)
		{
			str=
	(LTRIM
	Function: %Source%
	Errorcode: "%ErrorCode%" - Refer to %Reference%

	Error: 
	%Message%
	)
		}
		else
		{
			str=
	(
	Function: %Source%	
	Errorcode: Refer to %Reference%

	Error: 
	%Message%
	)
		}
		MsgBox, % str
		return
	}
; HideFocusBorder(wParam, lParam := "", uMsg := "", hWnd := "") {                         	;-- Hide the dotted focus border

; 	/*	DESCRIPTION OF FUNCTION: -- HideFocusBorder() --
; 	-------------------------------------------------------------------------------------------------------------------
; 	Description  	:	Hides the focus border for the given GUI control or GUI and all of its children
;                             	Call the function passing only the HWND of the control / GUI in wParam as only parameter.
; 								WM_UPDATEUISTATE  -> msdn.microsoft.com/en-us/library/ms646361(v=vs.85).aspx
; 								The Old New Thing -> blogs.msdn.com/b/oldnewthing/archive/2013/05/16/10419105.aspx
; 	Link              	:	https://www.autohotkey.com/boards/viewtopic.php?t=9919
; 	Author         	:	just me
; 	Date             	:	23 Oct 2015
; 	AHK-Version	:	AHK_L
; 	License         	:	--
; 	Syntax          	:	--
; 	Parameter(s)	:
; 	Return value	:
; 	Remark(s)    	:
; 	Dependencies	:	none
; 	KeyWords    	:	gui, focus, border
; 	-------------------------------------------------------------------------------------------------------------------
; 	|	EXAMPLE(s)
; 	-------------------------------------------------------------------------------------------------------------------

; 	*/

;    ; WM_UPDATEUISTATE = 0x0128
; 	Static Affected := [] ; affected controls / GUIs
;         , HideFocus := 0x00010001 ; UIS_SET << 16 | UISF_HIDEFOCUS
; 	     , OnMsg := OnMessage(0x0128, Func("HideFocusBorder"))
; 	If (uMsg = 0x0128) { ; called by OnMessage()
;       If (wParam = HideFocus)
;          Affected[hWnd] := True
;       Else If Affected[hWnd]
;          PostMessage, 0x0128, %HideFocus%, 0, , ahk_id %hWnd%
;    }
;    Else If DllCall("IsWindow", "Ptr", wParam, "UInt")
; 	  PostMessage, 0x0128, %HideFocus%, 0, , ahk_id %wParam%

; } ;</06.02.000023>

AddToolTip(_CtrlHwnd, _TipText, _Modify = 0) 			;-- very easy to use function to add a tooltip to a control
	{ ; AddToolTip | retrieved from AHK-Rare Repository, original by jballi: https://www.autohotkey.com/boards/viewtopic.php?t=30079

		; retrieved from AHK-Rare Repository, original by jballi: https://www.autohotkey.com/boards/viewtopic.php?t=30079

			/*                              	DESCRIPTION

					Adds Multi-line ToolTips to any Gui Control
					AHK basic, AHK ANSI, Unicode x86/x64 compatible

					Thanks Superfraggle & Art: http://www.autohotkey.com/forum/viewtopic.php?p=188241
					Heavily modified by Rseding91 3/4/2014:
					Version: 1.0
					* Fixed 64 bit support
					* Fixed multiple GUI support
					* Changed the _Modify parameter
							* blank/0/false:                                	Create/update the tool tip.
							* -1:                                           		Delete the tool tip.
							* any other value:                             Update an existing tool tip - same as blank/0/false
																						but skips unnecessary work if the tool tip already
																						exists - silently fails if it doesn't exist.
					* Added clean-up methods:
							* AddToolTip(YourGuiHwnd, "Destroy", -1):       		Cleans up and erases the cached tool tip data created
																					for that GUI. Meant to be used in conjunction with
																					GUI, Destroy.
								* AddToolTip(YourGuiHwnd, "Remove All", -1):	   	Removes all tool tips from every control in the GUI.
																					Has the same effect as "Destroy" but first removes
																					every tool tip from every control. This is only used
																					when you want to remove every tool tip but not destroy
																					the entire GUI afterwords.
							* NOTE: Neither of the above are required if
										your script is closing.

					- 'Text' and 'Picture' Controls requires a g-label to be defined.
					- 'ComboBox' = Drop-Down button + Edit (Get hWnd of the 'Edit'   control using "ControlGet" command).
					- 'ListView' = ListView + Header       (Get hWnd of the 'Header' control using "ControlGet" command).

		*/

		Static TTHwnds, GuiHwnds, Ptr
		, LastGuiHwnd
		, LastTTHwnd
		, TTM_DELTOOLA := 1029
		, TTM_DELTOOLW := 1075
		, TTM_ADDTOOLA := 1028
		, TTM_ADDTOOLW := 1074
		, TTM_UPDATETIPTEXTA := 1036
		, TTM_UPDATETIPTEXTW := 1081
		, TTM_SETMAXTIPWIDTH := 1048
		, WS_POPUP := 0x80000000
		, BS_AUTOCHECKBOX = 0x3
		, CW_USEDEFAULT := 0x80000000

		Ptr := A_PtrSize ? "Ptr" : "UInt"

			/*                              	NOTE

						This is used to remove all tool tips from a given GUI and to clean up references used
						This can be used if you want to remove every tool tip but not destroy the GUI
						When a GUI is destroyed all Windows tool tip related data is cleaned up.
						The cached Hwnd's in this function will be removed automatically if the caching code
						ever matches them to a new GUI that doesn't actually own the Hwnd's.
						It's still possible that a new GUI could have the same Hwnd as a previously destroyed GUI
						If such an event occurred I have no idea what would happen. Either the tool tip
						To avoid that issue, do either of the following:
							* Don't destroy a GUI once created
						NOTE: You do not need to do the above if you're exiting the script Windows will clean up
						all tool tip related data and the cached Hwnd's in this function are lost when the script
						exits anyway.AtEOF
		*/

		If (_TipText = "Destroy" Or _TipText = "Remove All" And _Modify = -1)
		{
			; Check if the GuiHwnd exists in the cache list of GuiHwnds
			; If it doesn't exist, no tool tips can exist for the GUI.
			;
			; If it does exist, find the cached TTHwnd for removal.
			Loop, Parse, GuiHwnds, |
				If (A_LoopField = _CtrlHwnd)
			{
				TTHwnd := A_Index
				, TTExists := True
				Loop, Parse, TTHwnds, |
					If (A_Index = TTHwnd)
					TTHwnd := A_LoopField
			}

			If (TTExists)
			{
				If (_TipText = "Remove All")
				{
					WinGet, ChildHwnds, ControlListHwnd, ahk_id %_CtrlHwnd%

					Loop, Parse, ChildHwnds, `n
						AddToolTip(A_LoopField, "", _Modify) ;Deletes the individual tooltip for a given control if it has one

					DllCall("DestroyWindow", Ptr, TTHwnd)
				}

				GuiHwnd := _CtrlHwnd
				; This sub removes 'GuiHwnd' and 'TTHwnd' from the cached list of Hwnds
				GoSub, RemoveCachedHwnd
			}

			Return
		}

		If (!GuiHwnd := DllCall("GetParent", Ptr, _CtrlHwnd, Ptr))
			Return "Invalid control Hwnd: """ _CtrlHwnd """. No parent GUI Hwnd found for control."

		; If this GUI is the same one as the potential previous one
		; else look through the list of previous GUIs this function
		; has operated on and find the existing TTHwnd if one exists.
		If (GuiHwnd = LastGuiHwnd)
			TTHwnd := LastTTHwnd
		Else
		{
			Loop, Parse, GuiHwnds, |
				If (A_LoopField = GuiHwnd)
			{
				TTHwnd := A_Index
				Loop, Parse, TTHwnds, |
					If (A_Index = TTHwnd)
					TTHwnd := A_LoopField
			}
		}

		; If the TTHwnd isn't owned by the controls parent it's not the correct window handle
		If (TTHwnd And GuiHwnd != DllCall("GetParent", Ptr, TTHwnd, Ptr))
		{
			GoSub, RemoveCachedHwnd
			TTHwnd := ""
		}

		; Create a new tooltip window for the control's GUI - only one needs to exist per GUI.
		; The TTHwnd's are cached for re-use in any subsequent calls to this function.
		If (!TTHwnd)
		{
			TTHwnd := DllCall("CreateWindowEx"
				, "UInt", 0 ;dwExStyle
				, "Str", "TOOLTIPS_CLASS32" ;lpClassName
				, "UInt", 0 ;lpWindowName
				, "UInt", WS_POPUP | BS_AUTOCHECKBOX ;dwStyle
				, "UInt", CW_USEDEFAULT ;x
				, "UInt", 0 ;y
				, "UInt", 0 ;nWidth
				, "UInt", 0 ;nHeight
				, "UInt", GuiHwnd ;hWndParent
				, "UInt", 0 ;hMenu
				, "UInt", 0 ;hInstance
			, "UInt", 0) ;lpParam

			; TTM_SETWINDOWTHEME
			DllCall("uxtheme\SetWindowTheme"
				, Ptr, TTHwnd
				, Ptr, 0
			, Ptr, 0)

			; Record the TTHwnd and GuiHwnd for re-use in any subsequent calls.
			TTHwnds .= (TTHwnds ? "|" : "") TTHwnd
			, GuiHwnds .= (GuiHwnds ? "|" : "") GuiHwnd
		}

		; Record the last-used GUIHwnd and TTHwnd for re-use in any immediate future calls.
		LastGuiHwnd := GuiHwnd
		, LastTTHwnd := TTHwnd
			/*
				*TOOLINFO STRUCT*

				UINT        cbSize
				UINT        uFlags
				HWND        hwnd
				UINT_PTR    uId
				RECT        rect
				HINSTANCE   hinst
				LPTSTR      lpszText
				#if (_WIN32_IE >= 0x0300)
					LPARAM    lParam;
				#endif
				#if (_WIN32_WINNT >= Ox0501)
					void      *lpReserved;
				#endif
		*/

		, TInfoSize := 4 + 4 + ((A_PtrSize ? A_PtrSize : 4) * 2) + (4 * 4) + ((A_PtrSize ? A_PtrSize : 4) * 4)
		, Offset := 0
		, Varsetcapacity(TInfo, TInfoSize, 0)
		, Numput(TInfoSize, TInfo, Offset, "UInt"), Offset += 4 ; cbSize
		, Numput(1 | 16, TInfo, Offset, "UInt"), Offset += 4 ; uFlags
		, Numput(GuiHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4 ; hwnd
		, Numput(_CtrlHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4 ; UINT_PTR
		, Offset += 16 ; RECT (not a pointer but the entire RECT)
		, Offset += A_PtrSize ? A_PtrSize : 4 ; hinst
		, Numput(&_TipText, TInfo, Offset, Ptr) ; lpszText
		; The _Modify flag can be used to skip unnecessary removal and creation if
		; the caller follows usage properly but it won't hurt if used incorrectly.
		If (!_Modify Or _Modify = -1)
		{
			If (_Modify = -1)
			{
				; Removes a tool tip if it exists - silently fails if anything goes wrong.
				DllCall("SendMessage"
					, Ptr, TTHwnd
					, "UInt", A_IsUnicode ? TTM_DELTOOLW : TTM_DELTOOLA
					, Ptr, 0
				, Ptr, &TInfo)

				Return
			}

			; Adds a tool tip and assigns it to a control.
			DllCall("SendMessage"
				, Ptr, TTHwnd
				, "UInt", A_IsUnicode ? TTM_ADDTOOLW : TTM_ADDTOOLA
				, Ptr, 0
			, Ptr, &TInfo)

			; Sets the preferred wrap-around width for the tool tip.
			DllCall("SendMessage"
				, Ptr, TTHwnd
				, "UInt", TTM_SETMAXTIPWIDTH
				, Ptr, 0
			, Ptr, A_ScreenWidth)
		}

		; Sets the text of a tool tip - silently fails if anything goes wrong.
		DllCall("SendMessage"
			, Ptr, TTHwnd
			, "UInt", A_IsUnicode ? TTM_UPDATETIPTEXTW : TTM_UPDATETIPTEXTA
			, Ptr, 0
		, Ptr, &TInfo)

		Return
		RemoveCachedHwnd:
			Loop, Parse, GuiHwnds, |
				NewGuiHwnds .= (A_LoopField = GuiHwnd ? "" : ((NewGuiHwnds = "" ? "" : "|") A_LoopField))

			Loop, Parse, TTHwnds, |
				NewTTHwnds .= (A_LoopField = TTHwnd ? "" : ((NewTTHwnds = "" ? "" : "|") A_LoopField))

			GuiHwnds := NewGuiHwnds
			, TTHwnds := NewTTHwnds
			, LastGuiHwnd := ""
			, LastTTHwnd := ""
		Return
	}




fCreateIniObj(str)
{
    str:=strsplit(str,"=").2
    arr:=strsplit(trim(str),",")
    for k,v in arr
        arr[k]:=trim(StrReplace(v,"`r`n"))
    return arr
}

HighlightAHK(Settings, ByRef Code) {
	static Flow := "break|byref|catch|class|continue|else|exit|exitapp|finally|for|global|gosub|goto|if|ifequal|ifexist|ifgreater|ifgreaterorequal|ifinstring|ifless|iflessorequal|ifmsgbox|ifnotequal|ifnotexist|ifnotinstring|ifwinactive|ifwinexist|ifwinnotactive|ifwinnotexist|local|loop|onexit|pause|return|settimer|sleep|static|suspend|throw|try|until|var|while"
	, Commands := "autotrim|blockinput|clipwait|control|controlclick|controlfocus|controlget|controlgetfocus|controlgetpos|controlgettext|controlmove|controlsend|controlsendraw|controlsettext|coordmode|critical|detecthiddentext|detecthiddenwindows|drive|driveget|drivespacefree|edit|envadd|envdiv|envget|envmult|envset|envsub|envupdate|fileappend|filecopy|filecopydir|filecreatedir|filecreateshortcut|filedelete|fileencoding|filegetattrib|filegetshortcut|filegetsize|filegettime|filegetversion|fileinstall|filemove|filemovedir|fileread|filereadline|filerecycle|filerecycleempty|fileremovedir|fileselectfile|fileselectfolder|filesetattrib|filesettime|formattime|getkeystate|groupactivate|groupadd|groupclose|groupdeactivate|gui|guicontrol|guicontrolget|hotkey|imagesearch|inidelete|iniread|iniwrite|input|inputbox|keyhistory|keywait|listhotkeys|listlines|listvars|menu|mouseclick|mouseclickdrag|mousegetpos|mousemove|msgbox|outputdebug|pixelgetcolor|pixelsearch|postmessage|process|progress|random|regdelete|regread|regwrite|reload|run|runas|runwait|send|sendevent|sendinput|sendlevel|sendmessage|sendmode|sendplay|sendraw|setbatchlines|setcapslockstate|setcontroldelay|setdefaultmousespeed|setenv|setformat|setkeydelay|setmousedelay|setnumlockstate|setregview|setscrolllockstate|setstorecapslockmode|settitlematchmode|setwindelay|setworkingdir|shutdown|sort|soundbeep|soundget|soundgetwavevolume|soundplay|soundset|soundsetwavevolume|splashimage|splashtextoff|splashtexton|splitpath|statusbargettext|statusbarwait|stringcasesense|stringgetpos|stringleft|stringlen|stringlower|stringmid|stringreplace|stringright|stringsplit|stringtrimleft|stringtrimright|stringupper|sysget|thread|tooltip|transform|traytip|urldownloadtofile|winactivate|winactivatebottom|winclose|winget|wingetactivestats|wingetactivetitle|wingetclass|wingetpos|wingettext|wingettitle|winhide|winkill|winmaximize|winmenuselectitem|winminimize|winminimizeall|winminimizeallundo|winmove|winrestore|winset|winsettitle|winshow|winwait|winwaitactive|winwaitclose|winwaitnotactive"
	, Functions := "abs|acos|array|asc|asin|atan|ceil|chr|comobjactive|comobjarray|comobjconnect|comobjcreate|comobject|comobjenwrap|comobjerror|comobjflags|comobjget|comobjmissing|comobjparameter|comobjquery|comobjtype|comobjunwrap|comobjvalue|cos|dllcall|exception|exp|fileexist|fileopen|floor|func|getkeyname|getkeysc|getkeystate|getkeyvk|il_add|il_create|il_destroy|instr|isbyref|isfunc|islabel|isobject|isoptional|ln|log|ltrim|lv_add|lv_delete|lv_deletecol|lv_getcount|lv_getnext|lv_gettext|lv_insert|lv_insertcol|lv_modify|lv_modifycol|lv_setimagelist|mod|numget|numput|objaddref|objclone|object|objgetaddress|objgetcapacity|objhaskey|objinsert|objinsertat|objlength|objmaxindex|objminindex|objnewenum|objpop|objpush|objrawset|objrelease|objremove|objremoveat|objsetcapacity|onmessage|ord|regexmatch|regexreplace|registercallback|round|rtrim|sb_seticon|sb_setparts|sb_settext|sin|sqrt|strget|strlen|strput|strsplit|substr|tan|trim|tv_add|tv_delete|tv_get|tv_getchild|tv_getcount|tv_getnext|tv_getparent|tv_getprev|tv_getselection|tv_gettext|tv_modify|tv_setimagelist|varsetcapacity|winactive|winexist|_addref|_clone|_getaddress|_getcapacity|_haskey|_insert|_maxindex|_minindex|_newenum|_release|_remove|_setcapacity"
	, Keynames := "alt|altdown|altup|appskey|backspace|blind|browser_back|browser_favorites|browser_forward|browser_home|browser_refresh|browser_search|browser_stop|bs|capslock|click|control|ctrl|ctrlbreak|ctrldown|ctrlup|del|delete|down|end|enter|esc|escape|f1|f10|f11|f12|f13|f14|f15|f16|f17|f18|f19|f2|f20|f21|f22|f23|f24|f3|f4|f5|f6|f7|f8|f9|home|ins|insert|joy1|joy10|joy11|joy12|joy13|joy14|joy15|joy16|joy17|joy18|joy19|joy2|joy20|joy21|joy22|joy23|joy24|joy25|joy26|joy27|joy28|joy29|joy3|joy30|joy31|joy32|joy4|joy5|joy6|joy7|joy8|joy9|joyaxes|joybuttons|joyinfo|joyname|joypov|joyr|joyu|joyv|joyx|joyy|joyz|lalt|launch_app1|launch_app2|launch_mail|launch_media|lbutton|lcontrol|lctrl|left|lshift|lwin|lwindown|lwinup|mbutton|media_next|media_play_pause|media_prev|media_stop|numlock|numpad0|numpad1|numpad2|numpad3|numpad4|numpad5|numpad6|numpad7|numpad8|numpad9|numpadadd|numpadclear|numpaddel|numpaddiv|numpaddot|numpaddown|numpadend|numpadenter|numpadhome|numpadins|numpadleft|numpadmult|numpadpgdn|numpadpgup|numpadright|numpadsub|numpadup|pause|pgdn|pgup|printscreen|ralt|raw|rbutton|rcontrol|rctrl|right|rshift|rwin|rwindown|rwinup|scrolllock|shift|shiftdown|shiftup|space|tab|up|volume_down|volume_mute|volume_up|wheeldown|wheelleft|wheelright|wheelup|xbutton1|xbutton2"
	, Builtins := "base|clipboard|clipboardall|comspec|errorlevel|false|programfiles|true"
	, Keywords := "abort|abovenormal|activex|add|ahk_class|ahk_exe|ahk_group|ahk_id|ahk_pid|all|alnum|alpha|altsubmit|alttab|alttabandmenu|alttabmenu|alttabmenudismiss|alwaysontop|and|autosize|background|backgroundtrans|base|belownormal|between|bitand|bitnot|bitor|bitshiftleft|bitshiftright|bitxor|bold|border|bottom|button|buttons|cancel|capacity|caption|center|check|check3|checkbox|checked|checkedgray|choose|choosestring|click|clone|close|color|combobox|contains|controllist|controllisthwnd|count|custom|date|datetime|days|ddl|default|delete|deleteall|delimiter|deref|destroy|digit|disable|disabled|dpiscale|dropdownlist|edit|eject|enable|enabled|error|exit|expand|exstyle|extends|filesystem|first|flash|float|floatfast|focus|font|force|fromcodepage|getaddress|getcapacity|grid|group|groupbox|guiclose|guicontextmenu|guidropfiles|guiescape|guisize|haskey|hdr|hidden|hide|high|hkcc|hkcr|hkcu|hkey_classes_root|hkey_current_config|hkey_current_user|hkey_local_machine|hkey_users|hklm|hku|hotkey|hours|hscroll|hwnd|icon|iconsmall|id|idlast|ignore|imagelist|in|insert|integer|integerfast|interrupt|is|italic|join|label|lastfound|lastfoundexist|left|limit|lines|link|list|listbox|listview|localsameasglobal|lock|logoff|low|lower|lowercase|ltrim|mainwindow|margin|maximize|maximizebox|maxindex|menu|minimize|minimizebox|minmax|minutes|monitorcount|monitorname|monitorprimary|monitorworkarea|monthcal|mouse|mousemove|mousemoveoff|move|multi|na|new|no|noactivate|nodefault|nohide|noicon|nomainwindow|norm|normal|nosort|nosorthdr|nostandard|not|notab|notimers|number|off|ok|on|or|owndialogs|owner|parse|password|pic|picture|pid|pixel|pos|pow|priority|processname|processpath|progress|radio|range|rawread|rawwrite|read|readchar|readdouble|readfloat|readint|readint64|readline|readnum|readonly|readshort|readuchar|readuint|readushort|realtime|redraw|regex|region|reg_binary|reg_dword|reg_dword_big_endian|reg_expand_sz|reg_full_resource_descriptor|reg_link|reg_multi_sz|reg_qword|reg_resource_list|reg_resource_requirements_list|reg_sz|relative|reload|remove|rename|report|resize|restore|retry|rgb|right|rtrim|screen|seconds|section|seek|send|sendandmouse|serial|setcapacity|setlabel|shiftalttab|show|shutdown|single|slider|sortdesc|standard|status|statusbar|statuscd|strike|style|submit|sysmenu|tab|tab2|tabstop|tell|text|theme|this|tile|time|tip|tocodepage|togglecheck|toggleenable|toolwindow|top|topmost|transcolor|transparent|tray|treeview|type|uncheck|underline|unicode|unlock|updown|upper|uppercase|useenv|useerrorlevel|useunsetglobal|useunsetlocal|vis|visfirst|visible|vscroll|waitclose|wantctrla|wantf2|wantreturn|wanttab|wrap|write|writechar|writedouble|writefloat|writeint|writeint64|writeline|writenum|writeshort|writeuchar|writeuint|writeushort|xdigit|xm|xp|xs|yes|ym|yp|ys|__call|__delete|__get|__handle|__new|__set"
	, Needle :="
	(LTrim Join Comments
		ODims)
		((?:^|\s);[^\n]+)                	; Comments
		|(^\s*\/\*.+?\n\s*\*\/)      	; Multiline comments
		|((?:^|\s)#[^ \t\r\n,]+)      	; Directives
		|([+*!~&\/\\<>^|=?:
			,().```%{}\[\]\-]+)           	; Punctuation
		|\b(0x[0-9a-fA-F]+|[0-9]+)	; Numbers
		|(""[^""\r\n]*"")                	; Strings
		|\b(A_\w*|" Builtins ")\b   	; A_Builtins
		|\b(" Flow ")\b                  	; Flow
		|\b(" Commands ")\b       	; Commands
		|\b(" Functions ")\b          	; Functions (builtin)
		|\b(" Keynames ")\b         	; Keynames
		|\b(" Keywords ")\b          	; Other keywords
		|(([a-zA-Z_$]+)(?=\())       	; Functions
		|(^\s*[A-Z()-\s]+\:\N)        	; Descriptions
	)"

	GenHighlighterCache(Settings)
	Map := Settings.Cache.ColorMap

	Pos := 1
	while (FoundPos := RegExMatch(Code, Needle, Match, Pos))
	{
		RTF .= "\cf" Map.Plain " "
		RTF .= EscapeRTF(SubStr(Code, Pos, FoundPos-Pos))

		; Flat block of if statements for performance
		if (Match.Value(1) != "")
			RTF .= "\cf" Map.Comments
		else if (Match.Value(2) != "")
			RTF .= "\cf" Map.Multiline
		else if (Match.Value(3) != "")
			RTF .= "\cf" Map.Directives
		else if (Match.Value(4) != "")
			RTF .= "\cf" Map.Punctuation
		else if (Match.Value(5) != "")
			RTF .= "\cf" Map.Numbers
		else if (Match.Value(6) != "")
			RTF .= "\cf" Map.Strings
		else if (Match.Value(7) != "")
			RTF .= "\cf" Map.A_Builtins
		else if (Match.Value(8) != "")
			RTF .= "\cf" Map.Flow
		else if (Match.Value(9) != "")
			RTF .= "\cf" Map.Commands
		else if (Match.Value(10) != "")
			RTF .= "\cf" Map.Functions
		else if (Match.Value(11) != "")
			RTF .= "\cf" Map.Keynames
		else if (Match.Value(12) != "")
			RTF .= "\cf" Map.Keywords
		else if (Match.Value(13) != "")
			RTF .= "\cf" Map.Functions
		else If (Match.Value(14) != "")
			RTF .= "\cf" Map.Descriptions
		else
			RTF .= "\cf" Map.Plain

		RTF .= " " EscapeRTF(Match.Value())
		Pos := FoundPos + Match.Len()
	}

	return Settings.Cache.RTFHeader . RTF . "\cf" Map.Plain " " EscapeRTF(SubStr(Code, Pos)) "\`n}"
}

GenHighlighterCache(Settings) {

	if Settings.HasKey("Cache")
		return
	Cache := Settings.Cache := {}


	; --- Process Colors ---
	Cache.Colors := Settings.Colors.Clone()

	; Inherit from the Settings array's base
	BaseSettings := Settings
	while (BaseSettings := BaseSettings.Base)
		for Name, Color in BaseSettings.Colors
			if !Cache.Colors.HasKey(Name)
				Cache.Colors[Name] := Color

	; Include the color of plain text
	if !Cache.Colors.HasKey("Plain")
		Cache.Colors.Plain := Settings.FGColor

	; Create a Name->Index map of the colors
	Cache.ColorMap := {}
	for Name, Color in Cache.Colors
		Cache.ColorMap[Name] := A_Index


	; --- Generate the RTF headers ---
	RTF := "{\urtf"

	; Color Table
	RTF .= "{\colortbl;"
	for Name, Color in Cache.Colors
	{
		RTF .= "\red"    	Color>>16	& 0xFF
		RTF .= "\green"	Color>>8 	& 0xFF
		RTF .= "\blue"  	Color        	& 0xFF ";"
	}
	RTF .= "}"

	; Font Table
	if Settings.Font
	{
		FontTable .= "{\fonttbl{\f0\fmodern\fcharset0 "
		FontTable .= Settings.Font.Typeface
		FontTable .= ";}}"
		RTF .= "\fs" Settings.Font.Size * 2 ; Font size (half-points)
		if Settings.Font.Bold
			RTF .= "\b"
	}

	; Tab size (twips)
	RTF .= "\deftab" GetCharWidthTwips(Settings.Font) * Settings.TabSize

	Cache.RTFHeader := RTF
}

GetCharWidthTwips(Font) {

	static Cache := {}

	if Cache.HasKey(Font.Typeface "_" Font.Size "_" Font.Bold)
		return Cache[Font.Typeface "_" font.Size "_" Font.Bold]

	; Calculate parameters of CreateFont
	Height	:= -Round(Font.Size*A_ScreenDPI/72)
	Weight	:= 400+300*(!!Font.Bold)
	Face 	:= Font.Typeface

	; Get the width of "x"
	hDC 	:= DllCall("GetDC", "UPtr", 0)
	hFont 	:= DllCall("CreateFont"
					, "Int", Height 	; _In_ int       	  nHeight,
					, "Int", 0         	; _In_ int       	  nWidth,
					, "Int", 0        	; _In_ int       	  nEscapement,
					, "Int", 0        	; _In_ int       	  nOrientation,
					, "Int", Weight ; _In_ int        	  fnWeight,
					, "UInt", 0     	; _In_ DWORD   fdwItalic,
					, "UInt", 0     	; _In_ DWORD   fdwUnderline,
					, "UInt", 0     	; _In_ DWORD   fdwStrikeOut,
					, "UInt", 0     	; _In_ DWORD   fdwCharSet, (ANSI_CHARSET)
					, "UInt", 0     	; _In_ DWORD   fdwOutputPrecision, (OUT_DEFAULT_PRECIS)
					, "UInt", 0     	; _In_ DWORD   fdwClipPrecision, (CLIP_DEFAULT_PRECIS)
					, "UInt", 0     	; _In_ DWORD   fdwQuality, (DEFAULT_QUALITY)
					, "UInt", 0     	; _In_ DWORD   fdwPitchAndFamily, (FF_DONTCARE|DEFAULT_PITCH)
					, "Str", Face   	; _In_ LPCTSTR  lpszFace
					, "UPtr")
	hObj := DllCall("SelectObject", "UPtr", hDC, "UPtr", hFont, "UPtr")
	VarSetCapacity(SIZE, 8, 0)
	DllCall("GetTextExtentPoint32", "UPtr", hDC, "Str", "x", "Int", 1, "UPtr", &SIZE)
	DllCall("SelectObject", "UPtr", hDC, "UPtr", hObj, "UPtr")
	DllCall("DeleteObject", "UPtr", hFont)
	DllCall("ReleaseDC", "UPtr", 0, "UPtr", hDC)

	; Convert to twpis
	Twips := Round(NumGet(SIZE, 0, "UInt")*1440/A_ScreenDPI)
	Cache[Font.Typeface "_" Font.Size "_" Font.Bold] := Twips
	return Twips
}
EscapeRTF(Code) {
	for each, Char in ["\", "{", "}", "`n"]
		Code := StrReplace(Code, Char, "\" Char)
	return StrReplace(StrReplace(Code, "`t", "\tab "), "`r")
}





FuzzySearch(string1, string2)
{
	lenl := StrLen(string1)
	lens := StrLen(string2)
	if(lenl > lens)
	{
		shorter := string2
		longer := string1
	}
	else if(lens > lenl)
	{
		shorter := string1
		longer := string2
		lens := lenl
		lenl := StrLen(string2)
	}
	else
		return StringDifference(string1, string2)
	min := 1
	Loop % lenl - lens + 1
	{
		distance := StringDifference(shorter, SubStr(longer, A_Index, lens))
		if(distance < min)
			min := distance
	}
	return min
}
;By Toralf:
;basic idea for SIFT3 code by Siderite Zackwehdex 
;http://siderite.blogspot.com/2007/04/super-fast-and-accurate-string-distance.html 
;took idea to normalize it to longest string from Brad Wood 
;http://www.bradwood.com/string_compare/ 
;Own work: 
; - when character only differ in case, LSC is a 0.8 match for this character 
; - modified code for speed, might lead to different results compared to original code 
; - optimized for speed (30% faster then original SIFT3 and 13.3 times faster than basic Levenshtein distance) 
;http://www.autohotkey.com/forum/topic59407.html 
StringDifference(string1, string2, maxOffset=1) {    ;returns a float: between "0.0 = identical" and "1.0 = nothing in common" 
  If (string1 = string2) 
    Return (string1 == string2 ? 0/1 : 0.2/StrLen(string1))    ;either identical or (assumption:) "only one" char with different case 
  If (string1 = "" OR string2 = "") 
    Return (string1 = string2 ? 0/1 : 1/1) 
  StringSplit, n, string1 
  StringSplit, m, string2 
  ni := 1, mi := 1, lcs := 0 
  While((ni <= n0) AND (mi <= m0)) { 
    If (n%ni% == m%mi%) 
      EnvAdd, lcs, 1 
    Else If (n%ni% = m%mi%) 
      EnvAdd, lcs, 0.8 
    Else{ 
      Loop, %maxOffset%  { 
        oi := ni + A_Index, pi := mi + A_Index 
        If ((n%oi% = m%mi%) AND (oi <= n0)){ 
            ni := oi, lcs += (n%oi% == m%mi% ? 1 : 0.8) 
            Break 
        } 
        If ((n%ni% = m%pi%) AND (pi <= m0)){ 
            mi := pi, lcs += (n%ni% == m%pi% ? 1 : 0.8) 
            Break 
        } 
      } 
    } 
    EnvAdd, ni, 1 
    EnvAdd, mi, 1 
  } 
  Return ((n0 + m0)/2 - lcs) / (n0 > m0 ? n0 : m0) 
}


Quote(String)
{ ; u/anonymous1184 | fetched from https://www.reddit.com/r/AutoHotkey/comments/p2z9co/comment/h8oq1av/?utm_source=share&utm_medium=web2x&context=3
	return """" String """"
}





#Include <RichCode>
; #Include D:\Dokumente neu\AutoHotkey\Lib\ObjTree\Attach.ahk
; #Include D:\Dokumente neu\AutoHotkey\Lib\ObjTree\LV.ahk
; #Include D:\Dokumente neu\AutoHotkey\Lib\ObjTree\ObjTree.ahk

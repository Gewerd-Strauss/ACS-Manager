IsCheckboxStyle(style) {                                                                                           	;-- checks style(code) if it's a checkbox
	static types := [ "Button"        	;BS_PUSHBUTTON
                  , "Button"                	;BS_DEFPUSHBUTTON
                  , "Checkbox"      		;BS_CHECKBOX
                  , "Checkbox"      		;BS_AUTOCHECKBOX
                  , "Radio"                 	;BS_RADIOBUTTON
                  , "Checkbox"      		;BS_3STATE
                  , "Checkbox"      		;BS_AUTO3STATE
                  , "Groupbox"      		;BS_GROUPBOX
                  , "NotUsed"       		;BS_USERBUTTON
                  , "Radio"                 	;BS_AUTORADIOBUTTON
                  , "Button"                	;BS_PUSHBOX
                  , "AppSpecific"   		;BS_OWNERDRAW
                  , "SplitButton"           	;BS_SPLITBUTTON    (vista+)
                  , "SplitButton"           	;BS_DEFSPLITBUTTON (vista+)
                  , "CommandLink"   	;BS_COMMANDLINK    (vista+)
                  , "CommandLink"]  	;BS_DEFCOMMANDLINK (vista+)

	If( types[1+(style & 0xF)] = "Checkbox" )
        Return True

	Return False
}
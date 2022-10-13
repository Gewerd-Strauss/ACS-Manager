GetButtonType(hwndButton) {                                                                                 	;-- uses the style of a button to get it's name
  static types := [ "Button"        ;BS_PUSHBUTTON
                     	, "Button"        ;BS_DEFPUSHBUTTON
                     	, "Checkbox"      ;BS_CHECKBOX
                     	, "Checkbox"      ;BS_AUTOCHECKBOX
                     	, "Radio"         ;BS_RADIOBUTTON
                     	, "Checkbox"      ;BS_3STATE
                     	, "Checkbox"      ;BS_AUTO3STATE
                     	, "Groupbox"      ;BS_GROUPBOX
                     	, "NotUsed"       ;BS_USERBUTTON
                     	
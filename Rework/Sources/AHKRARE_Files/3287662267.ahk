AddToolTip(con,text,Modify = 0) {                                                                                    	;-- just a simple add on to allow tooltips to be added to controls without having to monitor the wm_mousemove messages

 Static TThwnd,GuiHwnd
  If (!TThwnd){
    Gui,+LastFound
    GuiHwnd:=WinExist()
    TThwnd:=CreateTooltipControl(GuiHwnd)
	Varsetcapacity(TInfo,44,0)
	Numput(44,TInfo)
	Numput(1|16,TInfo,4)
	Numput(GuiHwnd,TInfo,8)
	Numput(GuiHwnd,TInfo,12)
	;Numput(&text,TInfo,36)
	Detecthiddenwindows,on
	Sendmessage,1028,0,&TInfo,,ahk_id %TThwnd%
    SendMessage,1048,0,300,,ahk_id %TThwnd%
  }
  Varsetcapacity(TInfo,44,0)
  Numput(44,TInfo)
  Numput(1|16,TInfo,4)
  Numput(GuiHwnd,TInfo,8)
  Numput(con,TInfo,12)
  Numput(&text,TInfo,36)
  Detecthiddenwindows,on
  If (Modify){
    SendMessage,1036,0,&TInfo,,ahk_id %TThwnd%
  }
  Else {
    Sendmessage,1028,0,&TInfo,,ahk_id %TThwnd%
    SendMessage,1048,0,300,,ahk_id %TThwnd%
  }
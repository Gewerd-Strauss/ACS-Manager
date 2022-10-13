NewLinkMsg(VideoSite, VideoName = "") {								            		;--

   global lng

   TmpMsg := % lng.MSG_NEW_LINK_FOUND . VideoSite . "`r`n"
   if (VideoName <> "")
      TmpMsg := TmpMsg . lng.MSG_NEW_LINK_FILENAME . VideoName . "`r`n`r`n"

	MsgBox 36, %ProgramName%, % TmpMsg lng.MSG_NEW_LINK_ASK, 50
	IfMsgBox Yes
		return, 0
	else
		return, -1
}
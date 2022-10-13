TimeGap(ntp="de.pool.ntp.org")	{								            					;-- Determine by what amount the local system time differs to that of an ntp server

		;Bobo's function
		;https://autohotkey.com/boards/viewtopic.php?f=10&t=34806
		RunWait,% ComSpec " /c w32tm /stripchart /computer:" ntp " /period:1 /dataonly /samples:1 | clip",, Hide ; Query is stored in the clipboard
		array := StrSplit(ClipBoard,"`n")					;disassemble the returned answer after lines
		Return % SubStr(array[4], 10)		                ; difference of time/gap ...
}
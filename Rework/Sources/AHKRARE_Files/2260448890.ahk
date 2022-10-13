ReduceMem() {                                                                                                            	;-- reduces usage of memory from calling script

	/*                              	DESCRIPTION

			Link:                 	https://autohotkey.com/board/topic/56984-new-process-notifier/
			 Function from: 	New Process Notifier
			 Language:       	English
			 Platform:       		Windows XP or later

                                		Copyright (C) 2010 sbc <http://sites.google.com/site/littlescripting/>
                                		Licence: GNU GENERAL PUBLIC LICENSE. Please reffer to this page for more information. http://www.gnu.org/licenses/gpl.html

	*/
    pid := DllCall("GetCurrentProcessId")
    
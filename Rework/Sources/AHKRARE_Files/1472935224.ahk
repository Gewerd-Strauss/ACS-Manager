RestartNetwork(ConnectionName := "") {                                                   	;-- Restart "Local area connection" without admin privileges
	oShell := ComObjCreate("Shell.Application")
	oShell.Open("::{7007ACC7-3202-11D1-AAD2-00805FC1270E}") ; Open Network Connections
	FolderName := oShell.Namespace(0x31).Title

	; Find "Network Connections" window
	Loop
	{
		Sleep, 200

		for oWin in oShell.Windows
		{
			if ( oWin.LocationName = FolderName )
			&& ( oWin.LocationURL = "" )
			&& ( InStr(oWin.FullName, "\Explorer.EXE") )
				Break, 2
		}
	}

	oFolder := oWin.Document.Folder

	for item in oFolder.Items
	{
		devName := oFolder.GetDetailsOf(item, 2)

		if (item.name = ConnectionName)
		|| (ConnectionName = "" && InStr(devName, "Realtek PCIe"))
		{
			if InStr(item.Verbs.Item(0).Name, "&B")
			{
				item.InvokeVerb("disable")
				Sleep, 1000
			}

			item.InvokeVerb("enable")
			break
		}
	}

	oWin.Quit
}
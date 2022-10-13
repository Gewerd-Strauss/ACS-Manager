SelectFolder() {																	                                                										;-- the common File Dialog lets you add controls to it
   Static OsVersion := DllCall("GetVersion", "UChar")
   Static Show := A_PtrSize * 3
   Static SetOptions := A_PtrSize * 9
   Static GetResult := A_PtrSize * 20
   SelectedFolder := ""
   If (OsVersion < 6) { ; IFileDialog requires Win Vista+
      FileSelectFolder, SelectedFolder
      Return SelectedFolder
   }
   If !(FileDialog := ComObjCreate("{DC1C5A9C-E88A-4dde-A5A1-60F82A20AEF7}", "{42f85136-db7e-439c-85f1-e4075d135fc8}"))
      Return ""
   VTBL := NumGet(FileDialog + 0, "UPtr")
   DllCall(NumGet(VTBL + SetOptions, "UPtr"), "Ptr", FileDialog, "UInt", 0x00000028, "UInt") ; FOS_NOCHANGEDIR | FOS_PICKFOLDERS

   try if ((FileDialogCustomize := ComObjQuery(FileDialog, "{e6fdd21a-163f-4975-9c8c-a69f1ba37034}"))) {
		groupId := 616 ; arbitrarily chosen
		comboboxId := 93270
		itemOneId := 015
		itemTwoId := 666

		DllCall(NumGet(NumGet(FileDialogCustomize+0)+26*A_PtrSize), "Ptr", FileDialogCustomize, "UInt", groupId, "WStr", "Gruppe name") ; IFileDialogCustomize::StartVisualGroup
		DllCall(NumGet(NumGet(FileDialogCustomize+0)+6*A_PtrSize), "Ptr", FileDialogCustomize, "UInt", comboboxId) ; IFileDialogCustomize::AddComboBox
		DllCall(NumGet(NumGet(FileDialogCustomize+0)+19*A_PtrSize), "Ptr", FileDialogCustomize, "UInt", comboboxId, "UInt", itemOneId, "WStr", "ZeroQuinze") ; IFileDialogCustomize::AddControlItem
		DllCall(NumGet(NumGet(FileDialogCustomize+0)+19*A_PtrSize), "Ptr", FileDialogCustomize, "UInt", comboboxId, "UInt", itemTwoId, "WStr", "Sosa") ; IFileDialogCustomize::AddControlItem
		DllCall(NumGet(NumGet(FileDialogCustomize+0)+25*A_PtrSize), "Ptr", FileDialogCustomize, "UInt", comboboxId, "UInt", itemOneId) ; IFileDialogCustomize::SetSelectedControlItem
		DllCall(NumGet(NumGet(FileDialogCustomize+0)+27*A_PtrSize), "Ptr", FileDialogCustomize) ; IFileDialogCustomize::EndVisualGroup
	}

   If !DllCall(NumGet(VTBL + Show, "UPtr"), "Ptr", FileDialog, "Ptr", 0, "UInt") {
      If !DllCall(NumGet(VTBL + GetResult, "UPtr"), "Ptr", FileDialog, "PtrP", ShellItem, "UInt") {
         GetDisplayName := NumGet(NumGet(ShellItem + 0, "UPtr"), A_PtrSize * 5, "UPtr")
         If !DllCall(GetDisplayName, "Ptr", ShellItem, "UInt", 0x80028000, "PtrP", StrPtr) ; SIGDN_DESKTOPABSOLUTEPARSING
            SelectedFolder := StrGet(StrPtr, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "Ptr", StrPtr)
         ObjRelease(ShellItem)

         if (FileDialogCustomize) {
			if (DllCall(NumGet(NumGet(FileDialogCustomize+0)+24*A_PtrSize), "Ptr", FileDialogCustomize, "UInt", comboboxId, "UInt*", selectedItemId) == 0) { ; IFileDialogCustomize::GetSelectedControlItem
				if (selectedItemId == itemOneId)
					MsgBox ,,ZeroQuinze, %SelectedFolder%
				else if (selectedItemId == itemTwoId)
					MsgBox ,,Sosa, %SelectedFolder%
			}
         }
      }
   }
   if (FileDialogCustomize)
		ObjRelease(FileDialogCustomize)

   ObjRelease(FileDialog)
   Return SelectedFolder
}
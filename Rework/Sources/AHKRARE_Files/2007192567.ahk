GetImageDimensionProperty(ImgPath, Byref width, Byref height, 						;-- this retrieves the dimensions from a dummy Gui
PropertyName="dimensions") {

    Static DimensionIndex
    SplitPath, ImgPath , FileName, DirPath,
    objShell := ComObjCreate("Shell.Application")
    objFolder := objShell.NameSpace(DirPath)
    objFolderItem := objFolder.ParseName(FileName)

    if !DimensionIndex {
        Loop
            DimensionIndex := A_Index
        Until (objFolder.GetDetailsOf(objFolder.Items, A_Index) = PropertyName) || (A_Index > 300)
    }

    if (DimensionIndex = 301)
        Return

    dimensions := objFolder.GetDetailsOf(objFolderItem, DimensionIndex)
    width := height := ""
    pos := len := 0
    loop 2
    {
        pos := RegExMatch(dimensions, "O)\d+", oM, pos+len+1)
        if (A_Index = 1)
            width := oM.Value(0), len := oM.len(0)
        else
            height := oM.Value(0)
    }
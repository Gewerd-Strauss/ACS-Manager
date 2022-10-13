PrintArr(Arr, Option := "w800 h200", GuiNum := 90) {					;-- show values of an array in a listview gui for debugging
    for index, obj in Arr {
        if (A_Index = 1) {
            for k, v in obj {
                Columns .= k "|"
                cnt++
            }
            Gui, %GuiNum%: Margin, 5, 5
            Gui, %GuiNum%: Add, ListView, %Option%, % Columns
        }
        RowNum := A_Index
        Gui, %GuiNum%: default
        LV_Add("")
        for k, v in obj {
            LV_GetText(Header, 0, A_Index)
            if (k <> Header) {
                FoundHeader := False
                loop % LV_GetCount("Column") {
                    LV_GetText(Header, 0, A_Index)
                    if (k <> Header)
                        continue
                    else {
                        FoundHeader := A_Index
                        break
                    }
                }
                if !(FoundHeader) {
                    LV_InsertCol(cnt + 1, "", k)
                    cnt++
                    ColNum := "Col" cnt
                } else
                    ColNum := "Col" FoundHeader
            } else
                ColNum := "Col" A_Index
            LV_Modify(RowNum, ColNum, (IsObject(v) ? "Object()" : v))
        }
    }
    loop % LV_GetCount("Column")
        LV_ModifyCol(A_Index, "AutoHdr")
    Gui, %GuiNum%: Show,, Array
}
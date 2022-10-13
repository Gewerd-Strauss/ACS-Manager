GetCursor(CursorHandle) {																							;--

    Cursor := Cursors[CursorHandle]
    Return (Cursor != "") ? Cursor : CursorHandle
}
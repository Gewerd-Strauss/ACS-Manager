WinGetPosEx(hWindow,ByRef X="",ByRef Y="",ByRef Width="",ByRef Height="",ByRef Offset_X="",ByRef Offset_Y="")  { 								;-- gets the position, size, and offset of a window

	

    Static Dummy5693
          ,RECTPlus
          ,S_OK:=0x0
          ,DWMWA_EXTENDED_FRAME_BOUNDS:=9

    ;-- Workaround for AutoHotkey Basic
    PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"

    ;-- Get the window's dimensions
    ;   Note: Only the first 16 bytes of the RECTPlus structure are used by the
    ;   DwmGetWindowAttribute and GetWindowRect functions.
    VarSetCapacity(RECTPlus,24,0)
    DWMRC:=DllCall("dwmapi\DwmGetWindowAttribute"
        ,PtrType,hWindow                                ;-- hwnd
        ,"UInt",DWMWA_EXTENDED_FRAME_BOUNDS             ;-- dwAttribute
        ,PtrType,&RECTPlus                              ;-- pvAttribute
        ,"UInt",16)                                     ;-- cbAttribute

    if (DWMRC<>S_OK)
        {
        if ErrorLevel in -3,-4  ;-- Dll or function not found (older than Vista)
            {
            ;-- Do nothing else (for now)
            }
         else
            outputdebug,
               (ltrim join`s
                Function: %A_ThisFunc% -
                Unknown error calling "dwmapi\DwmGetWindowAttribute".
                RC=%DWMRC%,
                ErrorLevel=%ErrorLevel%,
                A_LastError=%A_LastError%.
                "GetWindowRect" used instead.
               )

        ;-- Collect the position and size from "GetWindowRect"
        DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECTPlus)
        }

    ;-- Populate the output variables
    X:=Left :=NumGet(RECTPlus,0,"Int")
    Y:=Top  :=NumGet(RECTPlus,4,"Int")
    Right   :=NumGet(RECTPlus,8,"Int")
    Bottom  :=NumGet(RECTPlus,12,"Int")
    Width   :=Right-Left
    Height  :=Bottom-Top
    OffSet_X:=0
    OffSet_Y:=0

    ;-- If DWM is not used (older than Vista or DWM not enabled), we're done
    if (DWMRC<>S_OK)
        Return &RECTPlus

    ;-- Collect dimensions via GetWindowRect
    VarSetCapacity(RECT,16,0)
    DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECT)
    GWR_Width :=NumGet(RECT,8,"Int")-NumGet(RECT,0,"Int")
        ;-- Right minus Left
    GWR_Height:=NumGet(RECT,12,"Int")-NumGet(RECT,4,"Int")
        ;-- Bottom minus Top

    ;-- Adjust width and height for offset calculations if DPI is in play
    ;   See https://msdn.microsoft.com/en-us/library/windows/desktop/dn280512(v=vs.85).aspx
    ;   The current version of AutoHotkey is PROCESS_SYSTEM_DPI_AWARE (contains "<dpiAware>true</dpiAware>" in its manifest)
    ;   DwmGetWindowAttribute returns DPI scaled sizes
    ;   GetWindowRect does not
    ; get monitor handle where the window is at so we can get the monitor name
    hMonitor := DllCall("MonitorFromRect",PtrType,&RECT,UInt,2) ; MONITOR_DEFAULTTONEAREST = 2 (Returns a handle to the display monitor that is nearest to the rectangle)
    ; get monitor name so we can get a handle to the monitor device context
    VarSetCapacity(MONITORINFOEX,104)
    NumPut(104,MONITORINFOEX)
    DllCall("GetMonitorInfo",PtrType,hMonitor,PtrType,&MONITORINFOEX)
    monitorName := StrGet(&MONITORINFOEX+40)
    ; get handle to monitor device context so we can get the dpi adjusted and actual screen sizes
    hdc := DllCall("CreateDC",Str,monitorName,PtrType,0,PtrType,0,PtrType,0)
    ; get dpi adjusted and actual screen sizes
    dpiAdjustedScreenHeight := DllCall("GetDeviceCaps",PtrType,hdc,Int,10) ; VERTRES = 10 (Height, in raster lines, of the screen)
    actualScreenHeight := DllCall("GetDeviceCaps",PtrType,hdc,Int,117) ; DESKTOPVERTRES = 117
    ; delete hdc as instructed
    DllCall("DeleteDC",PtrType,hdc)
    ; calculate dpi adjusted width and height
    dpiFactor := actualScreenHeight/dpiAdjustedScreenHeight ; this will be 1.0 if DPI is 100%
    dpiAdjusted_Width := Ceil(Width/dpiFactor)
    dpiAdjusted_Height := Ceil(Height/dpiFactor)

    ;-- Calculate offsets and update output variables
    NumPut(Offset_X:=(dpiAdjusted_Width-GWR_Width)//2,RECTPlus,16,"Int")
    NumPut(Offset_Y:=(dpiAdjusted_Height-GWR_Height)//2,RECTPlus,20,"Int")
    Return &RECTPlus
}
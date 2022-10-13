ReceiveData(wParam, lParam) {                                                       	;--  By means of OnMessage(), this function has been set up to be called automatically whenever new data arrives on the connection.

   global ShowRecieved
   global ReceivedData

   Gui, Submit, NoHide
   socket := wParam

    ReceivedDataSize = 4096 ; Large in case a lot of data gets buffered due to delay in processing previous data.
    Loop  ; This loop solves the issue of the notification message being discarded due to thread-already-running.
    {
        VarSetCapacity(ReceivedData, ReceivedDataSize, 0)  ; 0 for last param terminates string for use with recv().
        ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket, "Str", ReceivedData, "Int", ReceivedDataSize, "Int", 0)
        if ReceivedDataLength = 0  ; The connection was gracefully closed,
            ExitApp  ; The OnExit routine will call WSACleanup() for us.
        if ReceivedDataLength = -1
        {
            WinsockError := DllCall("Ws2_32\WSAGetLastError")
            if WinsockError = 10035  ; WSAEWOULDBLOCK, which means "no more data to be read".
                return 1
            if WinsockError <> 10054 ; WSAECONNRESET, which happens when Network closes via system shutdown/logoff.
                ; Since it's an unexpected error, report it.  Also exit to avoid infinite loop.
                MsgBox % "recv() indicated Winsock error " . WinsockError
            ExitApp  ; The OnExit routine will call WSACleanup() for us.
        }
        ; Otherwise, process the data received.
        ; Msgbox %ReceivedData%
        Loop, parse, ReceivedData, `n, `r
        {
           	ReceivedData=%A_LoopField%
           	if (ReceivedData!="")
           	{
				GoSub ParseData
				GoSub UseData
			}
        }
	}
    return 1  ; Tell the program that no further processing of this message is needed.
}
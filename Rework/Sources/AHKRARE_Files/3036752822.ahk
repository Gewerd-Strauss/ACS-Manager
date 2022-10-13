SetUIntByAddress(_addr, _integer, _offset = 0) {                                                	        	;-- write UInt direct to memory
	/*                              	DESCRIPTION

			Origin: https://autohotkey.com/board/topic/15950-treeview-with-tooltip-tvn-getinfotip-notification/

	*/
	Loop 4
	{
		DllCall("RtlFillMemory"
                , "UInt", _addr + _offset + A_Index-1
                , "UInt", 1
                , "UChar", (_integer >> 8*(A_Index-1)) & 0xFF)
	}
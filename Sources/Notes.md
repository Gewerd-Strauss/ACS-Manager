


;; Notes:

How to increase speed: 


Regex for library conversion
TODO: Write conversion script to capture <DESCRIPTION> and <;-- Description> to convert into new syntax.



;<01.01.000001>
ClipboardGetDropEffect() {																				;-- Clipboard function. Retrieves if files in clipboard comes from an explorer cut or copy operation.

	/*                              	DESCRIPTION

			Parameters	:		explorer copy = 5, explorer cut = 2

	*/


   Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str" , "Preferred DropEffect")
   DropEffec



>>>>>                   ((\s;<\/(\d|\.)*>))(\n|\})*\n(;\|.*|\n*)*(;-*\n)*\n*\{.*\n(;|<|\d|\.|>)*

Expl: removes the following kind of block.
line 42 contains the main section of all following functions on the left "(; .* (\d*) --)"-part, with <baseID> at the right end 





Relevant regex-prototypes for stripping unwanted parts of the AHK-rare.txt (like the function-toc's and old identifiers)
/*
\;<\/(\d|\.)+\>\n\;\<(\d|\.)+\>



((;\|.*)|(\;-*))


\;<\/(\d|\.)+\>.*\n*\}\n;(\||\.*)



\;<\/(\d|\.)+\>.*\n*\}\n|(;\|.*|;-*)*



\} ;<\/(\d|\.)*>(\n*|\})*;(\||\s*|\n)*(.*)*

*/






Return PID ? PID : 0
} ;</16.01.000066>

}
;|   CreateNamedPipe(01)             	|   RestoreCursors(02)                   	|   SetSystemCursor(03)                	|   SystemCursor(04)                     	|
;|   ToggleSystemCursor(05)         	|   SetTimerF(06)                          	|   IGlobalVarsScript(07)               	|   patternScan(08)                       	|
;|   scanInBuf()                              	|   hexToBinaryBuffer()	                	|   GetDllBase()                             	|   getProcBaseFromModules()      	|
;|   RegRead64()                            	|   RegWrite64()                            	|   LoadScriptResource()                	|
;|   HIconFromBuffer()                   	|   hBMPFromPNGBuffer()            	|   SaveSetColours()                      	|   ChangeMacAdress()                 	|
;|   ListAHKStats()                         	|   MouseExtras()                          	|   TimedFunction()                       	|   ListGlobalVars()                       	|
;|   TaskList()                                 	|   MouseDpi()                              	|   SendToAHK()                            	|   ReceiveFromAHK()                   	|
;|   GetUIntByAddress()                 	|   SetUIntByAddress()                   	|   SetRestrictedDacl()                    	|   getActiveProcessName()          	|
;|   enumChildCallback()               	|   GetDllBase()                             	|   getProcBaseFromModules()      	|   InjectDll()                                 	|
;|   getProcessBaseAddress()         	|   LoadFile()                                 	|   ReadProcessMemory()              	|   WriteProcessMemory()             	|
;|   CopyMemory()                        	|   MoveMemory()                         	|   FillMemory()                             	|   ZeroMemory()                          	|
;|   CompareMemory()                  	|   VirtualAlloc()                            	|   VirtualFree()                             	|   ReduceMem()                           	|
;|   GlobalLock()                            	|   LocalFree()                               	|   CreateStreamOnHGlobal()       	|   CoTaskMemFree()                    	|
;|   CoTaskMemRealloc()               	|   VarAdjustCapacity()                 	|   DllListExports()                         	|   RtlUlongByteSwap64() x2         	|
;|   PIDfromAnyID(56)                   	|   processPriority(57)                   	|   GetProcessMemoryInfo(58)      	|   SetTimerEx(59)                         	|
;|   DisableFadeEffect(61)              	|   GetPriority(62)                         	|   ProcessCreationTime(63)         	|   ProcessOwner(64)                    	|
;|   ProcessPriority(65)                   	|   PIDfromAnyID(66)                    	|
;---------------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------------------------

{ ;System/User/hardware (8) -- retreaving informations about system, user, hardware --                           	baseID: <17>
;<17.01.000001>
UserAccountsEnum(Options := "") {       
scanInBuf(haystackAddr, needleAddr, haystackSize, needleSize, StartOffset = 0)     {	;-- scan for a pattern in memory buffer
        ;Doesn't WORK with AHK 64 BIT, only works with AHK 32 bit
	/*                              	DESCRIPTION

        	;taken from:
                ;http://www.autohotkey.com/board/topic/23627-machine-code-binary-buffer-searching-regardless-of-null/
                ; -1 not found else returns offset address (starting at 0)
                ; The returned offset is relative to the haystackAddr regardless of StartOffset
                	static fun

	*/
        ; AHK32Bit a_PtrSize = 4 | AHK64Bit - 8 bytes
        if (a_PtrSize = 8)
          return -1

        ifequal, fun,
        {
          h =
          (  LTrim join
             5589E583EC0C53515256579C8B5D1483FB000F8EC20000008B4D108B451829C129D9410F8E
             B10000008B7D0801C78B750C31C0FCAC4B742A4B742D4B74364B74144B753F93AD93F2AE0F
             858B000000391F75F4EB754EADF2AE757F3947FF75F7EB68F2AE7574EB628A26F2AE756C38
             2775F8EB569366AD93F2AE755E66391F75F7EB474E43AD8975FC89DAC1EB02895DF483E203
             8955F887DF87D187FB87CAF2AE75373947FF75F789FB89CA83C7038B75FC8B4DF485C97404
             F3A775DE8B4DF885C97404F3A675D389DF4F89F82B45089D5F5E5A595BC9C2140031C0F7D0
             EBF0
          )
          varSetCapacity(fun, strLen(h)//2)
          loop % strLen(h)//2
             numPut("0x" . subStr(h, 2*a_index-1, 2), fun, a_index-1, "char")
        }

        return DllCall(&fun, "uInt", haystackAddr, "uInt", needleAddr
                      , "uInt", haystackSize, "uInt", needleSize, "uInt", StartOffset)
}
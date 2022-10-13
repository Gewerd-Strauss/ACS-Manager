LVM_CalculateSize(hLV,p_NumberOfRows:=-1,ByRef r_Width:="",ByRef r_Height:="") { ;-- calculate the width and height required to display a given number of rows of a ListView control
    Static Dummy67950827

	  ;-- Messages
	  ,LVM_GETITEMCOUNT              	:=0x1004              ;-- LVM_FIRST + 4
	  ,LVM_APPROXIMATEVIEWRECT	:=0x1040              ;-- LVM_FIRST + 64

    ;-- Collect and/or adjust the number of rows
    if (p_NumberOfRows<0)
   {
        SendMessage LVM_GETITEMCOUNT,0,0,,ahk_id %hLV%
        p_NumberOfRows:=ErrorLevel
        }

    if p_NumberOfRows  ;-- Not zero
        p_NumberOfRows-=1

    ;-- Calculate size
    SendMessage LVM_APPROXIMATEVIEWRECT,p_NumberOfRows,-1,,ahk_id %hLV%

    ;-- Extract, adjust, and return values
    r_Width :=(ErrorLevel&0xFFFF)+4 ;-- LOWORD
    r_Height:=(ErrorLevel>>16)+4    ;-- HIWORD
    Return r_Height<<16|r_Width
}
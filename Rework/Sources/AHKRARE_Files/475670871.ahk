LV_HeaderFontSet(p_hwndlv="", p_fontstyle="", p_fontname="") {				         		;-- sets a different font to a Listview header (it's need CreateFont() function)

	;//******************* Functions *******************
	;//Sun, Jul 13, 2008 --- 7/13/08, 7:19:19pm
	;//Function: ListView_HeaderFontSet
	;//Params...
	;//		p_hwndlv    = ListView hwnd
	;//		p_fontstyle = [b[old]] [i[talic]] [u[nderline]] [s[trike]]
	;//		p_fontname  = <any single valid font name = Arial, Tahoma, Trebuchet MS>
	; dependings: no (chang
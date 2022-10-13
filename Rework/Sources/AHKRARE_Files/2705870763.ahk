LV_HeaderFontSet(p_hwndlv="", p_fontstyle="", p_fontname="") {                              	;-- sets font for listview headers

/******************* Functions *******************
;//Sun, Jul 13, 2008 --- 7/13/08, 7:19:19pm
;//Function: ListView_HeaderFontSet
;//Params...
;//		p_hwndlv    = ListView hwnd
;//		p_fontstyle = [b[old]] [i[talic]] [u[nderline]] [s[trike]]
;//		p_fontname  = <any single valid font name = Arial, Tahoma, Trebuchet MS>
*/

static hFont1stBkp
method:="CreateFont"
;//method="CreateFontIndirect"
WM_SETFONT			:=0x0030
WM
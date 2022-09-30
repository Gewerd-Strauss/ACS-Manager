
SetTitleMatchMode 2
if (url := GetUrl("Mozilla Firefox"))
    MsgBox 0x40040, Current URL in Firefox, % url
else
    MsgBox 0x40010, Error, Couldn't retrieve Firefox URL.

loop, files, D:\Dokumente neu\000 AAA Dokumente\000 AAA HSRW\General\AHK scripts\Projects\AHK-Code-Snippets\Rework\Sources\Useful Scripts\*.ini,FR
{
    SplitPath, % A_LoopFileFullPath, name, dir, ext, namenext, drive
    IniRead, CurrentPastHashes, % A_LoopFileFullPath, Info, PastHashes ,%A_Space%
    ; IniWrite, % namenext, A_LoopFileFullPath, Info, % PastHashes ","
    if (CurrentPastHashes="")
        IniWrite, % namenext, % A_LoopFileFullPath, Info, PastHashes
    else
        IniWrite, % namenext "," CurrentPastHashes,% A_LoopFileFullPath, Info, PastHashes
}
; IniWrite, Value, Filename, Section, Key
m("Finished")
; IniWrite, Value, Filename, Section, Key
;; NewHash,OldHashes
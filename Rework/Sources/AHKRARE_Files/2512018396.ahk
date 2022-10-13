PutText(MyText) {                                       	                                	;-- Pastes text from a variable while preserving the clipboard. (Ctrl+v method)

   SavedClip := ClipboardAll
   Clipboard =              ; For better compatability
   Sleep 20                 ; with Clipboard History
   Clipboard := MyText
   Send ^v
   Sleep 100
   Clipboard := SavedClip
   Return
}
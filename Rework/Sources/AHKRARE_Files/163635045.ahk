GetParentDir(Dir){                                                                                                                                                   	;-- small RegEx function to get parent dir from a given string
    Return RegExReplace(Dir, "\\[^\\]+$")
}
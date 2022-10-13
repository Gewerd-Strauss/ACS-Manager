GetAllInputChars() {                                                        					;-- Returns a string with input characters

    Loop 256
        ChrStr .= Chr( a_index ) " "

    ChrStr .= "{down} {up} {right} {left} "

    R
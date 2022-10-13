CreatePropertyCondition(propertyId, ByRef var, type := "Variant") {                                  	;-- I hope this one is better
        ; CREDITS: Elgin, http://ahkscript.org/boards/viewtopic.php?f=5&t=6979&p=43985#p43985
        ; Parameters:
        ;   propertyId  - An ID number of the property to check.
        ;   var         - The value to check for.  Can be a variant, number, or string.
        ;   type        - The data type.  Can be the string "Variant", or one of standard
        ;                 variant type such as VT_I4, VT_BSTR, etc.
        local out:="", hr, bstr
        If (A_PtrSize = 8)
        {
            if (type!="Variant")
                UIA_Variant(var,type,var)
            hr := DllCall(this.__Vt(23), "ptr",this.__Value, "int",propertyId, "ptr",&var, "ptr*",out)
            if (type!="Variant")
                UIA_VariantClear(&var)
            return UIA_Hr(hr)? new UIA_PropertyCondition(out):
        }
        else ; 32-bit.
        {
            if (type <> 8)
                return UIA_Hr(DllCall(this.__Vt(23), "ptr",this.__Value, "int",propertyId
                            , "int64",type, "int64",var, "ptr*",out))? new UIA_PropertyCondition(out):
            else ; It's type is VT_BSTR.
            {
                bstr := DllCall("oleaut32\SysAllocString", "wstr",var, "ptr")
                hr := DllCall(this.__Vt(23), "ptr",this.__Value, "int",propertyId
                            , "int64",type, "ptr",bstr, "ptr",0, "ptr*",out)
                DllCall("oleaut32\SysFreeString", "ptr", bstr)
                return UIA_Hr(hr)? new UIA_PropertyCondition(out):
            }
        }
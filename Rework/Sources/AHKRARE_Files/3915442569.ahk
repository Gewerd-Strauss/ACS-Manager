CreatePropertyConditionEx(propertyId, ByRef var, type := "Variant", flags := 0x1) {          	;--
        ; PropertyConditionFlags_IgnoreCase = 0x1
        local out:="", hr, bstr

        If (A_PtrSize = 8) {
            if (type!="Variant")
                UIA_Variant(var,type,var)
            hr := DllCall(this.__vt(24), "ptr",this.__Value, "int",propertyId
                        , "ptr",&var, "uint",flags, "ptr*",out)
            if (type!="Variant")
                UIA_VariantClear(&var)
            return UIA_Hr(hr)? new UIA_PropertyCondition(out):
        }
        else ; 32-bit.
        {
            if (type <> 8)
                return UIA_Hr(DllCall(this.__vt(24), "ptr",this.__Value, "int",propertyId
                            , "int64",type, "int64",var
                            , "uint",flags, "ptr*",out))? new UIA_PropertyCondition(out):
            else ; It's type is VT_BSTR.
            {
                bstr := DllCall("oleaut32\SysAllocString", "wstr",var, "ptr")
                hr := DllCall(this.__vt(24), "ptr",this.__Value, "int",propertyId
                            , "int64",type, "ptr",bstr, "ptr",0, "uint",flags, "ptr*",out)
                DllCall("oleaut32\SysFreeString", "ptr", bstr)
                return UIA_Hr(hr)? new UIA_PropertyCondition(out):
            }
        }
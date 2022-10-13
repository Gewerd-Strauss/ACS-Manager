ComVarSet(cv, v, p*) { 																							;-- Called when script sets an unknown field.
    if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]:=v
        return cv._[0] :
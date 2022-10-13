isaKeyPhysicallyDown(Keys) {                                                        	;-- belongs to ReleaseModifiers() function

  if isobject(Keys)
  {
    for Index, Key in Keys
      if getkeystate(Key, "P")
        return key
  }
  else if getkeystate(Keys, "P")
  	return Keys ;keys!
  return 0
}
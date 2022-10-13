RegWrite64(sValueType, sRootKey, sKeyName, sValueName = "", sValue = "") {      	;-- RegWrite64() function that do not redirect to Wow6432Node on 64-bit machines

	HKEY_CLASSES_ROOT         	:= 0x80000000                        	; http://msdn.microsoft.com/en-us/library/aa393286.aspx
	HKEY_CURRENT_USER        	:= 0x80000001
	HKEY_LOCAL_MACHINE      	:= 0x80000002
	HKEY_USERS                        	:= 0x80000003
	HKEY_CURRENT_CONFIG    	:= 0x80000005
	HKEY_DYN_DATA                	:= 0x80000006
	HKCR                                   	:= HKEY_CLASSES_ROOT
	HKCU                                   	:= HKEY_CURRENT_USER
	HKLM                                  	:= HKEY_LOCAL_MACHINE
	HKU	                                    	:= HKEY_USERS
	HKCC                                   	:= HKEY_CURRENT_CONFIG

	REG_NONE                          	:= 0                                          	; http://msdn.microsoft.com/en-us/library/ms724884.aspx
	REG_SZ                                	:= 1
	REG_EXPAND_SZ                		:= 2
	REG_BINARY                        	:= 3
	REG_DWORD                       	:= 4
	REG_DWORD_BIG_ENDIAN		:= 5
	REG_LINK                            	:= 6
	REG_MULTI_SZ                    	:= 7
	REG_RESOURCE_LIST          	:= 8

	KEY_QUERY_VALUE             	:= 0x0001                                	; http://msdn.microsoft.com/en-us/library/ms724878.aspx
	KEY_WOW64_64KEY            	:= 0x0100                                	; http://msdn.microsoft.com/en-gb/library/aa384129.aspx (do not redirect to Wow6432Node on 64-bit machines)
	KEY_SET_VALUE                   	:= 0x0002
	KEY_WRITE                          	:= 0x20006

	myhKey := %sRootKey%                                                         	; pick out value (0x8000000x) from list of HKEY_xx vars
	myValueType := %sValueType%                                            		; pick out value (0-8) from list of REG_SZ,REG_DWORD etc. types
	IfEqual,myhKey,, {                                                                    	; Error - Invalid root key
		ErrorLevel := 3
		return ErrorLevel
	}
	IfEqual,myValueType,, {                                                           	; Error - Invalid value type
		ErrorLevel := 2
		return ErrorLevel
	}

	RegAccessRight := KEY_QUERY_VALUE + KEY_WOW64_64KEY + KEY_WRITE

	DllCall("Advapi32.dll\RegCreateKeyExA", "uint", myhKey, "str", sKeyName, "uint", 0, "uint", 0, "uint", 0, "uint", RegAccessRight, "uint", 0, "uint*", hKey)	; open/create key
	If (myValueType == REG_SZ or myValueType == REG_EXPAND_SZ) {
		vValueSize := StrLen(sValue) + 1
		DllCall("Advapi32.dll\RegSetValueExA", "uint", hKey, "str", sValueName, "uint", 0, "uint", myValueType, "str", sValue, "uint", vValueSize)	; write string
	} Else If (myValueType == REG_DWORD) {
		vValueSize := 4
		DllCall("Advapi32.dll\RegSetValueExA", "uint", hKey, "str", sValueName, "uint", 0, "uint", myValueType, "uint*", sValue, "uint", vValueSize)	; write dword
	} Else {		; REG_MULTI_SZ, REG_BINARY, or other unsupported value type
		ErrorLevel := 2
	}
	DllCall("Advapi32.dll\RegCloseKey", "uint", hKey)
	return ErrorLevel
}
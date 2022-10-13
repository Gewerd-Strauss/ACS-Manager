UserAccountsEnum(Options := "") {                                                                        	;-- list all users with information

	/*                              	DESCRIPTION

			; list all users with information
			; Syntax: UserAccountsEnum ([options])
			; Parameters:
			; Options: specify the search conditions
			; Syntax: [space] WHERE [that] = '[equal to]' [AND | OR ...]
			;Example:
			; for k, v in UserAccountsEnum ()
			; MsgBox% k "#` n "v.Domain" \ "v.Name
			 ;https://msdn.microsoft.com/en-us/library/windows/desktop/aa394507(v=vs.85).aspx

	*/

	List := []
	for this in ComObjGet("winmgmts:\\.\root\CIMV2").ExecQuery("SELECT * FROM Win32_UserAccount" Options) {
		Info := {}
		Loop, Parse, % "AccountType|Caption|Description|Disabled|Domain|FullName|InstallDate|LocalAccount"
		. "|Lockout|Name|PasswordChangeable|PasswordExpires|PasswordRequired|SID|SIDType|Status", |
			Info[A_LoopField] := this[A_LoopField]
		List.Push(Info)
	} return List
}
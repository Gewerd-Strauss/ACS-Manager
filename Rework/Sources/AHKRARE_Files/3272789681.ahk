FileSetSecurity(Path, Trustee := "", AccessMask := 0x1F01FF, Flags := 1, AccesFlag := 0) { 										;--  set security for the file / folder

	/*                              	DESCRIPTION

			; set security for the file / folder
			; Syntax: FileSetSecurity ([file], [User], [permissions], [options], [access])
			; Parameters:
			; File: specify the file or folder to modify
			; User: specify the SID of the user that inherits the permissions or Domain \ User. if not specified, use the current user
			; Note: to obtain a list of users with information, use UserAccountsEnum ()
			; Permissions: specify the desired access
			; 0x1F01FF = TOTAL CONTROL (F)
			; 0x120089 = READING (R)
			; 0x120116 = WRITING (W)
			; 0x1200a0 = EXECUTION (X)
			; 0x00010000 = DISPOSAL (D)
			; 0x1301BF = MODIFICATION (M)
			; Options:
			; 0 = directories
			; 1 = directories and files
			; 2 = directories and sub-directories
			; 3 = directories, sub-directories and files
			; Access: https://msdn.microsoft.com/en-us/library/windows/desktop/aa772244(v=vs.85).aspx
			; 0 = allow
			; 1 = deny
			;Notes:
			; permissions can be viewed by clicking on file properties, security tab.
			; permissions can be changed with ICACLS in CMD: icacls [file] / grant * [user]: ([permissions, letter], WDAC)
			; the function sets the owner, since it is required to change the permissions
			The invoking process must have administrator permissions to modify the permissions
			;Example:
			; MsgBox% "Take Ownership:" FileSetOwner (A_SysD
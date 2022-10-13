GetCurrentUserInfo() {                                                                                             	;-- obtains information from the current user

	/*                              	DESCRIPTION

			; obtains information from the current user
			; Example: MsgBox% "Domain \ User:" GetCurrentUserInfo (). Domain "\" GetCurrentUserInfo (). Name "`nSID: "GetCurrentUserInfo (). SID
			;Notes:
			Another way to get the SID, is using cmd.
			Link: http://www.windows-commandline.com/get-sid-of-user/
			; Example: wmic useraccount where (name = '% username%' and domain = '% userdomain%') get sid

	*/
	static CurrentUserInfo
	if !(CurrentUserInfo)
		if !(CurrentUserInfo:=UserAccountsEnum(" WHERE Name = '" A_UserName "' AND Domain = '" A_UserDomain() "'")[1])
			CurrentUserInfo := UserAccountsEnum(" WHERE Name = '" A_UserName "'")[1]
	return CurrentUserInfo
}
FileSetOwner(Path, Owner := "") {																																;-- set the owner to file / directory

	/*                              	DESCRIPTION

			; set the owner to file / directory
			; Syntax: FileSetOwner ([file], [user])
			; Parameters:
			; User: specify the domain \ user or user's SID. by default it uses the current user.

	*/
	Owner := Owner=""?A_UserNameEx():Owner
	, oADsSecurityUtility := ComObjCreate("ADsSecurityUtility")
	, oADsSecurityUtility.SecurityMask := 0x1
	, oADsSecurityDescriptor := oADsSecurityUtility.GetSecurityDescriptor(Path:=GetFullPathName(Path), 1, 1)
	, oADsSecurityDescriptor.Owner := Owner
	, oADsSecurityUtility.SetSecurityDescriptor(Path, 1, oADsSecurityDescriptor, 1)
}
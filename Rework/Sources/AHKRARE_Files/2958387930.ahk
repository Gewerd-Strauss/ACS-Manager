FileGetOwner(Path) { 																																					;-- get the owner to file / directory

	/*                              	DESCRIPTION

			get the domain and username
			; Syntax: FileGetOwner ([file])
			; Return: domain \ user

	*/
	oADsSecurityUtility := ComObjCreate("ADsSecurityUtility")
	, oADsSecurityUtility.SecurityMask := 0x1
	, oADsSecurityDescriptor := oADsSecurityUtility.GetSecurityDescriptor(GetFullPathName(Path), 1, 1)
	return oADsSecurityDescriptor.Owner
}
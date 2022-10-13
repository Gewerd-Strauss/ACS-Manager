getProcBaseFromModules(process) {                                                                          	;--

/*
	http://stackoverflow.com/questions/14467229/get-base-address-of-process
	Open the process using OpenProcess -- if successful, the value returned is a handle to the process, which is just an opaque token used by the kernel to identify a kernel object. Its exact integer value (0x5c in your case) has no meaning to userspace programs, other than to distinguish it from other handles and invalid handles.
	Call GetProcessImageFileName to get the name of the main executable module of the process.
	Use EnumProcessModules to enumerate the list of all modules in the target process.
	For each module, call GetModuleFileNameEx to get the filename, and compare it with the executable's filename.
	When you've found the executable's module, call Ge
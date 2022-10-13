CreateStreamOnHGlobal(hGlobal, DeleteOnRelease := true) {                                   	;-- creates a stream object that uses an HGLOBAL memory handle to store the stream contents. This object is the OLE-provided implementation of the IStream interface.
	DllCall("ole32.dll\CreateStreamOnHGlobal", "Ptr", hGlobal, "Int", !!DeleteOnRelease, "PtrP", IStream)
	return IStream
}
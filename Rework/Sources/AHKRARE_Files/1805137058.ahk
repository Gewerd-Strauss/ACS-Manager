CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {          	;-- creates an instance of a named pipe and returns a handle for subsequent pipe operations
    return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
        ,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,"uint",0)
}
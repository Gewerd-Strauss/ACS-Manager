LoadFile(path, exe:="", exception_level:=-1) {                                                             	;-- Loads a script file as a child process and returns an object

	/*		DESCRIPTION

    LoadFile(Path [, EXE])

        Loads a script file as a child process and returns an object
        which can be used to call functions or get/set global vars.

    Path:
          The path of the script.
    EXE:
          The path of the AutoHotkey executable (defaults to A_AhkPath).

    Requirements:
      - AutoHotkey v1.1.17+    http://ahkscript.org/download/
      - ObjRegisterActive      http://goo.gl/wZsFLP
      - CreateGUID
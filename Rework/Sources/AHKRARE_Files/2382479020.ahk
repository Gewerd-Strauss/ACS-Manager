ChangeMacAdress() {                                                                                                  	;-- change MacAdress, it makes changes to the registry!

        ; http://ahkscript.org/germans/forums/viewtopic.php?t=8423 from ILAN12346
        ; Caution: Really only change if you know what a MAC address is or what you are doing.
        ; I do not assume any liability for any damages!

        Rootkey := "HKEY_LOCAL_MACHINE"
        ValueName := "DriverDesc"
        loop
        {
          Subkey := "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\" . num := "00" . (A_Index < 10  ? "0" . A_Index : A_Index)
          RegRead, name, % Rootkey, % Subkey, % ValueName
          if name
        	nwa .= name . "***" . num . (A_Index = 1 ? "||" : "|")
          Else
        	break
        }
        gui, Font, s10
        Gui, Add, Edit, x10 y40 w260 h20 +Center vmac,
        Gui, Add, DropDownList, x10 y10 w260 h20 r10 vselect gselect, % RegExReplace(nwa, "\*\*\*", _
                                        	  . "                                                   *")
        Gui, Add, Button, x280 y10 w60 h50 gset , Set Mac
        Gui, Show, x270 y230 h70 w350, MAC
        ValueName := "NetworkAddress"
        Return

        select:
          gui, submit, NoHide
          Subkey := "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\" . substr(select,instr(select, "*")+1)
          RegRead, macaddr, % Rootkey, % Subkey, % ValueName
          GuiControl,, mac, % macaddr
        Return

        set:
          gui, submit, NoHide
          link := "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\" . substr(select,instr(select, "*")+1)
          RegRead, macaddr, % Rootkey, % Subkey, % ValueName
          newmac := RegExReplace(RegExReplace(mac, "-", ""), " ","")
          StringLower, newmac, newmac
          maccheck := "0x" . newmac
          if (strlen(newmac)=12 && (maccheck+1)) || !strlen(newmac)
        	RegWrite, REG_SZ, % RootKey, % SubKey , % ValueName, % newmac
          Else
        	MsgBox,16, Error, Incorrect MAC address
        	MsgBox, 48,Successful, New MAC Address Acquired
        	MsgBox, 36,Reconnect?,The network adapter needs to be reconnected. `n`n reconnect now?
        	
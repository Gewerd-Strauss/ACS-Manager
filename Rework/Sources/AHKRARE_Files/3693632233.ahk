ControlSelectTab(Index, Ctl, Win) {																				;-- SendMessage wrapper to select the current tab on a MS Tab Control.
	/*                              	DESCRIPTION

			 Func: ControlSelectTab
			 Select the current tab on a MS Tab Control.

			 Parameters:
			 Index  - Tab index to select.  0 is the first tab.
			 Ctl    - Name of the control as detected via Window Spy
			 Win    - Window to send it to

			 Returns:
			 Appropriate tab selected.

	*/

   SendMessage, 0x1330, %Index%,, %Ctl%, %Win%
}
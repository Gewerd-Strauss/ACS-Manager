GuiCenterButtons(strWindow, intInsideHorizontalMargin := 10, 								;-- Center and resize a row of buttons automatically
intInsideVerticalMargin := 0, intDistanceBetweenButtons := 20, arrControls*) {
; This is a variadic function. See: http://ahkscript.org/docs/Functions.htm#Variadic
; https://autohotkey.com/boards/viewtopic.php?t=3963 from JnLlnd

	/*				EXAMPLE

		Gui, New, , MyWindow

		Gui, Add, Text, , Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras rutrum nisi et metus porttitor non tristique est euismod. Maecenas accumsan, ante at tempus tempor, lorem elit mollis mauris, vitae tempor massa odio eget libero.

		Gui, Font
		Gui, Add, Button, y+20 vMyButton1 gGuiClose, Close
		Gui, Add, Button, yp vMyButton2 gGuiClose, Lonnge
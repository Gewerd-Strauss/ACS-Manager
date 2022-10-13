GetImageDimensions(ImgPath, Byref width, Byref height) {									;-- Retrieves image width and height of a specified image file

	/*											Description

		Link              	:	https://sites.google.com/site/ahkref/custom-functions/getimagedimensions
    DHW := A_DetectHiddenWIndows
    DetectHiddenWindows, ON
    Gui, AnimatedGifControl_GetImageDimensions: Add, Picture, hwndhWndImage, % ImgPath
    GuiControlGet, Image, AnimatedGifControl_GetImageDimensions:Pos, % hWndImage
    Gui, AnimatedGifControl_GetImageDimensions: Destroy
    DetectHiddenWindows, % DHW
    width := ImageW,     height := ImageH
}
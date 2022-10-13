DestroyCircleProgress(circleObj) {                                                                       	;-- subfunction for CreateCircleProgress
    Gui % circleObj.hwnd ":Destroy"
    SelectObject(circleObj.hdc, circleObj.obm)
    DeleteObject(circleObj.hbm)
    DeleteDC(circleObj.hdc)
    Gdip_DeleteGraphics(circleObj.G)
}
UpdateCircleProgress(circleObj,percent) {                                                          	;-- subfunction for CreateCircleProgress
    Gdip_Drawarc(circleObj.G, circleObj.pen, circleObj.thickness, circleObj.thickness, circleObj.diameter, circleObj.diameter, 270, 360/100*percent)
    UpdateLayeredWindow(circleObj.hwnd, circleObj.hdc, circleObj.xPos, circleObj.yPos, circleObj.width, circleObj.height)
}
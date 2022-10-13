DrawRotatePictureOnGraphics(G,pBitmap,x,y,size,angle) {                                 	;-- rotate a pBitmap
	;X and Y describe the new center of the model  - https://autohotkey.com/board/topic/95329-tower-defense-game-in-ahk/
dist:=(((size/2)**2)*2)**0.5
VarSetCapacity(Points,24,0)
numput(round(sin((45+angle)*0.01745329252)*dist+x),Points,0,"float")
numput(round(cos((45+angle)*0.01745329252)*dist+y),Points,4,"float")
numput(round(sin((135+angle)*0.01745329252)*dist+x),Points,8,"float")
numput(round(cos((135+angle)*0.01745329252)*dist+y),Points,12,"float")
numput(round(sin((315+angle)*0.01745329252)*dist+x),Points,16,"float")
numput(round(cos((315+angle)*0.01745329252)*dist+y),Points,20,"float")
;Msgbox %  "x1:" numget(Points,0,"float") "y1:" numget(Points,4,"flo
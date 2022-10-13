ScaleToFit(width_max, height_max, width_actual, height_actual) {                         	;-- returns the dimensions of the scaled source rectangle that fits within the destination rectangle
  width_ratio := width_actual / width_max
  height_ratio := height_actual / height_max
  if (width_ratio > height_ratio)
  {
    new_height := height_actual // width_ratio
    return {width:width_max, height:new_height, x:0, y:(height_max-new_height)//2}
  }
  else
  {
    new_width := width_actual // height_ratio
    return {width:new_width, height:height_max, x:(width_max-new_width)//2, y:0}
  }
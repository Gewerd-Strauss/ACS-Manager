RGBrightnessToHex(r := 0, g := 0, b := 0, brightness := 1) {                               	;-- transform rbg (with brightness) values to hex
	;https://autohotkey.com/boards/viewtopic.php?f=6&p=191294
	return (b * brightness << 16) + (g * brightness << 8) + (r * brightness)
}
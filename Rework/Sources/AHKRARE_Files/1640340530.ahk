IsWindowVisible(hWnd) {																							;-- self explaining
	return DllCall("IsWindowVisible", "Ptr", hWnd)
}
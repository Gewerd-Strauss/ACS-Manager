WM_DEVICECHANGE( wParam, lParam) {                                       	;-- Detects whether a CD has been inserted instead and also outputs the drive - global drv

Global Drv
 global DriveNotification
 Static DBT_DEVICEARRIVAL := 0x8000 ; http://msdn2.microsoft.com/en-us/library/aa363205.aspx
 Static DBT_DEVTYP_VOLUME := 0x2    ; http://msd
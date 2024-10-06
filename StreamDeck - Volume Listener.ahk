; AHK codes: !=alt, ^=ctrl, +=shift, #=windows
; AHK codes: ~ computer will still see hotkey   $ hotkey wont run on it's own calling
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Singleinstance, force ; Ensures that there is only a single instance of this script running
;#NoTrayIcon
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
;SetTitleMatchMode, 3 ; sets title matching to search for exact name matches

CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

REFERENCE MATERIAL:

HOW TO USE THIS SCRIPT:

	Give a description here.

NOTES:

*/
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+F20:: 
    ;Main Dial - Clockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\master_vol_up.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
!F20:: 
    ;Main Dial - Counterclockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\master_vol_dn.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
^F20:: 
    ;Main Dial - Clicked
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\master_mute.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return

+F21:: 
    ;Chrome Dial - Clockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\chrome_vol_up.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
!F21:: 
    ;Chrome Dial - Counterclockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\chrome_vol_dn.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
^F21:: 
    ;Chrome Dial - Clicked
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\chrome_mute.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
	
+F22:: 
    ;Discord Dial - Clockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\discord_vol_up.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
!F22:: 
    ;Discord Dial - Counterclockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\discord_vol_dn.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
^F22:: 
    ;Discord Dial - Clicked
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\discord_mute.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
	
+F23:: 
    ;HDMI Dial - Clockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\hdmi_vol_up.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
!F23:: 
    ;HDMI Dial - Counterclockwise
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\hdmi_vol_dn.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return
^F23:: 
    ;HDMI Dial - Clicked
	filepath := "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\hdmi_mute.py"
	Run, % A_ComSpec " /c pythonw """ filepath """",,Hide
    return

;-------------------------------------------------------------

	;The code boneyard of trials is below

	;commands=
	;(join&
	;pythonw "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\setvolume.py"`n
	;)

	;Run, cmd /k %commands%,,Hide
	
	;Run, cmd /k pythonw "'G:\My Drive\Software\1) My Creations\Python\Volume Mixer\setvolume.py'"
	;Run, %A_ComSpec% /c pythonw "G:\My Drive\Software\1) My Creations\Python\Volume Mixer\setvolume.py" myarg1
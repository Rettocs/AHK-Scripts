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
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

REFERENCE MATERIAL:

HOW TO USE THIS SCRIPT:

	While open, will refresh the current Google Chrome page every X milliseconds.
	X is defined in code with the refreshRate variable

NOTES:

*/
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

refreshRate := 60000

Loop {
winactivate, Google Chrome
sleep, 150
Send {F5}
sleep, %refreshRate%
}
return

+Esc::ExitApp

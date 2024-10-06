; AHK codes: !=alt, ^=ctrl, +=shift, #=windows
; AHK codes: ~ computer will still see hotkey   $ hotkey wont run on it's own calling
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Singleinstance, force ; Ensures that there is only a single instance of this script running
;#NoTrayIcon
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; reference material:


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; IDEAS:

; NOTES:

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Initialize

;Menu, Tray, Icon, C:\Users\retto\Google Drive\Computer Sync\Software\1) My Creations\AHK\Icons\solaron.ico
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Gui, Add, Picture, x12 y9 w110 h110 , My_Script_Resources\Coord Directions.png
Gui, Add, Text, x142 y27 w10 h20 , X:
Gui, Add, Edit, x155 y23 w40 h20 vcoordX,
Gui, Add, Text, x212 y27 w10 h20 , Y:
Gui, Add, Edit, x225 y23 w40 h20 vcoordY,
Gui, Add, Text, x192 y97 w110 h20 +Center, PrntScrn: Save Info
Gui, Add, GroupBox, x132 y3 w145 h50 , Mouse Coords
Gui, Add, GroupBox, x132 y53 w250 h67 , Save Coords and Color Info
Gui, Add, Edit, x145 y73 w120 h20 vsavedInfo,
Gui, Add, GroupBox, x282 y3 w100 h50 , Pixel Color
Gui, Add, Edit, x292 y23 w80 h20 vcolorTop,
Gui, Add, Edit, x292 y72 w80 h20 vcolorBottom,
Gui, +AlwaysOnTop
Gui, Show, x127 y87 h136 w467, Mouse Position

settimer UpdateMyTooltip, 0 ; use 0 to make it update position instantly

return

UpdateMyTooltip:
	MouseGetPos coordX, coordY ; get mouse x and y position, store as coordX and coordY
	GuiControl,,coordX,%coordX%
	GuiControl,,coordY,%coordY%
	PixelGetColor, pixelColor, %coordX%, %coordY%
	GuiControl,,colorTop,%pixelColor%
	Gui, submit, NoHide
	return
	
CopyCoords:
	GuiControl,,savedInfo,[X] %coordX%, [Y] %coordY%
	GuiControl,,colorBottom,%pixelColor%
	return
	
PrintScreen::Gosub, CopyCoords

+Esc::ExitApp
GuiClose:
	ExitApp

/*

COMMAND TEMPLATES:

Send, {left}{left}
Send, {enter}
Send, ]
Send, ^c

MouseGetPos,coordX,coordY
MouseClick, left, %coordX%, %coordY%

sleep, 100

if (myVar = 1){
	  myVar = 2
	} else if (myVar = 2){
	  myVar = 3
	}

CoordMode, ToolTip, Screen	
ToolTip, Here is my text!
ToolTip, Here is my text!, %coordX%, %coordY%
SetTimer, RemoveToolTip, -5000

;---------functions------------------------------------------

return

RemoveToolTip:
ToolTip
return

F4::Gosub, TurnBlue

TurnBlue:
  ;do stuff
  return

+Esc::ExitApp	
GuiClose:
	ExitApp

*/


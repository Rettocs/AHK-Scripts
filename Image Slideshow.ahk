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

;RESOLUTIONS
;dual monitors: 2560 x 1440
;TV:            1920 x 1080

;TOP LEFT
;monitor 1: -2560, 0
;monitor 2: 0, 0
;monitor 3: 2560, 0

myDirectory := "G:\My Drive\Software\1) My Creations\AHK\My_Script_Resources\test images"

fileList := [] 
alreadySeen := []
NEWIMAGEFLAG := "False"
currentTimeProgress := 0
imageShowTime := 300 ; (5 seconds = 500)
currentShowTime := imageShowTime
lockedShowTime := 999999
monitor := 1

if (monitor = 2) {
	NW_coord_X := 0
	NW_coord_Y := 0
	screen_res_X := 2560
	screen_res_Y := 1440
} else if (monitor = 1) {
	NW_coord_X := -2560
	NW_coord_Y := 0
	screen_res_X := 2560
	screen_res_Y := 1440
} else if (monitor = 3) {
	NW_coord_X := 2560
	NW_coord_Y := 0
	screen_res_X := 1920
	screen_res_Y := 1080
}

;FileSelectFolder, myDirectory
;Msgbox, you selected`n%myDirectory%

Loop %myDirectory%\*.*
{
	fileList.Push(A_LoopFileName)
}

Gui, 1:Color, black
;Gui, 1: +AlwayOnTop
Gui, 1: -Caption
Gui, 1: Show, x%NW_coord_X% y%NW_coord_Y% w%screen_res_X% h%screen_res_Y%

for index in fileList
{
	NEWIMAGEFLAG := "False"
	
	While NEWIMAGEFLAG = "False"
	{
		Random, randomFileNum, 1, fileList.MaxIndex()	

		filename := filelist[randomFileNum]
		
		;Msgbox, %filename%
		
		;checks if the filename is blacklisted
		if (filename = "Thumbs.db")
		{
			;msgbox, YUCK THUMBS
			alreadySeen.Push(randomFileNum)
		}
		
		;checks if randomFileNum not in alreadySeen
		if HasVal(alreadySeen, randomFileNum) = 0
		{
			NEWIMAGEFLAG := "True"
		}
		else
		{
			;valValue := HasVal(alreadySeen, randomFileNum)
			;msgbox, %valValue%
			NEWIMAGEFLAG := "False"
		}	
	}
	
	alreadySeen.Push(randomFileNum)
	
	;msgbox, you might not have seen %randomFileNum%
	;msgbox, already seen %alreadySeen%
	;SplashImage %myDirectory%\%filename%, x0 y0
	;Sleep, 5000
	;SplashImage, Off
	
	Gui, 2: add, picture, vmyImage, %myDirectory%\%filename%
	Gui, 2: Color, 000000
	Gui, 2: -Caption

    GuiControlGet, myImage, 2:Pos
	
	;msgbox, %filename% | x%myImageX% y%myImageY% w%myImageW% h%myImageH% | sx%screen_res_X% sy%screen_res_Y%
	
	resize_X := floor(screen_res_Y / (myImageH / myImageW))
	resize_Y := screen_res_Y
	moveTO_X := floor(((screen_res_X - resize_X) / 2) + NW_coord_X)
	moveTO_Y := floor((screen_res_Y - resize_Y) / 2)
		
	GuiControl, 2:Move, myImage, w%resize_X% h%resize_Y%
	
    ; If (myImageH > screen_res_Y)
	; {
		; resize_X := floor(screen_res_Y / (myImageH / myImageW))
		; resize_Y := screen_res_Y
		; moveTO_X := floor(((screen_res_X - resize_X) / 2) + NW_coord_X)
		; moveTO_Y := floor((screen_res_Y - resize_Y) / 2)
		
		; GuiControl, 2:Move, myImage, w%resize_X% h%resize_Y%
		
	; } else {

		; resize_X := myImageW
		; resize_Y := myImageH
		; moveTO_X := floor((screen_res_X - resize_X) / 2 + NW_coord_X)
		; moveTO_Y := floor((screen_res_Y - resize_Y) / 2)

	; }
	
	;msgbox, x%moveTO_X% y%moveTO_Y% w%resize_X% h%resize_Y%
	
	Gui, 2: show, x%moveTO_X% y%moveTO_Y% w%resize_X% h%resize_Y%
	
	;takes the monitor offset into account here
	;moveTO_X := moveTO_X + NW_coord_X
	
	;GuiControl, 2: Move, myImage, x%moveTO_X%
	
	;Gui, 2: show
	
	While currentTimeProgress < currentShowTime
	{
		Sleep, 10
		currentTimeProgress := currentTimeProgress + 1
	}
	
	Gui, 2: destroy
	currentTimeProgress := 0
	
}

Sleep, 3000
Gui, 1: destroy

return

Esc::ExitApp


Right::
	currentTimeProgress := 0
	currentShowTime := imageShowTime
	currentTimeProgress := currentShowTime
	return
	
Space::
	currentTimeProgress := 0
	currentShowTime := lockedShowTime
	return

HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}




; AHK codes: !=alt, ^=ctrl, +=shift, #=windows
; AHK codes: ~ computer will still see hotkey   $ hotkey wont run on it's own calling
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Singleinstance, force ; Ensures that there is only a single instance of this script running
;#NoTrayIcon
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

REFERENCE MATERIAL:

HOW TO USE THIS SCRIPT:

	Autoclicker will open with a GUI.
	
	Gui Controls:
	Click Rate - Select a time between clicks. This is in milliseconds. (1 sec = 1000)
	Switch Rate - If you have Secondary Position enabled, this is how many Primary Position clicks
		before the app performs a Secondary Position click.
	Primary Position - X and Y where the mouse will click if the "Add to Click Rotation" box is checked.
		Set this by hovering over the desired click spot and pressing "Print Screen" button on keyboard.
	Secondary Position - X and Y where the mouse will click if the "Add to Click Rotation" box is checked.
		Set this by hovering over the desired click spot and pressing "Shift" + "Print Screen" button on keyboard.
	Ready To Click - this checkbox arms the app to start listening for the keypresses of Y or N to start clicking.
		If this is unchecked, the app is not armed and Y or N will not begin clicks.

	Press these keys to control it:
		Y: start clicking
		N: end clicking
		PrintScreen: Set Primary Position, Add Primary Position to Click Rotation, and Checks "Ready to Click" box
		Shift + PrintScreen: Set Secondary Position, Add Secondary Position to Click Rotation, and Checks "Ready to Click" box


NOTES:
		
	In the code, The variable whichMouseBtn determines which click to perform
		Change the variable declaration to "Left" or "Right"

*/
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Include RandomBezier.ahk

CoordMode, Mouse, Screen

guiImage_ClicksEnabled := "G:\My Drive\Software\1) My Creations\AHK\My_Script_Resources\ClicksEnabled.png"
guiImage_ClicksDisabled := "G:\My Drive\Software\1) My Creations\AHK\My_Script_Resources\ClicksDisabled.png"

Gui, Add, GroupBox, x12 y9 w110 h90 , Click Rate
Gui, Add, Text, x32 y69 w70 h20 , 1 Sec / 1000
Gui, Add, Edit, x32 y39 w70 h20 vTimeBox,1000

Gui, Add, GroupBox, x12 y109 w110 h90 , Switch Rate
Gui, Add, Edit, x32 y129 w70 h20 vSwitchRate,1000000
Gui, Add, Text, x32 y152 w70 h40 , Click Primary X Times Before Secondary

Gui, Add, GroupBox, x132 y9 w170 h90 , Primary Position
Gui, Add, Edit, x152 y49 w60 h20 vSavedXPos1,
Gui, Add, Edit, x232 y49 w60 h20 vSavedYPos1,
Gui, Add, Text, x142 y52 w10 h20 , X
Gui, Add, Text, x222 y52 w10 h20 , Y
Gui, Add, CheckBox, x152 y69 w125 h28 vLockPos1, Add to Click Rotation
Gui, Add, Text, x152 y29 w140 h20 , PrntScrn to Set Position

Gui, Add, GroupBox, x132 y109 w170 h90 , Secondary Position
Gui, Add, Edit, x152 y149 w60 h20  vSavedXPos2,
Gui, Add, Edit, x232 y149 w60 h20  vSavedYPos2,
Gui, Add, Text, x142 y149 w10 h20 , X
Gui, Add, Text, x222 y149 w10 h20 , Y
Gui, Add, CheckBox, x152 y169 w125 h28 vLockPos2, Add to Click Rotation
Gui, Add, Text, x152 y129 w140 h20 , Shift + PrntScrn to Set

Gui, Add, GroupBox, x312 y9 w130 h190 , Status
Gui, Add, Picture, x332 y29 w90 h40 vStatusImage, %guiImage_ClicksDisabled%
Gui, Add, CheckBox, x332 y79 w90 h20 vReady gSubmitGui, Clicker Armed
Gui, Add, Text, x332 y99 w100 h20 , Start: Y   |   Stop: N

Gui, Add, Text, x322 y139 w30 h16 , Ratio
Gui, Add, Text, x322 y159 w30 h16 , Pri
Gui, Add, Text, x322 y179 w30 h16 , Sec
Gui, Add, Text, x352 y139 w87 h16 vSwitchCountTracker,0
Gui, Add, Text, x352 y159 w87 h16 vPriClickTracker,0
Gui, Add, Text, x352 y179 w87 h16 vSecClickTracker,0

Gui, Add, GroupBox, x12 y204 w430 h110 , Randomize
Gui, Add, CheckBox, x32 y219 w100 h30 vFuzzAreaCheckbox, Fuzzy Click Area
Gui, Add, CheckBox, x32 y249 w100 h30 vFuzzRateCheckbox, Fuzzy Click Rate
Gui, Add, CheckBox, x32 y279 w100 h30 vFuzzStopCheckbox, Fuzzy Auto Stop
Gui, Add, Text, x189 y227 w110 h20 , Sway Amount (Pixels)
Gui, Add, Text, x172 y257 w120 h20 , Time Drift (1 Sec = 1000)
Gui, Add, Text, x172 y287 w120 h20 , Auto Stop Threshold
Gui, Add, Edit, x302 y224 w60 h20 vFuzzAreaVar, 12
Gui, Add, Edit, x302 y254 w60 h20 vFuzzRateVar, 300
Gui, Add, Edit, x302 y284 w60 h20 vFuzzStopVar, 0

Gui, Add, GroupBox, x12 y320 w430 h75 , Other Options
Gui, Add, Text, x30 y340 w150 h20 , Stop After X Primary Clicks
Gui, Add, Edit, x175 y337 w60 h20 vMaxClicks, 0
Gui, Add, CheckBox, x30 y360 w150 h20 vClickSecondary, Click Secondary On Stop

Gui, +AlwaysOnTop
Gui, Show, x50 y50 h408 w455, Robot Mouse

Gui, submit, NoHide

whichMouseBtn := "Left" ;there is no other choice built in, yet
clickStatus := "OFF"

coord1_X := 0
coord1_Y := 0
coord2_X := 0
coord2_Y := 0

switchCounter := 0
PriClickCounter := 0
SecClickCounter := 0

SwitchCountTracker := 0
PriClickTracker := 0
SecClickTracker := 0
rememberPri := 0
rememberSec := 0

RandMoveTimeLow := 1011
RandMoveTimeHigh := 2973
WaitToClickLow := 73
WaitToClickHigh := 211

return

$y::
TurnOn:
	Gosub SubmitGui
	
	If (Ready = 1){
		If (LockPos1 = 1 or LockPos2 = 1){
			clickStatus := "ON"
			GuiControl,,StatusImage, %guiImage_ClicksEnabled%
			switchCounter := 0
			SwitchCountTracker := 0

			PriClickCounter := 0
			SecClickCounter := 0
			
			click_time := TimeBox
			;GuiControl,,SwitchCountTracker,%switchCounter%
			Gosub ClickerSetup
			;Gosub ChangePointer
		} else {
			GuiControl,,Ready,0
			Gosub SubmitGui
			;Gosub StandardPointer
		}
	} else {
		Send, y
	}
	return
	
$n::
TurnOff:
	Gosub SubmitGui
	
	If (Ready = 1){
		clickStatus := "OFF"
		switchCounter := 0
		GuiControl,,SwitchCountTracker,%switchCounter%
		rememberPri := PriClickCounter
		rememberSec := SecClickCounter
		PriClickTracker := 0
		SecClickTracker := 0
		GuiControl,,StatusImage, %guiImage_ClicksDisabled%
		Gosub ClickerSetup
		GuiControl,,PriClickTracker,%rememberPri%
		GuiControl,,SecClickTracker,%rememberSec%
		;Gosub StandardPointer
	} else {
		Send, n
	}
	return

;if the user presses any other letter, run the following:	
~a::
~b::
~c::
~d::
~e::
~f::
~g::
~h::
~i::
~j::
~k::
~l::
~m::
~o::
~p::
~q::
~r::
~s::
~t::
~u::
~v::
~w::
~x::
~z::
If (Ready = 1){
	GuiControl,,StatusImage, %guiImage_ClicksDisabled%
	GuiControl,,Ready,0
	Gosub SubmitGui
	;Msgbox, Autoclicker has been set to standby mode.
}
return

PrintScreen::
		GuiControl,,LockPos1,1
		GuiControl,,Ready,1
		LockPos1 = 1
		Ready = 1
		Gui, submit, NoHide
		
		MouseGetPos coord1_X, coord1_Y
		GuiControl,,SavedXPos1,%coord1_X%
		GuiControl,,SavedYPos1,%coord1_Y%
		Gosub SubmitGui
return

+PrintScreen::
		GuiControl,,LockPos2,1
		GuiControl,,Ready,1
		LockPos2 = 1
		Ready = 1
		Gui, submit, NoHide
		
		MouseGetPos coord2_X, coord2_Y
		GuiControl,,SavedXPos2,%coord2_X%
		GuiControl,,SavedYPos2,%coord2_Y%
		Gosub SubmitGui
return

SubmitGui:
	Gui, submit, NoHide
return

Randomizer:

	click_coord1_X := coord1_X
	click_coord1_Y := coord1_Y
	click_coord2_X := coord2_X
	click_coord2_Y := coord2_Y
	click_time := TimeBox
	auto_stop := MaxClicks
	move_speed := 0
	area_modifier := FuzzAreaVar
	Random, WaitToClick, WaitToClickLow, WaitToClickHigh
	Random, MyClickDelay, 13, 197
	
	If (FuzzAreaCheckbox = 1){
	
		Random, spread_factor, 1, 10
		
		If (spread_factor <= 7){
			area_modifier := Round(area_modifier * .65)
		} else if (spread_factor > 7 and spread_factor != 10){
			area_modifier := Round(area_modifier * .92)
		} else if (spread_factor = 10){
			area_modifier := Round(area_modifier * 1)
		}
	
		Random, click_coord1_X, coord1_X - area_modifier, coord1_X + area_modifier
		Random, click_coord1_Y, coord1_Y - area_modifier, coord1_Y + area_modifier
		Random, click_coord2_X, coord2_X - area_modifier, coord2_X + area_modifier
		Random, click_coord2_Y, coord2_Y - area_modifier, coord2_Y + area_modifier
				
	}
	
	If (FuzzRateCheckbox = 1){
		Random, click_time, TimeBox - FuzzRateVar, TimeBox + FuzzRateVar
		SetMouseDelay, %MyClickDelay%
	}
	
	If (FuzzStopCheckbox = 1){
		Random, auto_stop, MaxClicks - FuzzStopVar, MaxClicks + FuzzStopVar
	}
	
	Random, move_speed, 3, 30

RandomMovementPri:
	If(FuzzAreaCheckbox = 1 or FuzzRateCheckbox = 1){
		move_coord_X := click_coord1_X
		move_coord_Y := click_coord1_Y
	
		Gosub RandomStrayMovement
	}

return

RandomMovementSec:
	If(FuzzAreaCheckbox = 1 or FuzzRateCheckbox = 1){
		move_coord_X := click_coord2_X
		move_coord_Y := click_coord2_Y

		Gosub RandomStrayMovement
		
	}

return
	
RandomStrayMovement:

	MouseGetPos, MouseCurrentX, MouseCurrentY
	move_distance := sqrt((move_coord_Y-MouseCurrentY)**2+(move_coord_X-MouseCurrentX)**2)
	
	If (move_distance <= 35){
		;arbitrary cutoff... if it's less than that, no randomness added to movement
		
		return
	}
		
	If (FuzzRateCheckbox = 1){
		Random, MoveTimeMillis, RandMoveTimeLow, RandMoveTimeHigh
		WaitToClick := click_time - MoveTimeMillis
	} else {
		MoveTimeMillis := 0
		WaitToClick := click_time
	}
	
	OptionsString := "T" MoveTimeMillis " RO P2-8"
	RandomBezier(0, 0, move_coord_X, move_coord_Y, OptionsString)
		
return

ClickerSetup:
	If (clickStatus = "ON" && TimeBox > 0) 
	{
		SetTimer, Clicker, %click_time%
	}
	else if (clickStatus = "OFF")
	{
		SetTimer, Clicker, Off
	}
return

Clicker:
	If (Ready = 1){
		Gosub Randomizer
		
		GuiControl,,StatusImage, %guiImage_ClicksEnabled%
		If (LockPos1 = 1 && LockPos2 = 1){
			If (switchCounter >= SwitchRate){
				Gosub RandomMovementSec
				MouseClick, %whichMouseBtn%, %click_coord2_X%, %click_coord2_Y%
				switchCounter := 0
				SecClickCounter := SecClickCounter + 1
			} else if (switchCouter < SwitchRate){
				Gosub RandomMovementPri
				MouseClick, %whichMouseBtn%, %click_coord1_X%, %click_coord1_Y%
				switchCounter := switchCounter + 1
				PriClickCounter := PriClickCounter + 1
				GuiControl,,SwitchCountTracker,%switchCounter%
			}
		} else if (LockPos1 = 1 && LockPos2 = 0){
			Gosub RandomMovementPri
			MouseClick, %whichMouseBtn%, %click_coord1_X%, %click_coord1_Y%
			PriClickCounter := PriClickCounter + 1
		} else if (LockPos1 = 0 && LockPos2 = 1){
			Gosub RandomMovementSec
			MouseClick, %whichMouseBtn%, %click_coord2_X%, %click_coord2_Y%
			PriClickCounter := PriClickCounter + 1
		} else if (LockPos1 = 0 && LockPos2 = 0){
			MouseClick, %whichMouseBtn%, 1, %move_speed%
			PriClickCounter := PriClickCounter + 1
		}
		
		GuiControl,,SwitchCountTracker,%switchCounter%
		GuiControl,,PriClickTracker,%PriClickCounter%
		GuiControl,,SecClickTracker,%SecClickCounter%
		
		SoundBeep
		
		If (auto_stop = 0){
			auto_stop = 0
			
		} else if (PriClickCounter > auto_stop - 1){
			If (ClickSecondary = 1){
			
				Sleep, click_time
			
				Gosub RandomMovementSec
				MouseClick, %whichMouseBtn%, %click_coord2_X%, %click_coord2_Y%

				SecClickCounter := SecClickCounter + 1

				;GuiControl,,SwitchCountTracker,%switchCounter%
				;GuiControl,,PriClickTracker,%PriClickCounter%
				;GuiControl,,SecClickTracker,%SecClickCounter%
			
			}
			
			Gosub TurnOff
			SoundBeep, 750, 500
		
		}
		
		Gosub ClickerSetup

	}
	
return

ChangePointer:
	IDC_ARROW := 32512 ;standard arrow
	IDC_IBEAM := 32513 ;the I shape like editing a word document
	IDC_WAIT := 32514 ;spinning circle like loading
	IDC_CROSS := 32515 ;Looks like a plus sign or crosshairs
	IDC_UPARROW := 32516 ;skinny arrow pointing directly up
	IDC_SIZE := 32640 ;unknown, no effect
	IDC_ICON := 32641 ;unknown, no effect
	IDC_SIZENWSE := 32642 ;unknown
	IDC_SIZENESW := 32643 ;unknown
	IDC_SIZEWE := 32644 ;unknown
	IDC_SIZENS := 32645 ;unknown
	IDC_SIZEALL := 32646 ;unknown
	IDC_NO := 32648 ;red circle with slash thru it (no smoking sign)
	IDC_HAND := 32649 ;pointing finger like you're hovering over a link
	IDC_APPSTARTING := 32650 ;arrow with the loading circle next to it
	IDC_HELP := 32651 ;arrow with question mark next to it

	BUILT_IN_CURSOR := IDC_APPSTARTING ;<--------------this is the custom cursor
	CursorHandle2 := DllCall( "LoadCursor", Uint,0, Int,BUILT_IN_CURSOR )
	Cursors = 32512,
	Loop, Parse, Cursors, `, 
	{ 
		DllCall("SetSystemCursor", Uint, CursorHandle2, Int, A_Loopfield) 
	}
return

StandardPointer:
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
return

GuiClose:
  ExitApp
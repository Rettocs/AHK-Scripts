#Singleinstance, force
#NoTrayIcon
; AHK codes: !=alt, ^=ctrl, +=shift, #=windows
; AHK codes: ~ computer will still see hotkey   $ hotkey wont run on it's own calling
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; reference material:
; https://www.autohotkey.com/docs/commands/IniWrite.htm
; https://www.autohotkey.com/docs/commands/IniRead.htm
; https://www.autohotkey.com/docs/commands/IniDelete.htm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; IDEAS:
; put a "save to presets" checkbox and a name box to save the manual coords to the ini file
; every time gui is moved update ini to reflect the change, then on opening the gui, use this

; NOTES:
; try to make a preset with a new name
; try to overwrite a preset, say no to msg box. it should not overwrite
; try to overwrite a preset, say yes. it should overwrite
; did a new preset get added to the dropdown list?
; check if drop down list is in alphabetical order

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Initialize Variables
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

INIFILENAME := "Rettocs Window Wizard.ini"

;Menu, Tray, Icon, C:\Users\retto\Desktop\aquawave.ico
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IniRead, DD1Options, %INIFILENAME%, Dropdown Choices, DD1Options

Gui, Add, GroupBox, x7 y4 w360 h80 , Window Name
Gui, Add, Edit, x27 y34 w320 h20 vWindowName gWindowNameChanged, 
Gui, Add, Checkbox, x65 y58 w230 h20 vCopyWindowNameCheckbox gCopyWindowNameOptionClick Checked, Click twice on a window to copy its name

Gui, Add, GroupBox, x7 y94 w360 h120 , Window Location
Gui, Add, Radio, x27 y124 w50 h20 vMoveType, Preset
Gui, Add, Radio, x27 y164 w60 h20 Checked, Manual
Gui, Add, DropDownList, x87 y124 w260 h21 gPresetChanged vDD1Selection r10 Sort, %DD1Options%
Gui, Add, Edit, x87 y164 w50 h20 gManualChanged vWindowX, 0
Gui, Add, UpDown, x87 y164 w50 h20 Range5000--5000 0x80, 0
Gui, Add, Edit, x157 y164 w50 h20 gManualChanged vWindowY, 0
Gui, Add, UpDown, x157 y164 w50 h20 Range5000--5000 0x80, 0
Gui, Add, Edit, x227 y164 w50 h20 gManualChanged vWindowW, 0
Gui, Add, UpDown, x227 y164 w50 h20 Range-5000-5000 0x80, 0
Gui, Add, Edit, x297 y164 w50 h20 gManualChanged vWindowH, 0
Gui, Add, UpDown, x297 y164 w50 h20 Range-5000-5000 0x80, 0
Gui, Add, Text, x111 y184 w30 h20 , L / R
Gui, Add, Text, x179 y184 w30 h20 , U / D
Gui, Add, Text, x247 y184 w30 h20 , Width
Gui, Add, Text, x316 y184 w30 h20 , Height

Gui, Add, GroupBox, x7 y219 w360 h90 , Other Options
Gui, Add, Checkbox, x27 y244 w140 h20 vOnTopCheckbox gOnTopChanged, Toggle Always on Top
Gui, Add, Checkbox, x217 y244 w140 h20 vBordersCheckbox, Toggle Borders
Gui, Add, CheckBox, x27 y269 w60 h30 vOpacityCheckbox, Opacity
Gui, Add, Edit, x92 y274 w40 h20 vOpacityEditbox gOpacityChanged, 250
Gui, Add, UpDown, Range0-256, 250
Gui, Add, Checkbox, x217 y269 w140 h20 vRealTimeCheckbox, Real Time Changes

Gui, Add, GroupBox, x7 y314 w360 h90 , Save Options
Gui, Add, CheckBox, x27 y339 w180 h20 gSaveCoordsClicked vSaveCoordsCheckbox, Save Manual Coords to Presets
Gui, Add, Edit, x27 y369 w320 h20 vNewPresetName, New Preset Name

Gui, Add, Button, x7 y409 w360 h40 gTransform, Transform Window
Gui, +AlwaysOnTop
Gui, Show, x732 y476 h460 w383, Rettocs Window Wizard
Return


Transform:

	Gui, submit, NoHide
	GuiControlGet, WindowName
	GuiControlGet, DD1Selection

	SetTitleMatchMode 2
	
	;MsgBox, %DD1Selection%	

	If (MoveType = 1 && DD1Selection != "-" && WindowName != "" && WindowName != "Rettocs Window Wizard" && WindowName != "Rettocs Window Wizard.exe")
	{

		

		;Get Preset Coords
		IniRead, WindowX, %INIFILENAME%, %DD1Selection%, WindowX
		IniRead, WindowY, %INIFILENAME%, %DD1Selection%, WindowY
		IniRead, WindowW, %INIFILENAME%, %DD1Selection%, WindowW
		IniRead, WindowH, %INIFILENAME%, %DD1Selection%, WindowH

		WinMove, %WindowName%,, %WindowX%, %WindowY%, %WindowW%, %WindowH%
		
		;Put Coords into GUI
		GuiControl,,WindowX,%WindowX%
		GuiControl,,WindowY,%WindowY%
		GuiControl,,WindowW,%WindowW%
		GuiControl,,WindowH,%WindowH%

	}

	If (MoveType = 2 && WindowName != "" && WindowName != "Rettocs Window Wizard" && WindowName != "Rettocs Window Wizard.exe")
	{
		GuiControlGet, WindowX
		GuiControlGet, WindowY
		GuiControlGet, WindowW
		GuiControlGet, WindowH

		WinMove, %WindowName%,, %WindowX%, %WindowY%, %WindowW%, %WindowH%
	}
	
	If (OnTopCheckbox = 1)
	{
		;Msgbox, OnTop Checkbox ON
		Winset, Alwaysontop, Toggle, %WindowName%
	}
	
	If (BordersCheckbox = 1)
	{
		;Msgbox, Borders Checkbox ON
		WinSet, Style, ^0xC00000, %WindowName% ;removes title bar ^ is a toggle
		WinSet, Style, ^0x40000, %WindowName% ;removes resize border ^ is a toggle
	}
	
	If (OpacityCheckbox = 1)
	{
		WinSet, Transparent, %OpacityEditbox%, %WindowName%
	}

	If (SaveCoordsCheckbox = 1 && MoveType = 2)
	{
		
		;Open the ini file and get the DD1Options

		IniRead, DD1Options, %INIFILENAME%, Dropdown Choices, DD1Options

		;Break the options apart into an array

		OptionsList := DD1Options
		OptionsArray := []

		for a, b in StrSplit(OptionsList, "`|")
			OptionsArray.Insert(b)

		;check if new preset name is in the array

		FOUND := false
		Loop % OptionsArray.MaxIndex()
		{
			If (OptionsArray[a_index] == NewPresetName)
			{
				;YES: don't add anything to DD1Options

				FOUND := true
				;MsgBox, YES - Preset existed already

				MsgBox, 4,, Would you like to overwrite the preset %NewPresetName%?

				IfMsgBox No
					Return
			}
		}
		

		If (FOUND = false)
		{
			;NO: add new preset name to DD1Options
			;MsgBox, NO - It's a new preset name

			DD1Options = %DD1Options%|%NewPresetName%

			IniWrite, %DD1Options%, %INIFILENAME%, Dropdown Choices, DD1Options
			
		}


		;Write the 4 variables to their listings under the header of the new preset name
		
		;MsgBox, %WindowX%
		IniWrite, %WindowX%, %INIFILENAME%, %NewPresetName%, WindowX
		IniWrite, %WindowY%, %INIFILENAME%, %NewPresetName%, WindowY
		IniWrite, %WindowW%, %INIFILENAME%, %NewPresetName%, WindowW
		IniWrite, %WindowH%, %INIFILENAME%, %NewPresetName%, WindowH
		
		;MsgBox, Manual Pause

		;refresh the gui's dropdown list to include the most current info from the ini
		GuiControl,, DD1Selection, |%DD1Options%
				
		;uncheck the save coords box
		GuiControl,,SaveCoordsCheckbox, 0

	}

	;uncheck the Toggle Always On Top and Toggle Borders checkboxes
	GuiControl,,OnTopCheckbox, 0
	GuiControl,,BordersCheckbox, 0
	GuiControl,,OpacityCheckbox, 0

	Return

WindowNameChanged:

	GuiControlGet, WindowName

	WinGetPos, WindowX, WindowY, WindowW, WindowH, %WindowName%

	GuiControl,,WindowX,%WindowX%
	GuiControl,,WindowY,%WindowY%
	GuiControl,,WindowW,%WindowW%
	GuiControl,,WindowH,%WindowH%


	Return

PresetChanged:

	GuiControlGet, DD1Selection

	;Change Radio Input to Preset Selection
	GuiControl,,Preset, 1

	;Get Preset Coords
	IniRead, WindowX, %INIFILENAME%, %DD1Selection%, WindowX
	IniRead, WindowY, %INIFILENAME%, %DD1Selection%, WindowY
	IniRead, WindowW, %INIFILENAME%, %DD1Selection%, WindowW
	IniRead, WindowH, %INIFILENAME%, %DD1Selection%, WindowH
		
	;Put Coords into GUI
	GuiControl,,WindowX,%WindowX%
	GuiControl,,WindowY,%WindowY%
	GuiControl,,WindowW,%WindowW%
	GuiControl,,WindowH,%WindowH%

	Return

ManualChanged:

	GuiControlGet, WindowName
	GuiControlGet, RealTimeCheckbox
	GuiControlGet, MoveType

	;Tooltip, I'm here
	If (RealTimeCheckbox = 1 && WindowName != "" && WindowName != "Rettocs Window Wizard" && WindowName != "Rettocs Window Wizard.exe")
	;If (MoveType = 2 && RealTimeCheckbox = 1 && WindowName != "" && WindowName != "Rettocs Window Wizard" && WindowName != "Rettocs Window Wizard.exe")
	{
		;Tooltip, You're In
		GuiControlGet, WindowX
		GuiControlGet, WindowY
		GuiControlGet, WindowW
		GuiControlGet, WindowH

		WinMove, %WindowName%,, %WindowX%, %WindowY%, %WindowW%, %WindowH%		
	}

	Return

OpacityChanged:

	GuiControlGet, RealTimeCheckbox
	GuiControlGet, OpacityCheckbox
	GuiControlGet, OpacityEditbox

	If (OpacityCheckbox = 1 && RealTimeCheckbox = 1 && WindowName != "" && WindowName != "Rettocs Window Wizard" && WindowName != "Rettocs Window Wizard.exe")
	{
		WinSet, Transparent, %OpacityEditbox%, %WindowName%
	}
	Return

CopyWindowNameOptionClick:

	GuiControlGet, CopyWindowNameCheckbox

	If (CopyWindowNameCheckbox = 1)
	{
		Return
	}

	Return

OnTopChanged:
	GuiControlGet, RealTimeCheckbox
	GuiControlGet, OnTopCheckbox
	
	If (OnTopCheckbox= 1 && RealTimeCheckbox = 1 && WindowName != "" && WindowName != "Rettocs Window Wizard" && WindowName != "Rettocs Window Wizard.exe")
	{
		Winset, Alwaysontop, Toggle, %WindowName%
		Sleep, 300
		GuiControl,,OnTopCheckbox,0
	}
	Return	

~LButton::

	GuiControlGet, CopyWindowNameCheckbox

	If (CopyWindowNameCheckbox = 1)
	{ 

		WinGetTitle, ActiveName, A
	
		If (ActiveName != "" && ActiveName != "Rettocs Window Wizard" && WindowName != "Rettocs Window Wizard.exe")
		{
			CopiedWindowName := ActiveName
			GuiControl,,WindowName,%CopiedWindowName%
			WinGet, TransLevel, Transparent, %CopiedWindowName%
			If (TransLevel = "")
			{
				TransLevel := 256
			}
			GuiControl,,OpacityEditbox,%TransLevel%
		}
	}

	Return

SaveCoordsClicked:
	GuiControl,,Manual, 1
	Return

GuiClose:
	ExitApp
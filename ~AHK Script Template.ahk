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

myMessage := "I'm just a template, bro!"
Msgbox, %myMessage%

+Esc::ExitApp

/*  ----------------------------------------------COMMAND TEMPLATES:------------------------

Send, {left}{left}
Send, {enter}
Send, ]
Send, ^c

--------------------------------------------------MSG BOX-----------------------------------
;further reading
https://www.autohotkey.com/docs/v1/lib/MsgBox.htm

MsgBox, Text
MsgBox , Options, Title, Text, Timeout

MsgBox, 4, Information, This message will timeout in five seconds, 5
IfMsgBox Timeout
    MsgBox You didn't press YES or NO within the 5-second period.
else IfMsgBox No
    return
	
Msgbox Options:
    0	OK only
	1	OK/Cancel
	2	Abort/Retry/Ignore
	3	Yes/No/Cancel
	4	Yes/No
	5	Retry/Cancel
	6	Cancel/Try Again/Continue
	
--------------------------------------------------------------------------------------------

file := "My_Script_Resources\Nope.png"

filename := "Dauntless Notes Area Saved.INI"
UseAppend1 := 0
clipboard = %filename%

;here's how to concat strings and variables
var1 := "Shawn"
var2 := 67
concat_strings := var1 " is " var2 " inches tall."
Msgbox, %concat_strings%

MouseGetPos,coordX,coordY
MouseMove, X, Y
MouseClick, left, %coordX%, %coordY%

sleep, 100

if (myVar = 1){
	  myVar = 2
	} else if (myVar = 2){
	  myVar = 3
	}

;text manipulation
StringReplace,outputVar,inputVar,-,%A_Space%, All ;replaces all "-" and replaces with " "
outputVar := StrReplace(inputVar, "-",A_Space)    ;replaces all "-" and replaces with " "
StringLower, outputVar, inputVar                  ;converts all uppercase into lowercase
partsArray := StrSplit(inputVar, "-",, 3)         ;splits a string when "-" is found; max 3 parts created
outputVar := SubStr(inputVar, 2, -5)               ;trims the first char off, and the last 5 chars off
	
ToolTip, Here is my text!
ToolTip, Here is my text!, %coordX%, %coordY%
SetTimer, RemoveToolTip, -5000

IfWinExist Google Chrome
{
	WinActivate  Google Chrome
} else {
	Run, chrome.exe
}

varTextContents := StrReplace(varTextContents, "textToSearchFor", "textToReplaceWith")

GuiControlGet, WriteBox ;gets the text from the GUI control "WriteBox"
GuiControl,,WriteBox,%WriteBox% ;puts in text from the variable into the GUI

--------------------------------------------------TEXT FILES--------------------------------
sourceFileName := "G:\My Drive\Documents\AHK_Test_Input.txt"
outputFileName := "G:\My Drive\Documents\AHK_Test_Output.txt"

FileRead, varTextContents, %sourceFileName%
if not ErrorLevel  ;Successfully loaded.
{
    FileDelete, %outputFileName% ;Ensure the output file doesn't already exist or contain data
    FileAppend, %varTextContents%, %outputFileName% ;Creates the file and puts the var contents into it
    varTextContents := ""  ;Clears the var to free the memory
}
--------------------------------------------------EXCEL-------------------------------------
;further reading
https://www.autohotkey.com/board/topic/69033-basic-ahk-l-com-tutorial-for-excel/page-1
https://www.autohotkey.com/board/topic/56987-com-object-reference-autohotkey-v11/

myExcel := ComObjActive("Excel.Application") ;Attach to Active Excel Application

myExcel.ActiveSheet.Range("A1").Value := "This is Cell A1" ;put this text in Cell A1 in Active Excel opened File
cellValue := myExcel.ActiveSheet.Range("B2").Value ;Get the text from Cell B2
cellValue := myExcel.ActiveCell.Value ;gets the text from the currently-selected cell
yValue = % ComObjActive("Excel.Application").ActiveCell.Row ;gets what row is selected
xValue = % ComObjActive("Excel.Application").ActiveCell.Col ;gets what col is selected
myExcel.ActiveCell.Offset(0, 1).Select ;selects the cell to the right of the previous cell
MsgBox, %cellValue%

---

myExcel := ComObjActive("Excel.Application")
foundcell := myExcel.Worksheets("Sheet1").Range("B2:B11").Find("city of brass")
msgbox % foundcell.address
msgbox % foundcell.value

--------------------------------------------------FUNCTION TEMPLATES:-----------------------

return

RemoveToolTip:
ToolTip
return

LButton:: ;do stuff
RButton:: ;do stuff

F4::Gosub, TurnBlue

Alt::Send, {shift down}
Alt up::Send, {shift up} 

TurnBlue:
  ;do stuff
  return

+Esc::ExitApp
	
GuiClose:
	ExitApp

*/


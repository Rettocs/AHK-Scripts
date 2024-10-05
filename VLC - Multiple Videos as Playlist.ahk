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

;DIRECTORY MUST END WITH A BACKSLASH (\)
mydirectory := "\\192.168.1.2\Videos\3D Prints\"

list_files(Directory)
{
	files := ""
	Loop %Directory%\*.*
	{
		files = %files%`n%A_LoopFileName%
	}
	return files
}

list_paths(Directory)
{
	paths := ""
 	Loop %Directory%\*.*
	if (A_LoopFileName != "C:\Users\GamingPC\AppData\Local\Temp")
	{
		paths = %paths%`n"%Directory%%A_LoopFileName%"
	}
	
	return paths
}

Shuffle(arr) {
	; Skip simple cases
	If (arr.Length() <= 1)
		Return
	
	If (arr.Length() == 2) {
		Random, swap, 0, 1
		If (swap == 1)
			SwapInArray(arr, 1, 2)
		Return
	}
	
	Loop 25 {  ; Iterations
		Loop % arr.Length() {
			; Choose 2 random indices
			Random, indexA, 1, % arr.Length()
			Random, indexB, 1, % arr.Length()-1
			
			; Make sure they aren't equal and evenly distributed
			indexB += (indexB >= indexA)
			
			; Swap elements
			SwapInArray(arr, indexA, indexB)
		}
	}
}

SwapInArray(arr, indexA, indexB) {
	temp := arr[indexA]
	arr[indexA] := arr[indexB]
	arr[indexB] := temp
}

JoinArray(arr) {
	msg := ""
	
	Loop % arr.Length() {
		;msg .= arr[A_Index] ", "
		msg .= arr[A_Index] "`n"
	}
	
	Return SubStr(msg, 1, -2)
}

;myfilelist := list_files(mydirectory)
mypathtext := list_paths(mydirectory)
mypatharray := StrSplit(mypathtext, "`n")
Shuffle(mypatharray)
randomarray := mypatharray
;randomarray := Shuffle_Array(mypatharray)

;Msgbox % JoinArray(randomarray)

Loop % randomarray.Length()
	if (randomarray[A_Index] = "C:\Users\GamingPC\AppData\Local\Temp")
	{
		;I don't know why this keeps being added into the array, but this will skip it when it comes up.
		sleep, 1
	}
	else
	{
	Run % """C:\Program Files\VideoLAN\VLC\vlc.exe"" --one-instance --playlist-enqueue " . randomarray[A_Index]
	}

return

Esc::ExitApp
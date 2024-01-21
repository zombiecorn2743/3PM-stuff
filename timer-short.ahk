#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; from "just me" on the AHK fora
F10::
SetBatchLines, -1
Loop {
	If (A_Sec = 10) && (Mod(A_Min, 5) = 2) {
		GoSub, MyCode
		While (A_Sec = 10) ; skip the rest of the second, if any
		Sleep, 1000
	}
	Else
		Sleep, 100 ; accuracy = 100 ms, must be less than 1000 ms
}
ExitApp
; ==============================================================================
MyCode: ; your code here
; SoundPlay ALARM_Foghorn_end_stereo.wav
SoundPlay short.mp3
; SoundBeep
; ToolTip, My code: %A_Hour%:%A_Min%:%A_Sec%
Return


#t::
Suspend, off
SoundPlay timer-on.mp3
return

#+t::
Suspend, on
SoundPlay timer-off.mp3
return



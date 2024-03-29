﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global ClipNumber
global Title
; global multiboard_path
; multiboard_path := "hello"
global multiboard_path
multiboard_path := A_ScriptDir . "\CSVs\multiboard.csv"

#Include, CSV-master\csv.ahk
CSV_Load(multiboard_path,"mb")
#Include 3Play 2023 Firefox.ahk
#SingleInstance, force


; CSV_Load("multiboard.csv","mb")


; MsgBox % "There are " CSV_TotalRows("mb") " rows in this CSV file."

; z::
; MsgBox % "There are " CSV_TotalRows("mb") " rows in this CSV file. And the file path is " multiboard_path
; ; MsgBox % multiboard_path
; ; Clipboard := %multiboard_path%
; ; Clipboard := CSV_ReadCell("mb", 1,1)
; return

ClipNumberFunction() {
value := SubStr(A_ThisHotkey, 0) * 1
switch value {
	case 0: ClipNumber := 10
	default: ClipNumber := value
}
return ClipNumber 
}

MultiboardPaste3Play() {
	Clip := CSV_ReadCell("mb", ClipNumber,1)
;	OldClipboard := Clipboard
	Clipboard := Clip
	3PlayPaste()
;	Clipboard := OldClipboard
}

MultiboardPasteOther() {
	Clip := CSV_ReadCell("mb", ClipNumber,1)
;	OldClipboard := Clipboard
	Send, %Clip% 
;	Clipboard:= OldClipboard
}

MultiboardPaste() {
	; ClipNumber := SubStr(A_ThisHotkey, 0) * 1
	ClipNumberFunction()
	WinGetActiveTitle, Title
	switch Title {
		case "STOE Editor v5.0 — Mozilla Firefox": MultiboardPaste3Play()
		default: MultiboardPasteOther()
		; MsgBox % Title
	}
}

; z::
; WinGetActiveTitle, Title
; MsgBox % Title
; return

#1::MultiboardPaste()
#2::MultiboardPaste()
#3::MultiboardPaste()
#4::MultiboardPaste()
#5::MultiboardPaste()
#6::MultiboardPaste()
#7::MultiboardPaste()
#8::MultiboardPaste()
#9::MultiboardPaste()
#0::MultiboardPaste()


SaveToMultiboard3Play() {
	OldClipboard := Clipboard
	ClipWaitFunction3Play()
	CSV_ModifyCell("mb",Clipboard,ClipNumber,1)
	CSV_Save(multiboard_path,"mb")
	Clipboard := OldClipboard
}

SaveToMultiboardOther() {
	OldClipboard := Clipboard
	ClipWaitFunctionOther()
	CSV_ModifyCell("mb", Clipboard,ClipNumber,1)
	CSV_Save(multiboard_path,"mb")
	Clipboard := OldClipboard
}

SaveToMultiboard() {
	; ClipNumber := SubStr(A_ThisHotkey, 0) * 1
	ClipNumberFunction()
	WinGetActiveTitle, Title
	switch Title {
		case "STOE Editor v5.0 — Mozilla Firefox": SaveToMultiboard3Play()
		default: SaveToMultiboardOther()
	}
}

#+1::SaveToMultiboard()
#+2::SaveToMultiboard()
#+3::SaveToMultiboard()
#+4::SaveToMultiboard()
#+5::SaveToMultiboard()
#+6::SaveToMultiboard()
#+7::SaveToMultiboard()
#+8::SaveToMultiboard()
#+9::SaveToMultiboard()
#+0::SaveToMultiboard()





#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force 

#Include csv.ahk

Results := []
DefaultSearchValue := "hi" 

CSV_Load("ExampleCSVFile.csv","data")

Rows := CSV_TotalRows("data")

Loop, % Rows
{
	 ; found := CSV_SearchColumn("data","99",1,A_Index)
	 found := CSV_MatchCellColumn("data","1998",1,A_Index)
	 if (found = 0) {
		 ;MsgBox "zero!"
		 break
	 }
	 else {
		 Results.Push(found)
		 Match := CSV_ReadCell("data", found, 2)
		 Pretty_Results .= Results.MaxIndex() ":  " Match "`n"
		 ; Pretty_Results .= found "`n"
	 }
}

; Results.Push("hello")

; MsgBox % Results[]
; MsgBox % Results.MinIndex()
; MsgBox % Pretty_Results

; if (Results.MinIndex() < 1) {
; 	MsgBox "zero!"
; }
; else {
; 	MsgBox "contents"
; }

!c::
Gui, 2:new
Gui, 2:Font, s30, Segoe UI
Gui, 2:Add, Text,, %Pretty_Results%
; Gui, 2:Add, Edit, r1 vFirst2 w400, %DefaultSearchValue%
Gui, 2:Show,, Results ;w500 h370, Results
return 

2GuiEscape:
	; Gui, 2:-Disabled
	Gui, 2:Destroy
return
return 

#IfWinActive Results ahk_class AutoHotkeyGUI
1::
2::
Gui, 2:Destroy
String_to_send := CSV_ReadCell("data", Results[A_ThisHotkey], 2)
Sleep, 20
Send, %String_to_send%
Return
#IfWinActive


; For index, value in Results
  ;  MsgBox % "Item " index " is '" value "'"

    ; MsgBox % found 













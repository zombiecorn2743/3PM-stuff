#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetBatchLines, -1
StringCaseSense, On
#SingleInstance, Force
;global dictionary_path := A_ScriptDir . "\CSVs\dictionary.csv"
global Dictionary_English_Path := A_ScriptDir . "\CSVs\dictionary-english.csv"
global Dictionary_Castilian_Path := A_ScriptDir . "\CSVs\dictionary-castilian.csv"
global Dictionary_Path_Current 
global Rows
global Row_Position
global Results := []
global Corresponding_Value
global Word_to_Query
global Title
global vFirst3
global String_to_Add
global Source
global Dictionary_to_Use 
;global URL_Array

#Include CSV-master\csv.ahk
;CSV_Load(dictionary_path,"dc")
CSV_Load(Dictionary_English_Path,"de")
CSV_Load(Dictionary_Castilian_Path,"dc")
#Include 3play 2023 FF New.ahk

Language_Check() {
	Clipwait_Function()
	Send, {shift down}{ctrl down}{alt down}{i down}{i up}{alt up}{ctrl up}{shift up}
	Loop, 10 {
 		Sleep, AHK_JS_Bridge_Delay
		switch Clipboard {
			case "english":
				Dictionary_to_Use := "de"
				Dictionary_Path_Current := Dictionary_English_Path
				break
			case "spanish":
				Dictionary_to_Use := "dc"
				Dictionary_Path_Current := Dictionary_Castilian_Path
				break
			default:
				Dictionary_to_Use := "de"
				break
		}
	}
}

$#d::
;Successful_Lookup()
MsgBox % Dictionary_to_Use
MsgBox % Dictionary_Path_Current
return 

Successful_Lookup() {
	Success_Text := Clipboard . "  ✓"
	SetTimer, Success_Message
	; MsgBox Success!
;	return 
}

$#z::
;Successful_Lookup()
Rows := CSV_TotalRows("dc")
MsgBox % Rows
return 

;$^q::
Lookup_Word() {
Results := []
Pretty_Results := ""
Clipboard_Save()
Clipwait_Function()
;Send, {Ctrl down}{c down}{c up}{Ctrl up}
Clipboard_Trim()
Word_to_Query := Clipboard
Language_Check()
Rows := CSV_TotalRows(Dictionary_to_Use)
Loop, % Rows
{
;	 found := CSV_MatchCellColumn("dc",Word_to_Query,1,A_Index)
	 found := CSV_MatchCellColumn(Dictionary_to_Use,Word_to_Query,1,A_Index)
	 if (found = 0) {
		 break
	 }
	 else {
		 Results.Push(found)
		 ;Match := CSV_ReadCell("dc", found, 2)
;		 Match := CSV_ReadRow("dc", found)
		 Match := CSV_ReadRow(Dictionary_to_Use, found)
		 Pretty_Results .= Results.MaxIndex() ":  " Match "`n"
		 ; Pretty_Results .= found "`n"
	 }
}
;MsgBox % Rows
;MsgBox % Word_to_Query
;MsgBox % Pretty_Results

if (Results.MaxIndex() < 1) {
	Send, {ctrl down}{y down}{y up}{ctrl up}
	Warning_Text := Word_to_Query . " not found"
	SetTimer, Warning_Message
	Clipboard_Resurrect()
	return 
}
else if (Results.MaxIndex() = 1) {
	Row_Position := CSV_MatchCellColumn(Dictionary_to_Use, Word_to_Query, 1)
	;Corresponding_Value
	String_to_send := CSV_ReadCell(Dictionary_to_Use, Row_Position, 2)
	if (String_to_send == Word_to_Query) {
		Success_Text := Word_to_Query . " ✓`n" . CSV_ReadCell(Dictionary_to_Use, Row_Position, 3) . "`n" . CSV_ReadCell(Dictionary_to_Use, Row_Position, 4)
		SetTimer, Success_Message
		Clipboard_Resurrect()
		return 
	} else {
		;String_to_send := CSV_ReadCell(Dictionary_to_Use, 1, 2)
		;MsgBox % Row_Position
		;MsgBox % String_to_send
		Clipboard := String_to_send ;Corresponding_Value
		Send, {alt down}{backspace down}{backspace up}{alt up}
		Send, {shift down}{ctrl down}{v down}{v up}{ctrl up}{shift up}
		sleep, Sleep_Very_Big
		Clipboard_Resurrect()
		return 
	}
}
else {
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
}
return ;}
}

Sanitize_String(x) {
	return StrReplace(x, "%20", A_Space)
}

Add_Word_Simple() {
	Title_Split := StrSplit(Title, "URL:")
	URL := StrSplit(Title_Split[2], " — Mozilla Firefox")
	URL_Array := StrSplit(URL[1], "/")
	;MsgBox % Title_Split[1]
	;MsgBox % URL[1]
Source := String_Trim(URL_Array[3])
String_to_Add := Sanitize_String(String_Trim(URL_Array[URL_Array.MaxIndex()]))
;MsgBox % String_to_Add
RowToAdd := Word_to_Query . "," . String_to_Add . "," . Source . ",automatic"
;value := CSV_MatchRow(Dictionary_to_Use,RowToAdd)
;MsgBox % value 
;MsgBox % RowToAdd
if (CSV_MatchRow(Dictionary_to_Use,RowToAdd) = 0) {
	if (Word_to_Query = "") {
		Error_Text := "Query string empty!"
		SetTimer, Error_Message
		return 
	} else {
		CSV_AddRow(Dictionary_to_Use, RowToAdd)
		CSV_Save(Dictionary_Path_Current,Dictionary_to_Use)
		Success_Text := Word_to_Query . "`nadded and saved!"
		SetTimer, Success_Message
		return

	}
} else {
	Warning_Text := "entry already exists"
	SetTimer, Warning_Message
	return 
}
}

Add_Word_Simple_RAE() {
	Title_Split := StrSplit(Title, "URL:")
	URL := StrSplit(Title_Split[2], " — Mozilla Firefox")
	URL_Array := StrSplit(URL[1], "/")
URL_Word := StrSplit(URL_Array[URL_Array.MaxIndex()], "?m=form")
	;MsgBox % Title_Split[1]
	;MsgBox % URL[1]
Source := String_Trim(URL_Array[3])
;String_to_Add := Sanitize_String(String_Trim(URL_Array[URL_Array.MaxIndex()]))
;MsgBox % String_to_Add
;MsgBox % URL_Word[1]
if (Word_to_Query = URL_Word[1]) {
	String_to_Add := Sanitize_String(URL_Word[1])
} else {
	String_to_Add := Sanitize_String(Word_to_Query)
	;StringLower, String_to_Add, String_to_Add
}
RowToAdd := Word_to_Query . "," . String_to_Add . "," . Source . ",automatic"
;value := CSV_MatchRow(Dictionary_to_Use,RowToAdd)
;MsgBox % value 
;MsgBox % RowToAdd
if (CSV_MatchRow(Dictionary_to_Use,RowToAdd) = 0) {
	if (Word_to_Query = "") {
		Error_Text := "Query string empty!"
		SetTimer, Error_Message
		return 
	} else {
		CSV_AddRow(Dictionary_to_Use, RowToAdd)
		CSV_Save(Dictionary_Path_Current,Dictionary_to_Use)
		Success_Text := Word_to_Query . "`nadded and saved!"
		SetTimer, Success_Message
		return

	}
} else {
	Warning_Text := "entry already exists"
	SetTimer, Warning_Message
	return 
}
}



;Codebook Definition & Meaning - Merriam-Webster URL: https://www.merriam-webster.com/dictionary/codebook — Mozilla Firefox
;Runbook - Definition and More from the Free Merriam-Webster Dictionary URL: https://www.merriam-webster.com/dictionary/runbook — Mozilla Firefox
;thirteen - Wiktionary, the free dictionary URL: https://en.wiktionary.org/wiki/thirteen — Mozilla Firefox
;13 - Wikipedia URL: https://en.wikipedia.org/wiki/Thirteen — Mozilla Firefox
;conducto | Definición | Diccionario de la lengua española | RAE - ASALE URL: https://dle.rae.es/conducto?m=form — Mozilla Firefox
;problema - Wikcionario, el diccionario libre URL: https://es.wiktionary.org/wiki/problema — Mozilla Firefox
;problema | Diccionario de americanismos | ASALE URL: https://www.asale.org/damer/problema — Mozilla Firefox
;mijo, mija | Diccionario de americanismos | ASALE URL: https://www.asale.org/damer/mijo — Mozilla Firefox
;Definition & Meaning | Merriam-Webster Medical
$#y::
WinGetTitle, Title, A
;Clipboard := Title
switch {
	case InStr(Title, "STOE Editor v5.0"):
		Lookup_Word()
		;MsgBox "STOE"
		return
	case InStr(Title, "Definition & Meaning - Merriam-Webster"):
		Add_Word_Simple()
		;MsgBox "STOE"
		return
	case InStr(Title, "Definition & Meaning | Merriam-Webster Medical"):
		Add_Word_Simple()
		;MsgBox "STOE"
		return
	case InStr(Title, "Wiktionary, the free dictionary"):
		Add_Word_Simple()
		;MsgBox "STOE"
		return
	case InStr(Title, "Wikipedia"):
		Add_Word_Simple()
		;MsgBox "STOE"
		return
	case InStr(Title, "Definición | Diccionario de la lengua española | RAE - ASALE"):
		Add_Word_Simple_RAE()
		;MsgBox "STOE"
		return
	case InStr(Title, "Wikcionario, el diccionario libre"):
		Add_Word_Simple()
		;MsgBox "STOE"
		return
	case InStr(Title, "Diccionario de americanismos | ASALE"):
		Add_Word_Simple()
		;MsgBox "STOE"
		return
	case InStr(Title, "Notepad++"):
		MsgBox green 
		return 
	default:	
		MsgBox "default, ha ha"
		return 
}

return

Add_Word_Complex() {
	Title_Split := StrSplit(Title, "URL:")
	URL := StrSplit(Title_Split[2], " — Mozilla Firefox")
	URL_Array := StrSplit(URL[1], "/")
	;MsgBox % Title_Split[1]
	;MsgBox % URL[1]
Source := String_Trim(URL_Array[3])
String_to_Add := Sanitize_String(String_Trim(URL_Array[URL_Array.MaxIndex()]))
;MsgBox % String_to_Add

Gui, 3:new
Gui, 3:Font, s30, Segoe UI
Gui, 3:Add, Text,, %Word_to_Query%`n%String_to_Add%`n%Source% 
Gui, 3:Add, Edit, r1 w400, manual
; Gui, 2:Add, Edit, r1 vFirst2 w400, %DefaultSearchValue%
Gui, 3:Add, Button, default, Enter
Gui, 3:Show,, Add Word Complex ;w500 h370, Results
return

3GuiEscape:
	; Gui, 2:-Disabled
	Gui, 3:Destroy
if (WinExist("STOE Editor v5.0")) {
	WinActivate ; Use the window found by WinExist.
}
	return

3ButtonEnter:
	Gui, 3:Submit  ; Save the input from the user to each control's associated variable.
	ControlGetText, 3GuiText_1, Edit1
;return
;msgbox % 3GuiText_1
; if (3GuiText_1 = "") {
; 	; msgbox % Number2 " is the value"
; 	msgbox % 3GuiText_1 " is equal to """""
; } else {
; 	msgbox % 3GuiText_1 " is not equal to """""
; }

if (InStr(3GuiText_1, ",")) {
	3GuiText_1 := """" . 3GuiText_1 . """"
}
RowToAdd := Word_to_Query . "," . String_to_Add . "," Source . "," . 3GuiText_1
;msgbox % RowToAdd

if (CSV_MatchRow(Dictionary_to_Use,RowToAdd) = 0) {
	if (Word_to_Query = "") {
		Error_Text := "Query string empty!"
		SetTimer, Error_Message
		return 
	} else {
		CSV_AddRow(Dictionary_to_Use, RowToAdd)
		CSV_Save(Dictionary_Path_Current,Dictionary_to_Use)
		Success_Text := Word_to_Query . "`nadded and saved!"
		SetTimer, Success_Message
		return

	}
} else {
	Warning_Text := "entry already exists"
	SetTimer, Warning_Message
	return 
}

;CSV_AddRow(Dictionary_to_Use, RowToAdd)
;CSV_Save(Dictionary_Path_Current,Dictionary_to_Use) 
if (WinExist("STOE Editor v5.0")) {
	WinActivate ; Use the window found by WinExist.
}
return 
}

Add_Word_Complex_RAE() {
	Title_Split := StrSplit(Title, "URL:")
	URL := StrSplit(Title_Split[2], " — Mozilla Firefox")
	URL_Array := StrSplit(URL[1], "/")
	URL := StrSplit(Title_Split[2], " — Mozilla Firefox")
	URL_Array := StrSplit(URL[1], "/")
	URL_Word := StrSplit(URL_Array[URL_Array.MaxIndex()], "?m=form")
	;MsgBox % Title_Split[1]
	;MsgBox % URL[1]
Source := String_Trim(URL_Array[3])
;String_to_Add := Sanitize_String(String_Trim(URL_Array[URL_Array.MaxIndex()]))
;MsgBox % String_to_Add
;MsgBox % URL_Word[1]
if (Word_to_Query = URL_Word[1]) {
	String_to_Add := Sanitize_String(URL_Word[1])
} else {
	String_to_Add := Sanitize_String(Word_to_Query)
	;StringLower, String_to_Add, String_to_Add
}
Gui, 4:new
Gui, 4:Font, s30, Segoe UI
Gui, 4:Add, Text,, %Word_to_Query%`n%String_to_Add%`n%Source% 
Gui, 4:Add, Edit, r1 w400, manual
; Gui, 2:Add, Edit, r1 vFirst2 w400, %DefaultSearchValue%
Gui, 4:Add, Button, default, Enter
Gui, 4:Show,, Add Word Complex ;w500 h370, Results
return

4GuiEscape:
	; Gui, 2:-Disabled
	Gui, 4:Destroy
if (WinExist("STOE Editor v5.0")) {
	WinActivate ; Use the window found by WinExist.
}
	return

4ButtonEnter:
	Gui, 4:Submit  ; Save the input from the user to each control's associated variable.
	ControlGetText, 4GuiText_1, Edit1
;return
;msgbox % 3GuiText_1
; if (3GuiText_1 = "") {
; 	; msgbox % Number2 " is the value"
; 	msgbox % 3GuiText_1 " is equal to """""
; } else {
; 	msgbox % 3GuiText_1 " is not equal to """""
; }

if (InStr(4GuiText_1, ",")) {
	4GuiText_1 := """" . 4GuiText_1 . """"
}
RowToAdd := Word_to_Query . "," . String_to_Add . "," Source . "," . 4GuiText_1
;msgbox % RowToAdd

if (CSV_MatchRow(Dictionary_to_Use,RowToAdd) = 0) {
	if (Word_to_Query = "") {
		Error_Text := "Query string empty!"
		SetTimer, Error_Message
		return 
	} else {
		CSV_AddRow(Dictionary_to_Use, RowToAdd)
		CSV_Save(Dictionary_Path_Current,Dictionary_to_Use)
		Success_Text := Word_to_Query . "`nadded and saved!"
		SetTimer, Success_Message
		return

	}
} else {
	Warning_Text := "entry already exists"
	SetTimer, Warning_Message
	return 
}

;CSV_AddRow(Dictionary_to_Use, RowToAdd)
;CSV_Save(Dictionary_Path_Current,Dictionary_to_Use) 
if (WinExist("STOE Editor v5.0")) {
	WinActivate ; Use the window found by WinExist.
}
return 
}


Add_Word_Complex_STOE() {
Clipboard_Save()
Clipwait_Function()
;Send, {Ctrl down}{c down}{c up}{Ctrl up}
Clipboard_Trim()
Word_to_Query := Clipboard
Language_Check()
Source := "personal"
String_to_Add := Word_to_Query
Clipboard_Resurrect()
;MsgBox % String_to_Add
;MsgBox % URL_Word[1]
Gui, 5:new
Gui, 5:Font, s30, Segoe UI
Gui, 5:Add, Text,, %Word_to_Query%
Gui, 5:Add, Edit, r1 w400, %String_to_Add% 
Gui, 5:Add, Text,, %Source% 
Gui, 5:Add, Edit, r1 w400, manual
; Gui, 2:Add, Edit, r1 vFirst2 w400, %DefaultSearchValue%
Gui, 5:Add, Button, default, Enter
Gui, 5:Show,, Add Word Complex ;w500 h370, Results
return

5GuiEscape:
	; Gui, 2:-Disabled
	Gui, 5:Destroy
Clipboard_Resurrect()
if (WinExist("STOE Editor v5.0")) {
	WinActivate ; Use the window found by WinExist.
}
	return

5ButtonEnter:
	Gui, 5:Submit  ; Save the input from the user to each control's associated variable.
	ControlGetText, 5GuiText_1, Edit1
	ControlGetText, 5GuiText_2, Edit2
;return
;msgbox % 3GuiText_1
; if (3GuiText_1 = "") {
; 	; msgbox % Number2 " is the value"
; 	msgbox % 3GuiText_1 " is equal to """""
; } else {
; 	msgbox % 3GuiText_1 " is not equal to """""
; }
String_Trim(x)
5GuiText_1 := String_Trim(5GuiText_1)
5GuiText_2 := String_Trim(5GuiText_2)
if (InStr(5GuiText_1, ",")) {
	5GuiText_1 := """" . 5GuiText_1 . """"
}
if (InStr(5GuiText_2, ",")) {
	5GuiText_2 := """" . 5GuiText_2 . """"
}
RowToAdd := Word_to_Query . "," . 5GuiText_1 . "," Source . "," . 5GuiText_2
;msgbox % RowToAdd

if (CSV_MatchRow(Dictionary_to_Use,RowToAdd) = 0) {
	if (Word_to_Query = "") {
		Error_Text := "Query string empty!"
		SetTimer, Error_Message
		return 
	} else {
		CSV_AddRow(Dictionary_to_Use, RowToAdd)
		CSV_Save(Dictionary_Path_Current,Dictionary_to_Use)
		Success_Text := Word_to_Query . "`nadded and saved!"
		SetTimer, Success_Message
		return

	}
} else {
	Warning_Text := "entry already exists"
	SetTimer, Warning_Message
	return 
}

;CSV_AddRow(Dictionary_to_Use, RowToAdd)
;CSV_Save(Dictionary_Path_Current,Dictionary_to_Use) 
if (WinExist("STOE Editor v5.0")) {
	;Clipboard_Resurrect()
	WinActivate ; Use the window found by WinExist.
}
return 
}


;value := CSV_MatchRow(Dictionary_to_Use,RowToAdd)
;MsgBox % value 
;MsgBox % RowToAdd

; if (CSV_MatchRow(Dictionary_to_Use,RowToAdd) = 0) {
; 	if (Word_to_Query = "") {
; 		Error_Text := "Query string empty!"
; 		SetTimer, Error_Message
; 		return 
; 	} else {
; 		CSV_AddRow(Dictionary_to_Use, RowToAdd)
; 		CSV_Save(dictionary_path,Dictionary_to_Use)
; 		Success_Text := Word_to_Query . "`nadded and saved!"
; 		SetTimer, Success_Message
; 		return

; 	}
; } else {
; 	Warning_Text := "entry already exists"
; 	SetTimer, Warning_Message
; 	return 
; }
; }

$#+y::
WinGetTitle, Title, A
;Clipboard := Title
switch {
	case InStr(Title, "STOE Editor v5.0"):
		Add_Word_Complex_STOE()
		;MsgBox "STOE"
		return
	case InStr(Title, "Definition & Meaning - Merriam-Webster"):
		Add_Word_Complex()
		;MsgBox "STOE"
		return
	case InStr(Title, "Definition & Meaning | Merriam-Webster Medical"):
		Add_Word_Complex()
		;MsgBox "STOE"
		return
	case InStr(Title, "Wiktionary, the free dictionary"):
		Add_Word_Complex()
		;MsgBox "STOE"
		return
	case InStr(Title, "Wikipedia"):
		Add_Word_Complex()
		;MsgBox "STOE"
		return
	case InStr(Title, "Definición | Diccionario de la lengua española | RAE - ASALE"):
		Add_Word_Complex_RAE()
		;MsgBox "STOE"
		return
	case InStr(Title, "Wikcionario, el diccionario libre"):
		Add_Word_Complex()
		;MsgBox "STOE"
		return
	case InStr(Title, "Diccionario de americanismos | ASALE"):
		Add_Word_Complex()
		;MsgBox "STOE"
		return
	case InStr(Title, "Notepad++"):
		MsgBox green 
		return 
	default:	
		MsgBox "default, ha ha"
		return 
}
return 

$#j::
;msgbox % Word_to_Query
WinGetTitle, Title, A
Clipboard := Title 
return


#IfWinActive Results ahk_class AutoHotkeyGUI
1::
2::
3::
4::
5::
6::
7::
8::
9::
Gui, 2:Destroy
String_to_send := CSV_ReadCell(Dictionary_to_Use, Results[A_ThisHotkey], 2)

if (String_to_send = Word_to_Query) {
		Success_Text := Word_to_Query . " ✓"
		SetTimer, Success_Message
		return 
	} else {
		;String_to_send := CSV_ReadCell(Dictionary_to_Use, 1, 2)
		;MsgBox % Row_Position
		;MsgBox % String_to_send
		Clipboard := String_to_send ;Corresponding_Value
		Send, {alt down}{backspace down}{backspace up}{alt up}
		Send, {shift down}{ctrl down}{v down}{v up}{ctrl up}{shift up}
		sleep, Sleep_Very_Big
		Clipboard_Resurrect()
		return 
	}


; Clipboard := String_to_send
; Send, {alt down}{backspace down}{backspace up}{alt up}
; ;Send, %String_to_send%
; Send, {shift down}{ctrl down}{v down}{v up}{ctrl up}{shift up}
; sleep, Sleep_Very_Big
; Clipboard_Resurrect()
Return

0::
Gui, 2:Destroy
String_to_send := CSV_ReadCell(Dictionary_to_Use, Results[10], 2)

if (String_to_send = Word_to_Query) {
		Success_Text := Word_to_Query . " ✓"
		SetTimer, Success_Message
		return 
	} else {
		;String_to_send := CSV_ReadCell(Dictionary_to_Use, 1, 2)
		;MsgBox % Row_Position
		;MsgBox % String_to_send
		Clipboard := String_to_send ;Corresponding_Value
		Send, {alt down}{backspace down}{backspace up}{alt up}
		Send, {shift down}{ctrl down}{v down}{v up}{ctrl up}{shift up}
		sleep, Sleep_Very_Big
		Clipboard_Resurrect()
		return 
	}

; Clipboard := String_to_send
; Send, {alt down}{backspace down}{backspace up}{alt up}
; ;Send, %String_to_send%
; Send, {shift down}{ctrl down}{v down}{v up}{ctrl up}{shift up}
; sleep, Sleep_Very_Big
; Clipboard_Resurrect()
Return

#IfWinActive




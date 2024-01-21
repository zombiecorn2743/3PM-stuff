#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetDefaultMouseSpeed, 0
SetKeyDelay, 0
#InstallKeybdHook
CoordMode, ToolTip, Screen
#SingleInstance, force

; to do list
; free edit (edit contents of cell) 
;; fix delete for when I'm not in STOE 

; Variables
global App_Name := "STOE Editor v5.0"
global Success_Text
global Error_Text
global Warning_Text
global Old_Clipboard
global Trimmed_String
global Output 
global CLIPWAIT_VAR := 2
global Tool_Tip_Duration := 1500
global Success_Tool_Tip_Duration := 1500
global Warning_Tool_Tip_Duration := 1000
global AHK_JS_Bridge_Delay := 50
global Sleep_Small := 20
global Sleep_Medium := 40
global Sleep_Big := 75
global Sleep_Very_Big := 100
global Success_Style := "Style11"
global Warning_Style := "Style12"
global Error_Style := "Style13"
global Message_X := "150"
global Message_Y := "1800"
global Mono_Font := "Consolas"
global UI_Font := "Segoe UI"
global Serif_Font := "Georgia"
global Language := "English"

; stuff I need to delete later 
!Escape::ExitApp
#!3::Reload
#^3::Suspend


;lwin::lwin
;rwin::rwin
$!pgdn::
;sleep, 100
send, {pgup}
;msgbox nice
return 
;pgup

$!^pgdn::
;sleep, 100
Send, {ctrl down}{pgup down}{pgup up}{ctrl up}
;msgbox nice
return

$+!^pgdn::
;sleep, 100
Send, {Shift down}{ctrl down}{pgup down}{pgup up}{ctrl up}{Shift up}
;msgbox nice
return

; very important functions

;switch language to Castilian
Language_Change_Castilian() {
	if (Language = "Castilian") {
		msgbox Language is already Castilian!
	} else {
		Language := "Castilian"
	}
}

;#c::Language_Change_Castilian()

;switch language to English 
Language_Change_English() {
	if (Language = "English") {
		msgbox Language is already English!
	} else {
		Language := "English"
	}
}

;#i::Language_Change_English()

Language_Show() {
	msgbox % Language
}

; ;important pixels
; ;flag color 1::
;     PixelGetcolor, Pix, 1141, 35
;     IfEqual, Pix, 0x000000, click, 1141, 35
; return
; ;scroll bar slider 1::
;     PixelGetcolor, Pix, 1247, 2144
;     IfEqual, Pix, 0x937A2E (4796b3), click, 1247, 2144
; return
; ;scroll bar arrow panel two 1::
;     PixelGetcolor, Pix, 1894, 2119
;     IfEqual, Pix, 0x000000, click, 1894, 2119
; return

;Click_in_STOE()
Enter_Fullscreen() {
;msgbox hi
	;Sleep, 200
	Click_in_STOE()
	;Sleep, 50
	Send, {Shift down}{Alt down}{f down}{f up}{Alt up}{Shift up}
	;Send, {ctrl down}{space down}space up}{ctrl up}
;Send, !+f
}

Exit_Fullscreen() {
	;Sleep, 50
	Send, {Shift down}{Alt down}{f down}{f up}{Alt up}{Shift up}
	Sleep, 50
	Click_in_STOE()
;Msgbox "exit" 
}

; PixelGetColor, Flag, 1141, 35 ;0xDAE5EC
; Msgbox % "flag is " Flag
; Clipboard := Flag 
; PixelGetColor, Slider, 1247, 2144 ;0xB39647
; Msgbox % "Slider is " Slider
; Clipboard := Slider
; PixelGetColor, Arrow, 1894, 2119 ;0x211C0D
; Msgbox % "Arrow is " Arrow
; Clipboard := Arrow
;PixelGetColor, Flag, 1141, 35
; if (Flag = 0xDAE5EC) {
; 	Msgbox "yes, 0xDAE5EC is flag"
; 	MouseMove, 1141, 35
; } else {
; 		Msgbox "fail"
; }
;PixelGetColor, Slider, 1247, 2144
; if (Slider = 0xB39647) {
; 	Msgbox "yes, 0xB39647 is slider"
; 	MouseMove, 1247, 2144
; } else {
; 		Msgbox "fail"
; }
;PixelGetColor, Arrow, 1894, 2119
; if (Arrow = 0x211C0D) {
; 	Msgbox "yes, 0x211C0D is arrow"
; 	MouseMove, 1894, 2119
; } else {
; 		Msgbox "fail"
; }
$#f::
;line 1 X: 651 Y:1968 Color: 0x090701
;flag 1 X: 1456 Y:46 Color: 0xFFFFFF
;PixelGetColor, Flag, 1141, 35
;play button 1 X: 42 Y:328 Color: 0xFFFFFF
;tabs 2 X: 512 Y:394 Color: 0x090701
;star: 1 X: 843 Y:57 Color: 0xFFFFFF

;PixelGetColor, Flag, 1456, 46
PixelGetColor, Star, 843, 57
;PixelGetColor, Play, 42, 328
;PixelGetColor, Tabs, 512, 394
;PixelGetColor, Line, 651, 1968
;PixelGetColor, Slider, 1247, 2144
;PixelGetColor, Arrow, 1894, 2119
if (WinActive(App_Name)) {
	if (Star = 0xFFFFFF) { ;&& Play = 0xFFFFFF && Tabs = 0x090701) { ;Line = 0x090701) { ;Slider = 0xB39647 && Arrow = 0x211C0D) {
		;Msgbox "hurray!"
		Enter_Fullscreen()
	} else {
		;Msgbox "fail"
		Exit_Fullscreen()
	}
} else {
	Send, {LWin down}{f down}{f up}{LWin up}
}
return

; !f::
; PixelGetColor, Flag, 1456, 46
; PixelGetColor, Play, 42, 328
; PixelGetColor, Tabs, 512, 394
; if (WinActive(App_Name)) {
; 	if (Flag = 0xFFFFFF && Play = 0xFFFFFF && Tabs = 0x090701) { ;Line = 0x090701) { ;Slider = 0xB39647 && Arrow = 0x211C0D) {
; 		;Msgbox "hurray!"
; 		Enter_Fullscreen()
; 	} else {
; 		;Msgbox "fail"
; 		Exit_Fullscreen()
; 	}
; } else {
; 	Send, {LWin down}{f down}{f up}{LWin up}
; }
; return

Click_in_STOE() {
	;MouseClick, Left, 1880, 2119, 1, 0
	MouseClick, Left, 1880, 2098, 1, 0
}

$#c::
; if (WinActive(App_Name)) {
 	Click_in_STOE()
; } else {
	;Send, {LWin down}{c down}{c up}{LWin up}
;}
;MouseClick, Left, 1880, 2119, 1, 0
return

$#space::
if (WinActive(App_Name)) {
;Msgbox "SCA+space"
;Sleep, 300
	;Click_in_STOE()
;Success_Text := "Match playback" 
;SetTimer, Success_Message
;Send, {Shift down}{Ctrl down}{Alt down}{p down}{p up}{Alt up}{Ctrl up}{Shift up}
	Send, {Shift down}{space down}{space up}{space down}{space up}{Shift up}
} else {
Msgbox "no win space" 
	;Send, {LWin down}{space down}{space up}{LWin up}
}
;MouseClick, Left, 1880, 2119, 1, 0
return

$!space::
if (WinActive(App_Name)) {
;Msgbox "SCA+space"
	;Click_in_STOE()
;Success_Text := "Match playback" 
;SetTimer, Success_Message
;Sleep, 300
;Send, {Shift down}{Ctrl down}{Alt down}{p down}{p up}{Alt up}{Ctrl up}{Shift up}
Send, {Shift down}{Ctrl down}{space down}{space up}{Ctrl up}{Shift up}
;Send, {Shift down}{Ctrl down}{space down}{space up}{Ctrl up}{Shift up}
} else {
;Msgbox "no win space" 
	Send, {Alt down}{space down}{space up}{Alt up}
}
;MouseClick, Left, 1880, 2119, 1, 0
return

Scroll_Up() {
	; MouseClick, Left, 1893, 63, 1, 0
	; 1 X: 1891 Y:228 Color: 0x242012
	; ; 1 X: 1891 Y:153 Color: 0x242012
	MouseClick, Left, 1893, 153, 1, 0
	; MouseClick, Left, 1893, 228, 1, 0
	; MouseClick, Left, 1893, 102, 1, 0
	;1 X: 1897 Y:102 Color: 0x929089
}

Scroll_Down() {
	;MouseClick, Left, 1893, 2117, 1, 0
	MouseClick, Left, 1893, 2117, 1, 0
	;MouseClick, Left, 1893, 2098, 1, 0
	;1 X: 1898 Y:2115 Color: 0x211C0D
	;2 X: 1893 Y:2098 Color: 0x000000
	;new scroll bar at bottom
	;1 X: 1282 Y:2116 Color: 0x937A2E
	;2 X: 1878 Y:2116 Color: 0x242012


}

$!p::
if (WinActive(App_Name)) {
	Scroll_Up()
} else {
	Send, {Alt down}{p down}{p up}{Alt up}
}
return 

$!n::
if (WinActive(App_Name)) {
	Scroll_Down()
} else {
	Send, {Alt down}{n down}{n up}{Alt up}
}
return

;!l::Language_Show()

; symbols and letters to be transformed in Paste_3Play
Output_Caret() {
Output .= "{^ down}{^ up}"
return Output
}
Output_Exclam() {
Output .= "{! down}{! up}"
return Output
}

Output_Plus() {
Output .= "{+ down}{+ up}"
return Output
}

Output_Pound() {
Output .= "{# down}{# up}"
return Output
}

Output_Open_Curly() {
Output .= "{{ down}{{ up}"
return Output
}

Output_Close_Curly() {
Output .= "{} down}{} up}"
return Output
}

Output_Comma() {
Output .= "{, down}{, up}"
return Output
}

Output_Percent() {
Output .= "{% down}{% up}"
return Output
}

Output_Semicolon() {
Output .= "{; down}{; up}"
return Output
}

Output_Double_Quote() {
Output .= "{shift down}{' down}{' up}{shift up}" ;""""
return Output
}

Output_á() {
Output .= "{Alt Down}{a down}{a up}{Alt Up}"
return Output
}

Output_é() {
Output .= "{Alt Down}{e down}{e up}{Alt Up}"
return Output
}

Output_í() {
Output .= "{Alt Down}{i down}{i up}{Alt Up}"
return Output
}

Output_ó() {
Output .= "{Alt Down}{o down}{o up}{Alt Up}"
return Output
}

Output_ú() {
Output .= "{Alt Down}{u down}{u up}{Alt Up}"
return Output
}

Paste_3Play(x) {
	String_Trim(x)
	Output := ""
	Loop, Parse, Trimmed_String
	{
		switch A_LoopField {
			case "^": Output_Caret()
			case "!": Output_Exclam()
			case "+": Output_Plus()
			case "#": Output_Pound()
			case "{": Output_Open_Curly()
			case "}": Output_Close_Curly()
			case ",": Output_Comma()
			case "%": Output_Percent()
			case ";": Output_Semicolon()
			case """": Output_Double_Quote()
			case "á": Output_á()
			case "é": Output_é()
			case "í": Output_í()
			case "ó": Output_ó()
			case "ú": Output_ú()
			default: Output .= A_LoopField
		}
	}
	Send, %Output%
}

Clipwait_Function() {
	Clipboard := "" ; Empty the clipboard
;Sleep, 200
	Send, {Ctrl down}{c down}{c up}{Ctrl up}
	ClipWait, 2 ;CLIPWAIT_VAR
	if ErrorLevel {
		Error_Text := "copy failed ☓"
		SetTimer, Error_Message
		return 
	}
	;Clipboard := String_Trim(Clipboard)
}

; #c::
; Clipwait_Function()
; return

Clipboard_Trim() {
	Clipboard := RegexReplace(Clipboard, "^\s+|\s+$")
}

String_Trim(x) {
	;Trimmed_String := RegexReplace(x, "^\s+|\s+$")
	return RegexReplace(x, "^\s+|\s+$")
}

Clipboard_Save() {
	Old_Clipboard := Clipboard
}

Clipboard_Resurrect() {
	Clipboard := Old_Clipboard
}

#r::
Clipboard_Resurrect()
return 

Cell_Clear() {
	Send, {Control down}{x down}{x up}{Control up}
}

; Timers and stuff
Success_Message:
btt(Success_Text,Message_X,Message_Y,,Success_Style)
Sleep, Success_Tool_Tip_Duration 
btt()
SetTimer, Success_Message, Off
Return

Warning_Message:
btt(Warning_Text,Message_X,Message_Y,,Warning_Style)
Sleep, Warning_Tool_Tip_Duration 
btt()
SetTimer, Warning_Message, Off
Return

Error_Message:
btt(Error_Text,Message_X,Message_Y,,Error_Style)
Sleep, Tool_Tip_Duration 
btt()
SetTimer, Error_Message, Off
Return

; Basic Functions

; alt+space hits shift+space twice 
; the following does not work unless you're in full
; screen (it's something to do with the alt key}
; if you're not in full screen and you use this,
; press alt again to deselect the menu bar 
; $!Space::
; if (WinActive(App_Name)) {
; 	Send, {shift down}{Space down}{Space up}{Space down}{Space up}{shift up}
; }
; else {
; 	Send, {alt down}{Space down}{Space up}{alt up}
; }
; return 

; shift+alt+space hits shift+space thrice  
$+!Space::
if (WinActive(App_Name)) {
	Send, {shift down}{Space down}{Space up}{Space down}{Space up}{Space down}{Space up}{shift up}
}
else {
	Send, {shift down}{alt down}{Space down}{Space up}{alt up}{shift up}
}
return

; nasty little hack to go fullscreen
; $!f::
; if WinActive(App_Name) {
; 	Send, {shift down}{alt down}{f down}{f up}{alt up}{shift up}
; Clipboard_Save()
; Sleep, Sleep_Big
; Send, {control down}{x down}{x up}{control up}
; Sleep, Sleep_Big
; Send, {control down}{v down}{v up}{control up}
; Sleep, Sleep_Big
; Send, {shift down}{tab down}{tab up}{shift up}
; ;Sleep, Sleep_Big
; ;Send, {rwin down}{g down}{g up}{rwin up}
; ;Send, {\ down}{\ up}
; ;Send, +{tab}
; ;{rshift down}{tab}{rshift up}
; Clipboard_Resurrect()
;  } else {
;  	Send, {alt down}{f down}{f up}{alt up}
; }
; return

; $+!f::
; if WinActive(App_Name) {
; 	Send, {shift down}{alt down}{f down}{f up}{alt up}{shift up}
; Clipboard_Save()
; Sleep, Sleep_Big
; Send, {control down}{x down}{x up}{control up}
; Sleep, Sleep_Big
; Send, {control down}{v down}{v up}{control up}
; Sleep, Sleep_Big
; Send, {shift down}{tab down}{tab up}{shift up}
; ;Sleep, Sleep_Big
; ;Send, {rwin down}{g down}{g up}{rwin up}
; ;Send, {\ down}{\ up}
; ;Send, +{tab}
; ;{rshift down}{tab}{rshift up}
; Clipboard_Resurrect()
;  } else {
;  	Send, {shift down}{alt down}{f down}{f up}{alt up}{shift up}
; }
; return

; add a clipwait 
#e::
if WinActive(App_Name) {
	Clipboard_Save()
	Clipwait_Function()
	Gui, 1:new
	Gui, 1:Font, s30, %Mono_Font% ; Consolas ; Segoe UI
	Gui, 1:Add, Text,, string to edit:
	Gui, 1:Add, Edit, r1 vEdit1 w400, %Clipboard%
	Gui, 1:Add, Button, default, Enter  ; The label ButtonOK (if it exists) will be run when the button is pressed.
	Gui, 1:Show, w500 h370, Free Edit
	ControlSend, Edit1,{Home}, Free Edit
	return  ; End of auto-execute section. The script is idle until the user does something.


GuiEscape:
	Gui, 1:Destroy
	if (WinExist(App_Name)) {
		WinActivate ; Use the window found by WinExist.
	}
	Clipboard_Resurrect()
	return

ButtonEnter:
	Gui, 1:Submit  ; Save the input from the user to each control's associated variable.
	if (WinExist(App_Name)) {
		WinActivate ; Use the window found by WinExist.
		Cell_Clear()
		Paste_3Play(Edit1)
		Clipboard_Resurrect()
}
return
}
else {
	Send, {LWin down}{e down}{e up}{LWin up}
}
Return

; JS functions

Warning() {
	; Warning_Text := Clipboard . "  ⚠"
	SetTimer, Warning_Message
	; MsgBox Warning!
;	return 
}

; $del::
; if (WinActive(App_Name)) {
; 	Clipboard_Save()
; 	Clipboard := ""
; 	Send, {del down}{del up}
; ;	Loop, 100 {
; 		Sleep, AHK_JS_Bridge_Delay
; 		if (SubStr(Clipboard, 1, 6) = "NULL!!") {
; 			Send, {shift down}{right down}{right up}{shift up}
; 			Warning_Text := "null at " . (SubStr(Clipboard, -5))
; 			Warning()
; 			;break
; 		}
; ;		}
; Clipboard_Resurrect()
; } else {
; 	Send, {del down}{del up}
; }
; return
; 
;shift+control+0 sends alt+0 when in STOE
$+^0::
if WinActive(App_Name) {
	Send, {alt down}{0 down}{0 up}{alt up} ;
} else {
	 Send, {control down}{shift down}{0 down}{0 up}{shift up}{control up}
}
return






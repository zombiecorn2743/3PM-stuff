#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
StringCaseSense, On
;; SetScrollLockState, AlwaysOff

MButton::		;gesture hotkey, i imagine most would use a mousekey for gestures,ctrl is simply an example suitable for testing as i've got radial menu running...
;KeyWait, %A_ThisHotkey%, T0.0	;to identify if hotkey was pressed or held...
;If ErrorLevel {
	;hotkey is being held down so treat it as a gesture...
	GetMouseGesture(True)
	While GetKeyState(LTrim(A_ThisHotkey,"~"), "P"){
		MG := GetMouseGesture()
        UMG := StrReplace(MG, "U", " + Up")
        NMG := StrReplace(UMG, "N", " + North")
        RMG := StrReplace(NMG, "R", " + Right")
        EMG := StrReplace(RMG, "E", " + East")
        DMG := StrReplace(EMG, "D", " + Down")
        SMG := StrReplace(DMG, "S", " + South")
        LMG := StrReplace(SMG, "L", " + Left")
        WMG := StrReplace(LMG, "W", " + West")
        ;FMG := SubStr(WMG, 1, -2)
        ;FMG := SubStr(WMG, 1, -1)
        FMG := SubStr(WMG, 4)
        GN := GetGestureName(FMG)
        ,GestureText := FMG . GN
		btt(GestureText,,,1, "Style12")
		;Sleep 150
	}
	MQ := SubStr(MouseQuintant(20,80,20,80),1,1)	;take only the first letter of the Quintant,for simplified function names...
	IsFunc(MG "_" MQ) ? %MG%_%MQ%() : (IsFunc(MG) ? %MG%() : "")	;example allows creation of gestures by defining functions that comprise U,D,R,L as function name,with no upper limit on the extent of the gesture,i.e UDUDUDUDL for ex.
	;If (MG == "")
    ;Send, {RButton}
    If (MG == "") {
        If A_TimeSinceThisHotkey > 500
            SendVK()
        else
            Send, {%A_ThisHotkey%}
    }
    ;RightClickF24(MG)
    btt(,,,1)
	GetMouseGesture(True)
    Return
  ;Else
	;Send  {%A_ThisHotkey%}	;if ordinary press, just let the press,passthrough...
;Return

R() {
    Send, {Media_Next} ;^!+{Right}
	;btt("ESCRITORIO SIGUIENTE",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "PISTA SIGUIENTE" ;"ESCRITORIO SIGUIENTE"
    global FunctionNumber := 3
    SetTimer, Mensaje
    Return
}

L() {
    Send, {Media_Prev} ;^!+{Left}
	;btt("ESCRITORIO ANTERIOR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "PISTA ANTERIOR" ;"ESCRITORIO ANTERIOR"
    global FunctionNumber := 7
    SetTimer, Mensaje
    Return
}

U() {
    Send, ^!+m
	;btt("ESCRITORIO ARRIBA",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "MENÚ DE ESCRITORIOS"
    global FunctionNumber := 1
    SetTimer, Mensaje
    Return
}

D() {
    Send, {Media_Play_Pause} ;^!+{Down}
	;btt("ESCRITORIO ABAJO",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "REPRODUCIR/PAUSAR" ;"ESCRITORIO ABAJO"
    global FunctionNumber := 5
    SetTimer, Mensaje
    Return
}

UD() {
    Send, ^!+w
    global FunctionName := "MENÚ DE ESCRITORIOSCOPIAR"
    ;btt("COPIAR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    ;CopyMessage()
    global FunctionNumber := 15
    SetTimer, Mensaje
    Return
}

UL() {
    Send, #d
    global FunctionName := "MINIMIZAR"
	;btt("PEGAR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionNumber := 17
    SetTimer, Mensaje
    Return
}
  

UR() {
    Send, {f11}
    ;btt("INTRODUCIR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "PANTALLA COMPLETA"
    global FunctionNumber := 13
    SetTimer, Mensaje
    Return
}

DR() {
    Send, #= ;!{Tab}
    ;btt("INTRODUCIR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "MAGNIFICAR"
    global FunctionNumber := 20
    SetTimer, Mensaje
    Return
}

DL() {
    Send, #{Esc} ;^z
    ;btt("INTRODUCIR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "ALEJAR"
    global FunctionNumber := 25
    SetTimer, Mensaje
    Return
}

RD() {
    Send, ^{Tab}
    ;btt("INTRODUCIR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "CAMBIAR PESTAÑA"
    global FunctionNumber := 30
    SetTimer, Mensaje
    Return
}

DU() {
    Send, {Esc} ;{Backspace}
    ;btt("INTRODUCIR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "CANCELAR" ;"SUPRIMIR"
    global FunctionNumber := 35
    SetTimer, Mensaje
    Return
}

LU() {
    Send, {Home}
    ;btt("INTRODUCIR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "HOGAR"
    global FunctionNumber := 40
    SetTimer, Mensaje
    Return
}

LD() {
    Send, {End}
    ;btt("INTRODUCIR",,,, "Style1")
    ;Sleep, 800
	;btt()​
    global FunctionName := "FIN"
    global FunctionNumber := 45
    SetTimer, Mensaje
    Return
}

;L(){
;	MsgBox % "Function Run,if no function was defined for specific Quintant. Or Quintant Has No Assigned Function.`n`n CurrentQuintant:`n`t" MouseQuintant(20,80,20,80)
;}
;
;L_T(){	;function defined gesture example for example below
;	MsgBox Gesture On Top
;}
;
;L_L(){	;function defined gesture example for example below
;	MsgBox Gesture To The LEFT
;}
;
;L_R(){	;function defined gesture example for example below
;	MsgBox Gesture To The Right
;}
;
;UU_T() {
;    MsgBox double up top!
;}
;
;UU() {
;    MsgBox double up somewhere else
;}
;
;DD() {
;    if GetKeyState("LButton","p") {
;		while (GetKeyState("LButton", "P"))
;			MsgBox down down with left click held down!
;	}
;	else
;			MsgBox regular down down!
;}

;returns if screen is on top,bottom,center,left,right area of screen given the defined scope in percent of each area...see example.
/*
					Top
	___________________________________
	L	|						|	R
	E	|						|	y
	F	|		C E N T E R		|	T
	T	|						|
	____|_______________________|______
					Bottom
*/
;defined scopes are in 'percent',i.e left scope means anything below defined % is designated left,right scope is anything above defined %...
MouseQuintant(leftScope,rightScope,topScope,bottomScope,coordMode:="screen"){	;coordMode should either be 'window' or 'screen'
	CoordMode, Mouse, % coordMode
	MouseGetPos, mX, mY, mHwnd, mCtrl
	WinGetPos, wX, wY, wW, hH, A
	
	If (mX <= leftScope/100*(coordMode = "screen" ? A_ScreenWidth : wW) && mY >= topScope/100*(coordMode = "screen" ? A_ScreenHeight : hH) && mY <= bottomScope/100*(coordMode = "screen" ? A_ScreenHeight : hH))
		Return "LEFT"
	Else If (mX >= rightScope/100*(coordMode = "screen" ? A_ScreenWidth : wW) && mY >= topScope/100*(coordMode = "screen" ? A_ScreenHeight : hH) && mY <= bottomScope/100*(coordMode = "screen" ? A_ScreenHeight : hH))
		Return "RIGHT"
	Else If (mY <= topScope/100*(coordMode = "screen" ? A_ScreenHeight : hH))
		Return "TOP"
	Else If (mY >= bottomScope/100*(coordMode = "screen" ? A_ScreenHeight : hH))
		Return "BOTTOM"
	Else
		Return "CENTER"
}

GetMouseGesture(reset := false){
	Static
	mousegetpos,xpos2, ypos2
	dx:=xpos2-xpos1,dy:=ypos1-ypos2
	,( abs(dy) >= abs(dx) ? (dy > 0 ? (track:="U") : (track:="D")) : (dx > 0 ? (track:="R") : (track:="L")) )	;track is up or down, left or right
	;,dx>0 ? (dy > 0 ? (track:="N") : (track:="E")) : (dy > 0? (track:="W") : (track:="S")) ; track is N,E,W,S - compass, tilted right
	;,abs(dy) >= 2.4142*abs(dx) ? (dy > 0 ? (track:="U") : (track:="D")) : "" ;track is up or down
	;,abs(dx) >= 2.4142*abs(dy) ? (dx > 0 ? (track:="R") : (track:="L")) : "" ;track is left or right
    ,abs(dy)<15 and abs(dx)<15 ? (track := "") : ""	;not tracking at all if no significant change in x or y
	,xpos1:=xpos2,ypos1:=ypos2
	,track<>SubStr(gesture, 0, 1) ? (gesture := gesture . track) : ""	;ignore track if not changing since previous track
	;,gesture := gesture . track
    ,gesture := reset ? "" : gesture
	Return gesture
}

CopyMessage(){
    btt("COPIAR", 500, 350,, "Style1")
    Sleep, 1000
    btt()
}

Mensaje:
btt(FunctionName,,,, "Style12")
Sleep, 500
btt()
SetTimer, Mensaje, Off
FunctionName := ""
Return

;GetGestureName() {
;    if (MG = "UD") {
;        GestureName := "COPIAR"
;    }
;    Return GestureName
;}

;GetGestureName() {
;    if (MG = "UD") {
;        btt("COPIAR", 500, 350,, "Style1")
;        Sleep, 1000
;        btt()
;    }
;    Return
;}

        ;FMG := SubStr(WMG, 4)
        ;;GN := GetGestureName()
        ;if (FMG == "Up + Down") {
        ;    GN := " COPIAR"
        ;    ,GestureText := FMG . GN
        ;} 
        ;else {
        ;    GN := " NADA"
        ;    ,GestureText := FMG . GN
        ;}
		;btt(GestureText,,,1, "Style1")

;Mother’s Day 2021 (May 9th, 2021)
GetGestureName(x) {
    if (x == "Up + Down") {
        ;GN := " COPIAR"
        GestureName := "`nMOVER A ESCRITORIO"
        ;,GestureName := FMG . GN
    }
    else if (x == "Up + Left") {
        GestureName :=  "`nMINIMIZAR"
    }
    else if (x == "Up + Right") {
        GestureName := "`nPANTALLA COMPLETA"
    }
    else if (x == "Down + Right") {
        GestureName := "`nMAGNIFICAR"
    }
    else if (x == "Down + Left") {
        GestureName := "`nALEJAR"
    }
    else if (x == "Right + Down") {
        GestureName := "`nCAMBIAR PESTAÑA"
    }
    else if (x == "Left + Up") {
        GestureName := "`nHOGAR"
    }
    else if (x == "Left + Down") {
        GestureName := "`nFIN"
    }
    else if (x == "Down + Up") {
        GestureName := "`nCANCELAR"
    }
    else if (x == "Up") {
        GestureName := "`nMENÚ DE ESCRITORIOS"
    }
    else if (x == "Right") {
        GestureName := "`nPISTA SIGUIENTE"
    }
    else if (x == "Down") {
        GestureName := "`nREPRODUCIR/PAUSA"
    }
    else if (x == "Left") {
        GestureName := "`nPISTA ANTERIOR"
    }
    else if (x == ""){
        GestureName := "`nMiddle-click down"
    }
    else {
        ;GN := " NADA"
        GestureName := "`nNADA"
        ;,GestureName := FMG . GN
    }
Return GestureName
}


;If (MG == "") {
;    If (A_KeyDuration > 1000)
;        Send, {F24}
;    else
;        Send, {RButton}
;}
;RightClickF24(x) {
;    If (x == "") {
;        If A_TimeSinceThisHotkey > 1000 {
;            SendLevel 1
;            Send, {F24}
;        }
;        else
;            Send, {%A_ThisHotkey%}
;    }
;}

SendVK() {
    #InputLevel 1
    ;SendLevel 1
    Send, {vk0x1A}
}

;RMShowHotkeyOn:
;PostMessage("Radial menu - message receiver", 51)
;return


;===Functions===========================================================================
PostMessage(Receiver,Message) {
	oldTMM := A_TitleMatchMode, oldDHW := A_DetectHiddenWindows
	SetTitleMatchMode, 3
	DetectHiddenWindows, on
	PostMessage, 0x1001,%Message%,,,%Receiver% ahk_class AutoHotkeyGUI
	SetTitleMatchMode, %oldTMM%
	DetectHiddenWindows, %oldDHW%
}
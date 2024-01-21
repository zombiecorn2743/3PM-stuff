#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, ToolTip, Screen

LShift::
;Sleep, 100
while GetKeyState("LShift", "P")
{
	btt("Left Shift Down", 100, 1000,1, "Style1")
	send, {LShift Down}
}
send, {LShift Up}
btt(,,,1)
return

RShift::
;Sleep, 100
while GetKeyState("RShift", "P")
{
	btt("Right Shift Down", 250, 1000,2, "Style1")
	send, {RShift Down}
}
send, {RShift Up}
btt(,,,2)
return

LControl::
;Sleep, 100
while GetKeyState("LControl", "P")
{
	btt("Left Control Down", 100, 900,3, "Style1")
	send, {LControl Down}
}
send, {LControl Up}
btt(,,,3)
return

RControl::
;Sleep, 100
while GetKeyState("RControl", "P")
{
	btt("Right Control Down", 250, 900,4, "Style1")
	send, {RControl Down}
}
send, {RControl Up}
btt(,,,4)
return

LAlt::
;Sleep, 100
while GetKeyState("LAlt", "P")
{
	btt("Left Alt Down", 100, 800,5, "Style1")
	send, {LAlt Down}
}
send, {LAlt Up}
btt(,,,5)
return

RAlt::
;Sleep, 100
while GetKeyState("RAlt", "P")
{
	btt("Right Alt Down", 250, 800,6, "Style1")
	send, {RAlt Down}
}
send, {RAlt Up}
btt(,,,6)
return

LWin::
;Sleep, 100
while GetKeyState("LWin", "P")
{
	btt("Left Win Down", 100, 700,7, "Style1")
	send, {LWin Down}
}
send, {LWin Up}
btt(,,,7)
return

RWin::
;Sleep, 100
while GetKeyState("RWin", "P")
{
	btt("Right Win Down", 250, 700,8, "Style1")
	send, {RWin Down}
}
send, {RWin Up}
btt(,,,8)
return
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetDefaultMouseSpeed, 0
SetKeyDelay, 0
#InstallKeybdHook

;#Include 3play 2023 FF New.ahk

global Market_Name := "Market"

#m::
Suspend, off
SoundPlay on.mp3
return

!m::
Suspend, on
SoundPlay off.mp3
return

;^v::
;Send, %Clipboard%
;Return

; $t::
; WinGetTitle, Title, A
; if (WinActive(Market_Name)) {
; msgbox % "good" Title
; } else {
; msgbox % "bad" Title
; }
; return

$r::
if (WinActive(Market_Name)) {
	MouseClick, left, 1865, 165
}
else {
	Send, r
}
Return

$x::
if (WinActive(Market_Name)) {
	;MouseClick, left, 1485, 888
	MouseClick, left, 1509, 1001
	;C:\Users\Alejandro\Desktop\Market.ahk1 X: 1509 Y:1001 Color: 0x010000

}
else {
	Send, x
}
Return

$n::
if (WinActive(Market_Name)) {
	;MouseClick, left, 1485, 888
	MouseClick, left, 1509, 1001
}
else {
	Send, n
}
Return

$y::
if (WinActive(Market_Name)) {
	;MouseClick, left, 1640, 888
	MouseClick, left, 1654, 991
;2 X: 1654 Y:991 Color: 0x3A9B00
}
else {
	Send, y
}
Return

$z::
if (WinActive(Market_Name)) {
	MouseClick, left, 1239, 48 
}
else {
	Send, z
}
Return

$p::
if (WinActive(Market_Name)) {
	MouseClick, left, 664, 381
}
else {
	Send, p
}
Return

/*
$Enter::
if (WinActive(Market_Name)) {
	MouseClick, left, 1676, 672
}
else {
	Send, {Enter}
}
Return
*/
$1::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 316 
}
else {
	Send, 1
}
Return

$a::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 316
}
else {
	Send, a
}
Return

$2::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 391
}
else {
	Send, 2
}
Return

$b::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 391
}
else {
	Send, b
}
Return

$3::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 463 
}
else {
	Send, 3
}
Return

$c::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 463
}
else {
	Send, c
}
Return

$4::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 537 
}
else {
	Send, 4
}
Return

$d::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 537
}
else {
	Send, d
}
Return

$5::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 610 
}
else {
	Send, 5
}
Return

$e::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 610 ; (+ 537 73)610
}
else {
	Send, e
}
Return

$6::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 683
}
else {
	Send, 6
}
Return

$f::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 683 ; (+ 683 73)756
}
else {
	Send, f
}
Return

$7::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 756 
}
else {
	Send, 7
}
Return

$g::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 756 ; (+ 683 73)756
}
else {
	Send, g
}
Return

$8::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 829
}
else {
	Send, 8
}
Return

$h::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 829 ; (+ 756 73)829
}
else {
	Send, h
}
Return

$9::
if (WinActive(Market_Name)) {
	MouseClick, left, 1605, 902
}
else {
	Send, 9
}
Return

$i::
if (WinActive(Market_Name)) {
	MouseClick, left, 1778, 902 ; (+ 829 73)902
}
else {
	Send, i
}
Return

$0::
if (WinActive(Market_Name)) {
	MouseClick, left, 1239, 48
    ;MouseClick, left, 1371, 84
}
else {
	Send, 0
}
Return
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global X_Coord 
global Y_Coord 
global Pixel_Color

Escape::ExitApp

1::
2::
3::
4::
5::
6::
7::
8::
9::
;MouseGetPos , OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, Flag
;PixelGetColor, OutputVar, X, Y , Mode
MouseGetPos, X_Coord, Y_Coord
PixelGetColor, Pixel_Color, X_Coord, Y_Coord
Clipboard := Clipboard . A_ThisHotkey . " X: " . X_Coord . " Y:" . Y_Coord . " Color: " . Pixel_Color . "`n"
return 

0::
MouseGetPos, X_Coord, Y_Coord
PixelGetColor, Pixel_Color, X_Coord, Y_Coord
Clipboard := Clipboard . "10" . " X: " . X_Coord . " Y:" . Y_Coord . " Color: " . Pixel_Color . "`n"
return 







#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

GuiAddBorder(Color, Width, PosAndSize) {
   ; -------------------------------------------------------------------------------------------------------------------------------
   ; Color        -  border color as used with the 'Gui, Color, ...' command, must be a "string"
   ; Width        -  the width of the border in pixels
   ; PosAndSize   -  a string defining the position and size like Gui commands, e.g. "xm ym w400 h200".
   ;                 You should not pass other control options!
   ; -------------------------------------------------------------------------------------------------------------------------------
   LFW := WinExist() ; save the last-found window, if any
   DefGui := A_DefaultGui ; save the current default GUI
   Gui, Add, Text, %PosAndSize% +hwndHTXT
   GuiControlGet, T, Pos, %HTXT%
   Gui, New, +Parent%HTXT% +LastFound -Caption ; create a unique child Gui for the text control
   Gui, Color, %Color%
   X1 := Width, X2 := TW - Width, Y1 := Width, Y2 := TH - Width
   WinSet, Region, 0-0 %TW%-0 %TW%-%TH% 0-%TH% 0-0   %X1%-%Y1% %X2%-%Y1% %X2%-%Y2% %X1%-%Y2% %X1%-%Y1%
   Gui, Show, x0 y0 w%TW% h%TH%
   Gui, %DefGui%:Default ; restore the default Gui
   If (LFW) ; restore the last-found window, if any
      WinExist(LFW)
}
DrawRect(windowName)
{

; Get the current window's position 
WinGetPos, x, y, w, h, test
; To avoid the error message
if (x="")
    return

;Gui, +Lastfound +AlwaysOnTop +Toolwindow
Gui, +Lastfound +AlwaysOnTop 

; set the background for the GUI window 
Gui, Color, %border_color%

; remove thick window border of the GUI window
Gui, -Caption

; Retrieves the minimized/maximized state for a window.
WinGet, notMedium , MinMax, A

if (notMedium==0){
; 0: The window is neither minimized nor maximized.

	offset:=0
	outerX:=offset
	outerY:=offset
	outerX2:=w-offset
	outerY2:=h-offset

	innerX:=border_thickness+offset
	innerY:=border_thickness+offset
	innerX2:=w-border_thickness-offset
	innerY2:=h-border_thickness-offset

	newX:=x
	newY:=y
	newW:=w
	newH:=h

	WinSet, Region, %outerX%-%outerY% %outerX2%-%outerY% %outerX2%-%outerY2% %outerX%-%outerY2% %outerX%-%outerY%    %innerX%-%innerY% %innerX2%-%innerY% %innerX2%-%innerY2% %innerX%-%innerY2% %innerX%-%innerY% 

	Gui, Show, w%newW% h%newH% x%newX% y%newY% NoActivate, GUI4Boarder
	return
} else {
    WinSet, Region, 0-0 w0 h0
    return
}

return

}

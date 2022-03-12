



Gui, Main:New, +Resize -MaximizeBox, Test

Gui, Main:Add, Button, x12 y19 w110 h30 gAccountManagment , Personnages
Gui, Main:Add, GroupBox, x22 y299 w150 h100 , Options rapide
Gui, Main:Add, CheckBox, x52 y329 w80 h20 , Follow auto
Gui, Main:Add, Button, x22 y119 w100 h40 , REJOINDRE COMBAT
Gui, Main:Add, Button, x132 y119 w90 h40 , GROUPER
Gui, Main:Add, Button, x22 y179 w100 h40 , PRET
Gui, Main:Add, CheckBox, x52 y359 w90 h30 , Mode combat




Gui, Main:Show,x500 y361 w269 h454

Return

GuiEscape:
GuiClose:
Quitter:
ExitApp

#include %A_ScriptDir%\AccountManagment.ahk







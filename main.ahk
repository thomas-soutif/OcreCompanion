
#include %A_ScriptDir%\CommonFunction.ahk
#include %A_ScriptDir%\AccountManagment.ahk
#include %A_ScriptDir%\AdvancedOptions.ahk
#include %A_ScriptDir%\FollowAutoPosition.ahk
#include %A_ScriptDir%\CharacterFunctions.ahk
#include %A_ScriptDir%\Shortcuts.ahk
#include %A_ScriptDir%\ShortcutsInterface.ahk
#include <FindText>
    
;global parameter of Window
SetDefaults(void)
{
	global
	MainWindowsX :=500 
	MainWindowsY :=361 
	MainWindowsW :=269 
	MainWindowsH :=454
	TempLocationForCharacter = %A_Temp%\DofusMultiAccountTools\Characters\
	return
}	
	TempLocationForCharacter = %A_Temp%\DofusMultiAccountTools\Characters\
	FollowAutoActive := 0
	FightModeActive := 0
	NoDelayActive :=0
	FollowAutoText = Follow Auto (Tab + Lclick)
	FightModeText = Mode combat
	NoDelayText = No Delay (Alt + Lclick)
	DictPositionFollowCharacter := New DictCustom
	DictPositionFollowCharacterTick := New DictCustom
	VerifyNewPositionFollowAutoLock := 0
	timerVerifyNewPosition := 1000
	ignoreNoDelayWarningForThisSession := 0
	KeyPressQueue := New ListCustom
	NameOfWindows = DofusMultiAccountTool 1.0 TM
	FocusCharactersPath := New ListCustom
	CharactersPath := New ListCustom
	LastCharacterFocusPath := ""
	loopCharacterCreationRun := 1
	LastCharactersRegistered := New ListCustom
	LastCharactersRegistered.SetList("")
START:
LoadPositionWindowXandY()
	MainWindowsW :=269 
	MainWindowsH :=454
if !FileExist("%A_ScriptDir%\config.ini"){
	FileAppend,, %A_ScriptDir%\config.ini

}
TempLocationForCharacter = %A_Temp%\DofusMultiAccountTools\Characters\
ignoreNoDelayWarningForThisSession := 0
IfNotExist, %TempLocationForCharacter%
   FileCreateDir, %TempLocationForCharacter%
FileDelete, %TempLocationForCharacter%\*.*
Gui, Main:Hide
; Chargement des chemins d'image utilisées
dofus_icon_imageLocation = %A_ScriptDir%\images\dofus_icon.png
group_icon_imageLocation = %A_ScriptDir%\images\group_icon.png
ready_fight_imageLocation = %A_ScriptDir%\images\ready_fight.png
join_fight_icon_imageLocation = %A_ScriptDir%\images\join_fight_icon.png
config_icon_imageLocation = %A_ScriptDir%\images\config_icon.png
Gui, Main:New, +Resize -MaximizeBox
Gui, Main:Add, Button, x12 y19 w110 h30 gShortcutManagementGui , Raccourcis
Gui, Main:Add, Button, x150 y19 w110 h30 gAdvancedOptionsGui , Options
Gui, Main:Add, GroupBox, x22 y320 w150 h110 , Options rapide
Gui, Main:Add, GroupBox, x10 y160 w240 h155 , Personnages detectés en jeu
Gui, Main:Add, CheckBox, x27 y350 w145 h20 vFollowAutoActive gFollowAutoActiveClick , %FollowAutoText%
Gui, Main:Add, Text, x180 y392 , Detecter les 
Gui, Main:Add, Text, x180 y405 , personnages
Gui, Main:Add, CheckBox,Disabled x27 y375 w90 h20 vFightModeActive gFightActiveClick ,%FightModeText%
Gui, Main:Add, CheckBox, x27 y400 w145 h20 vNoDelayActive gNoDelayClick ,%NoDelayText%
Gui, Add, Picture, x223 y287 w25 h25 gAccountManagment , %config_icon_imageLocation%
Gui, Add, Picture, x180 y350 w50 h40 gCreateShowCharacterBox, %dofus_icon_imageLocation%
Gui, Add, Picture, x180 y68 w75 h75 gGroupCharacters, %group_icon_imageLocation%
Gui, Add, Picture, x100 y73 w70 h70 gJoinFightForAllCharacters, %join_fight_icon_imageLocation%
Gui, Add, Picture, x20 y73 w70 h70  gFightReadyForAllCharacters, %ready_fight_imageLocation%

;Check ou non Follow Auto lorsqu'on affiche pour la première fois le menu

if(FollowAutoActive == 1){
        GuiControl,, %FollowAutoText% , 1
        
}else{
    GuiControl,, %FollowAutoText%, 0
}


if(FightModeActive == 1){
        GuiControl,, %FightModeText% , 1
        
}else{
    GuiControl,, %FightModeText%, 0
}

if(NoDelayActive == 1){
        GuiControl,, %NoDelayText% , 1
        
}else{
    GuiControl,, %NoDelayText%, 0
}
 
DetectHiddenWindows, On
Script_Hwnd := WinExist("ahk_class AutoHotkey ahk_pid " DllCall("GetCurrentProcessId"))
DetectHiddenWindows, Off

; Register shell hook to detect flashing windows.
DllCall("RegisterShellHookWindow", "uint", Script_Hwnd)

;OnMessage(DllCall("RegisterWindowMessage", "str", "SHELLHOOK"), "ShellEvent")
;...
CreateShowCharacterBox()
Gui, Main:+AlwaysOnTop
Gui, Main: +E0x20
Gui, Main:Color, 729799
Gui, Main:Show, x%MainWindowsX% y%MainWindowsY% w%MainWindowsW% h%MainWindowsH% , %NameOfWindows% 

SetTimer,VerifyNewPositionFollowAuto, %timerVerifyNewPosition%

LoadQuickOptionsState()
; Boucle principale
Loop
{	
	
	Input, Var, V L1 T0.5,{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
	if(Var != ""){
		KeyPressQueue.Add(Var)
	}
	IfWinNotExist, %NameOfWindows%,
	ExitApp

	keysQueue := KeyPressQueue.GetAll()
	keyFirst := KeyPressQueue.Get(1)
	KeyPressQueue.SetList("")
	vkCode := GetKeyVK(KeyFirst)
	WM_KEYDOWN(vkCode)
	VerifyIfCharacterOrderChanged()
	
}
#include %A_ScriptDir%\RegisterAllKey.ahk



Return
GuiEscape:
GuiClose:
Quitter:
ExitApp

;ReloadGui:

	;WinGetPos, xPos,yPos,wPos,hPos
	;MainWindowsX :=xPos 
	;MainWindowsY :=yPos
	;MsgBox, %MainWindowsX%
	;VerificationPositionMainWindows() ; Save new position
	;return
;Des que l'utilisateur fait un clique droit

~!LButton::
~LButton::

;Verifier si la fenetre à changer de position afin d'enregistrer les coordonnées
SetTimer,VerificationPositionMainWindows, 1000
Gui, Main:Submit, NoHide,
if (FollowAutoActive == 0 and NoDelayActive == 0 ){
	return
}
;La touche Tab doit être appuyé pour déplacer tout les personnages, et Alt pour le no delay. Sera configurable dans une prochaine version.

if(GetKeyState("Tab","P") and FollowAutoActive == 1 ){
	;Mode follow auto
	currentMode :=  "FollowAuto"
}
else if(GetKeyState("Alt","P") and NoDelayActive == 1) {
	;Mode no NoDelay
	currentMode := "NoDelay"
}
else{
	return
}
MouseGetPos, xpos, ypos
MouseGetPos, , , winid
characterNames := GetCharacterNames()
characterNames = %characterNames%  
SetTitleMatchMode 2
windowsFinId := ""
IniRead, MinvalueTimer, %A_ScriptDir%\config.ini,Timers, FollowMin
IniRead, MaxvalueTimer, %A_ScriptDir%\config.ini,Timers, FollowMax
Loop, Parse, characterNames, "|"
{
	characterWindowsId := DetectWindowsByName(A_LoopField)
	if( characterWindowsId == winid){
		;La fenetre actuel est bien celle d'un des personnages
		;Tout les autres vont aller au même point
		windowsFinId := characterWindowsId
		;ControlClick x%xpos% y%ypos%, %A_LoopField%
		break
	}

}



if(windowsFinId){
	
	;Il s'agit d'un personnage configuré
	Loop, Parse, characterNames, "|"
	{
		characterWindowsId := DetectWindowsByName(A_LoopField)
		if( characterWindowsId != winid){

			if(currentMode == "FollowAuto"){

				if (WinExist(A_LoopField)){
					currentPositionsWaiting := DictPositionFollowCharacter.Get(A_LoopField)
					customList := New ListCustom
					if(currentPositionsWaiting != ""){
						customList.SetList(currentPositionsWaiting)
					}
				
					positionScreen := New PositionScreen
					positionScreen.SavePosition(xpos,ypos)
					positionToWrite:= positionScreen.GetPosition()
					customList.Add(positionToWrite)

					customListPosition := customList.GetAll()
					DictPositionFollowCharacter.Add(A_LoopField,customListPosition)

				}
			
			}
			else if(currentMode == "NoDelay"){
				if (WinExist(A_LoopField)){
					Random, timerValue, 100, 200
					Sleep timerValue
					ControlClick x%xpos% y%ypos%,%A_LoopField%
				}

			}
		}

		

	}
	
}

return

ShellEvent(wParam, lParam) {
	global
	Gui, Main:Submit, NoHide
	if(FightModeActive == 0)
			return
    if (wParam = 0x8006) ; HSHELL_FLASH
    {   ; lParam contains the ID of the window which flashed:
        ;WinActivate, ahk_id %lParam%
		
		WinGetTitle wt, ahk_id %lParam%
		characterNames := GetCharacterDetectedInGame()
		characterNames = %characterNames%
		SetTitleMatchMode 2
		Loop, Parse, characterNames, "|"
		{
			WinGet, id_character_w, , %A_LoopField%
			if(id_character_w == lParam){
				if(WinExist(A_LoopField)){
					WinActivate
				}
			}
		}
    }
	return
}


NoDelayClick(){
	global
	Gui, Main:Submit, NoHide
	if(FollowAutoActive == 1 and NoDelayActive == 1){
		;MsgBox,4096, "Action impossible", "Vous ne pouvez pas activer Follow Auto et No Delay en même temps"
		 ;GuiControl, focus, %NoDelayText%,
		 ;ControlClick, %NoDelayText%, A
		 ;return
		 
	}

	if(NoDelayActive == 1 and ignoreNoDelayWarningForThisSession == 0){
		MsgBox,4096, Mode no delay prévention, "Attention, le mode delay permet de reproduire instantanément tout vos clicks sur vos autres personnages. `n Utilisez le pour accepter vos quetes,les valider, mais évitez de vous déplacer avec car c'est passible de bannissement. "
		ignoreNoDelayWarningForThisSession := 1
	}
	IniWrite, %NoDelayActive%, %A_ScriptDir%\config.ini, QuickOptionsState, NoDelayActive
	return
}




FightActiveClick(){
	global
	Gui, Main:Submit, NoHide
	IniWrite, %FightModeActive%, %A_ScriptDir%\config.ini, QuickOptionsState, FightModeActive
	return
}

WM_KEYDOWN(virtualCode)
{
	
	;On vérifie les raccourcis uniquement si la fenetre active est une des personnages connectés
	if(GetCurrentCharacterFocusing() != ""){
		VerifyShortcuts(virtualCode)
		; On vérifie le focus personnage
		VerifyFocusCharacter()
	}

	
    return
}

VerifyFocusCharacter(){
	global

	if(GetCurrentCharacterFocusing() == ""){
		return
	}
	
    currentFocusCharacterIndex := GetCurrentCharacterFocusingIndex()
	focusCharactersAllPath := FocusCharactersPath.GetAll()
	focusCharacterImagePath := FocusCharactersPath.Get(currentFocusCharacterIndex)
	if(focusCharacterImagePath == LastCharacterFocusPath){
		return
	}
	GuiControl, Hide, %LastCharacterFocusPath%
	GuiControl, Show, %focusCharacterImagePath%
	LastCharacterFocusPath := focusCharacterImagePath
	
}

LoadQuickOptionsState(){
	global
	
	Gui, Main:Submit, NoHide
	ifexist, %A_ScriptDir%\config.ini
	{
		IniRead, FollowAutoActiveTemp, %A_ScriptDir%\config.ini, QuickOptionsState, FollowAutoActive
		IniRead, FightModeActiveTemp, %A_ScriptDir%\config.ini, QuickOptionsState, FightModeActive
		IniRead, NoDelayActiveTemp, %A_ScriptDir%\config.ini, QuickOptionsState, NoDelayActive
		
        
	}
	
	if(FollowAutoActiveTemp == 1){
		GuiControl, focus, %FollowAutoText%,
		Loop 10 {
			ControlClick, %FollowAutoText%, A
			if(FollowAutoActive == 1){
				break
			}
		}
 		
	}

	if(FightModeActiveTemp == 1){
		GuiControl, focus, %FightModeText%,
		Loop 10 {
			ControlClick, %FightModeText%, A
			if(FightModeActive == 1){
				break
			}
		}
	}

	if(NoDelayActiveTemp == 1){
		ignoreNoDelayWarningForThisSession := 1
		GuiControl, focus, %NoDelayText%,
		Loop 10 {
			ControlClick, %NoDelayText%, A
			if(NoDelayActive == 1){
				break
		}
	}
 	
	}
 
	Gui, Main:Submit, NoHide

	return
	

}

VerificationPositionMainWindows(){
	global
	; On vérifie qu'il s'agit de la fenêtre principale du Script
  	WinGetTitle, title, A
	if(title != NameOfWindows){
		return
	}
	WinGetPos, x, y, w, h, A ; récupérer la position actuelle de la fenêtre active
	if (x != MainWindowsX or y != MainWindowsX) ; vérifier si la position a changé
	{
		;Verifier que les nouvelles positions ne soient pas vide
		if(x =="" or y == ""){
			return
		}
		IniWrite, %x%, %A_ScriptDir%\config.ini, PositionMainWindow, MainWindowsX
		IniWrite, %y%, %A_ScriptDir%\config.ini, PositionMainWindow, MainWindowsY

		MainWindowsX := x
		MainWindowsY := y
	}
	return
}

LoadPositionWindowXandY()
{

	global
	IniRead, x, %A_ScriptDir%\config.ini, PositionMainWindow, MainWindowsX
	IniRead, y, %A_ScriptDir%\config.ini, PositionMainWindow, MainWindowsY
	MainWindowsX := 500
	MainWindowsY := 361
	if(x != "ERROR" and x != "")
	{
		MainWindowsX := x
	}
	if(y != "ERROR" and y != ""){
		MainWindowsY := y
	}
	return
	
}

VerifyIfCharacterOrderChanged(){

	global
	if(LastCharactersRegistered.GetSize() == 0)
	{
		; On remplie
		characCustomList := New ListCustom
		characCustomList.SetList(GetCharacterDetectedInGame())
		if(characCustomList.GetSize() > 0){
			CreateShowCharacterBox()
		}
		return
	}
	
	if(LastCharactersRegistered.GetAll() != GetCharacterDetectedInGame() ){
		;La liste , l'ordre n'est plus le même, on met à jour
		CreateShowCharacterBox()
		return
	}
	
}

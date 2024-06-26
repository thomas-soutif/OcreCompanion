﻿#include <ScriptGuard1>
#include %A_ScriptDir%\AccountManagment.ahk
#include %A_ScriptDir%\AdvancedOptions.ahk
#include %A_ScriptDir%\FollowAutoPosition.ahk
#include %A_ScriptDir%\CharacterFunctions.ahk
#include %A_ScriptDir%\Shortcuts.ahk
#include %A_ScriptDir%\ShortcutsInterface.ahk
#include %A_ScriptDir%\CharacterViewSmallBox.ahk

#include <FindText>
#include <HotKeyManager>
#include <GraphicGui>
#include <Setting>
#include <CommonFunction>
#include <SexMap>
#include <CustomMsgBox>
;global parameter of Window
SetDefaults(void)
{
	global
	MainWindowsX :=500 
	MainWindowsY :=361 
	MainWindowsW :=269 
	MainWindowsH :=465
	TempLocationForCharacter = %A_Temp%\OcreCompanion\Characters\
	return
}	
	TempLocationForCharacter = %A_Temp%\OcreCompanion\Characters\
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
	NameOfWindows = Ocre Companion 1.2.2 TM
	FocusCharactersPath := New ListCustom
	CharactersPath := New ListCustom
	NormalBoxCharactersPath := New ListCustom
	LastCharacterFocusPath := ""
	loopCharacterCreationRun := 1
	LastCharactersRegistered := New ListCustom
	LastCharactersRegistered.SetList("")
	verifyFocusCharacterLock := 0
	smallBoxCharacterShow := -1
	smallBoxCharacterWindowTitle = SmallBoxCharacter Ocre Companion
	configPath = %A_ScriptDir%\config.ini 
	defaultConfigPath = %A_ScriptDir%\defaultConfig\defaultConfig.ini 

	map_sexe_name := New DictCustom
	map_sexe_name.Add("", "male")
	map_sexe_name.Add("male", "male")
	map_sexe_name.Add("female", "female")

	SETTING := New SETTING(configPath,defaultConfigPath)
START:
LoadPositionWindowXandY()
	MainWindowsW :=269 
	MainWindowsH :=465
if !FileExist("%A_ScriptDir%\config.ini"){
	FileAppend,, %A_ScriptDir%\config.ini

}
TempLocationForCharacter = %A_Temp%\OcreCompanion\Characters\
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
character_box_imageLocation = %A_ScriptDir%\images\open_character_panel.jpg
Gui, Main:New, +Resize -MaximizeBox
;Gui, Font, S8, Verdana
;Gui, Font, s12, CharSet:0x201
;Gui, Font, SVerdana8 C, 

Gui, Main:Add, Button, x12 y19 w110 h30 gShortcutManagementGui , Raccourcis
Gui, Main:Add, Button, x150 y19 w110 h30 gAdvancedOptionsGui , Options

Gui, Add, Picture, x180 y73 w60 h60 gGroupCharacters, %group_icon_imageLocation%
Gui, Add, Picture, x100 y73 w60 h60 gJoinFightForAllCharacters, %join_fight_icon_imageLocation%
Gui, Add, Picture, x20 y73 w60 h60  gFightReadyForAllCharacters, %ready_fight_imageLocation%

Gui, Main:Add, GroupBox, x10 y150 w240 h180 , Personnages detectés en jeu


Gui, Main:Add, GroupBox, x22 y340 w150 h110 , Options rapide
Gui, Main:Add, CheckBox, x27 y365 w145 h20 vFollowAutoActive gFollowAutoActiveClick , %FollowAutoText%
Gui, Main:Add, CheckBox, x27 y390 w90 h20 vFightModeActive gFightActiveClick ,%FightModeText%
Gui, Main:Add, CheckBox, x27 y415 w145 h20 vNoDelayActive gNoDelayClick ,%NoDelayText%
Gui, Add, Text, x20 y312, CTRL + S : Changer le sexe de la classe
Gui, Add, Picture, x223 y302 w25 h25 gAccountManagment , %config_icon_imageLocation%

Gui, Add, Picture, x190 y365 w50 h40 gCreateShowCharacterBox, %dofus_icon_imageLocation%
Gui, Main:Add, Text, x190 y408 , Détecter les 
Gui, Main:Add, Text, x190 y421 , personnages

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
;DllCall("RegisterShellHookWindow", "uint", Script_Hwnd)

;OnMessage(DllCall("RegisterWindowMessage", "str", "SHELLHOOK"), "ShellEvent")
;...
OnMessage(0x201, "WM_LBUTTONDOWN") ;
CreateShowCharacterBox()
if(SETTING.getSetting("Accessibility","ShowCharacterSmallBoxStartup") == 1)
	CreateShowCharacterSmallBox()


Gui, Main:+AlwaysOnTop
Gui, Main: +E0x20
Gui, Main:Color, 729799
Gui, Main:Show, x%MainWindowsX% y%MainWindowsY% w%MainWindowsW% h%MainWindowsH% , %NameOfWindows% 

SetTimer,VerifyNewPositionFollowAuto, %timerVerifyNewPosition%

LoadQuickOptionsState()
;Initialisation des Hotkeys 
HotkeyManager := New HotkeyManager()
; Boucle principale
Loop
{	
	
	IfWinNotExist, %NameOfWindows%,
		BeforeExitApp()
	VerifyIfCharacterOrderChanged()
	VerifyFocusCharacter()
	VerifyDofusWindows()
	sleep 200
	
	 
}

Return



GuiEscape:
Quitter:
ExitApp

;; LABEL ;;
#include %A_ScriptDir%\ShortcutsLabel.ahk
;; ;;

~!LButton::
~LButton::

;Verifier si la fenetre à changer de position afin d'enregistrer les coordonnées
SetTimer,VerificationPositionMainWindows, 1000
SetTimer,VerifyPositionSmallCharacterBox,1000
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
characterNames := GetCharacterDetectedInGame()
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
					;Random, timerValue, 100, 200
					;Sleep 10
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
	if (FightModeActive != 0){
		
		value := SETTING.GetSetting("DialogMessageHide","FightMode_Illustration")
		if(value == "" || value ==  "ERROR"){
			SETTING.setSetting("DialogMessageHide","FightMode_Illustration", 0)
			value := 0
		}

		if(value == 0){
			clickedButton := ShowCustomMsgBox("Mode combat","Pour que le mode combat fonctionne, n'oubliez pas d'activer les Illustrations de Combats dans les options du jeu.", "Ok", "Ne plus afficher")
			if(clickedButton == "2"){
				SETTING.setSetting("DialogMessageHide","FightMode_Illustration", 1)
			}	
		}
		
	}
		
	if(FightModeActive == 1){
		CloseScript("FightTurnDetection")
		WinClose, FightTurnDetection
		sleep 100
		RunFightTurnDetectionFile()
	}else{
		CloseScript("FightTurnDetection")
		WinClose, FightTurnDetection
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
			if(WinExist(NameOfWindows))
				WinActivate
			ControlClick, %dofus_icon_imageLocation%,,, Left, 1
			CreateShowCharacterSmallBox()
		}
		return
	}
	
	if(LastCharactersRegistered.GetAll() != GetCharacterDetectedInGame() ){
		;La liste , l'ordre n'est plus le même, on met à jour
		if(WinExist(NameOfWindows))
			WinActivate
		ControlClick, %dofus_icon_imageLocation%,,, Left, 1
		CreateShowCharacterSmallBox()
		return
	}
	
}


WM_LBUTTONDOWN()
{
	;On ne veut permettre de déplacer que la fenêtre SmallBoxCharacter
	;MsgBox, %A_Gui%
	If (A_Gui == "CharacterSmallBox" and A_GuiControl == "MoveSmallCharacterBoxImage"){
		;MsgBox, %A_GuiControl%
		PostMessage, 0xA1, 2 ; 0xA1 = WM_NCLBUTTONDOWN
		
	}
	;SetTimer, VerifyPositionSmallCharacterBox, 200
	;VerifyPositionSmallCharacterBox()
}


VerifyDofusWindows(){
	global
	Gui, Submit,NoHide
	SetTitleMatchMode, 2
	WinGetActiveTitle, activeWinTitle  ; gets the title of active window
	isDofusWindow := 0
	
	if (activeWinTitle == smallBoxCharacterWindowTitle)
		isDofusWindow := 1
	if(activeWinTitle == NameOfWindows)
		isDofusWindow :=1
		
	IfWinActive, ahk_exe Dofus.exe
		isDofusWindow := 1
	if (isDofusWindow){
		if(smallBoxCharacterShow == 0){
			smallBoxCharacterShow := 1
			WinSet, Transparent, 255, %smallBoxCharacterWindowTitle%
			WinSet, ExStyle, 0x20, %smallBoxCharacterWindowTitle%
			;MsgBox, "Transparent set"
		}	
		return
			
    }
	if(smallBoxCharacterShow == 1 || smallBoxCharacterShow == -1){
		smallBoxCharacterShow := 0
		WinSet, Transparent, 0, %smallBoxCharacterWindowTitle%
		;MsgBox, "Transparent Unset"
	}
	
	
}

RunFightTurnDetectionFile(){
	global
	fileDestination := ConvertFileNameToCorrectScriptType(A_ScriptDir . "\bin\FightTurnDetection")
	parameterString := """" . fileDestination . """"
	
	characters := GetCharacterNames()
	Loop, Parse, characters, "|"
	{
	 	parameterString .= " """ . A_LoopField . """"
	}

	Run, %parameterString%,, Hide
}


BeforeExitApp(){
	CloseScript("FightTurnDetection")
	WinClose, FightTurnDetection
	ExitApp
}


~^s::
	MouseGetPos, , , window, ctrl
	ControlGetText, filename, % ctrl, % "ahk_id " window
	;ToolTip, % "Window's HWND: " window "`nControl's name: " Ctrl "`nControl's text: " text
	WinGetTitle, titleWin, ahk_id %window%
	if(titleWin != NameOfWindows){
		return
	}
	; extraire la partie de la chaîne après "Characters\"
	charactersIndex := InStr(filename, "Characters\") + StrLen("Characters\")
	charactersSubstring := SubStr(filename, charactersIndex)

	; extraire le premier mot avant le premier "_" dans la sous-chaîne "charactersSubstring"
	characterName := ""
	if InStr(charactersSubstring, "_") > 0
	{
		characterName := SubStr(charactersSubstring, 1, InStr(charactersSubstring, "_") - 1)
	}
	else
	{
		characterName := charactersSubstring
	}

	list := GetCharacterDetectedInGame()
	custom_list := New ListCustom
	custom_list.SetList(list)
	index := custom_list.Find(characterName)
	if(custom_list.Get(index) == ""){
		return
	}

	if(index == ""){
		return
	}

	;L'icone correspond bien au nom du personnage, on peut switch de sexe
	Sexe := SETTING.getSetting("SexOfCharacter",characterName)
	if(Sexe == "male"){
		Sexe := "female"
	}else{
		Sexe := "male"
	}
	SETTING.setSetting("SexOfCharacter",characterName,Sexe)
	CreateShowCharacterSmallBox()
	if(WinExist(NameOfWindows))
		WinActivate
	ControlClick, %dofus_icon_imageLocation%,,, Left, 1
return
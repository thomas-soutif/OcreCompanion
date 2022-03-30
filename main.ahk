﻿#include %A_ScriptDir%\CommonFunction.ahk
#include %A_ScriptDir%\AccountManagment.ahk
#include %A_ScriptDir%\AdvancedOptions.ahk

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

	MainWindowsX :=500 
	MainWindowsY :=361 
	MainWindowsW :=269 
	MainWindowsH :=454
	TempLocationForCharacter = %A_Temp%\DofusMultiAccountTools\Characters\
START:

if !FileExist("%A_ScriptDir%\config.ini"){
	FileAppend,, %A_ScriptDir%\config.ini

}
TempLocationForCharacter = %A_Temp%\DofusMultiAccountTools\Characters\

IfNotExist, %TempLocationForCharacter%
   FileCreateDir, %TempLocationForCharacter%
Gui, Main:Hide
; Chargement des chemins d'image utilisées
dofus_icon_imageLocation = %A_ScriptDir%\images\dofus_icon.png
group_icon_imageLocation = %A_ScriptDir%\images\group_icon.png
ready_fight_imageLocation = %A_ScriptDir%\images\ready_fight.png
join_fight_icon_imageLocation = %A_ScriptDir%\images\join_fight_icon.png
Gui, Main:New, +Resize -MaximizeBox
Gui, Main:Add, Button, x12 y19 w110 h30 gAccountManagment , Personnages
Gui, Main:Add, Button, x150 y19 w110 h30 gAdvancedOptionsGui , Options avancées
Gui, Main:Add, GroupBox, x22 y320 w150 h100 , Options rapide
Gui, Main:Add, GroupBox, x10 y160 w240 h155 , Personnages detectés en jeu
Gui, Main:Add, CheckBox, disabled x52 y350 w80 h20 , Follow auto
;Gui, Main:Add, Button,disabled x100 y180 w70 h40 , PERSONNAGE2
;Gui, Main:Add, Button,hide x22 y180 w70 h40 , PERSONNAGE1START
;Gui, Main:Add, Button,disabled x178 y180 w70 h40 , PERSONNAGE3
;Gui, Main:Add, Button,disabled x22 y240 w70 h40 , PERSONNAGE4
;Gui, Main:Add, Button, x180 y77 w75 h75 gGroupCharacters gGroupCharacters , GROUPER
;Gui, Main:Add, Button,disabled x22 y179 w100 h40 , PRET
Gui, Main:Add, CheckBox, disabled x52 y370 w90 h30 , Mode combat
Gui, Add, Picture, x180 y350 w50 h40 gReloadGui, %dofus_icon_imageLocation%
Gui, Add, Picture, x180 y77 w75 h75 gGroupCharacters, %group_icon_imageLocation%
Gui, Add, Picture, x100 y80 w70 h70 gJoinFightForAllCharacters, %join_fight_icon_imageLocation%
Gui, Add, Picture, x20 y80 w70 h70  gFightReadyForAllCharacters, %ready_fight_imageLocation%
idd := DetectWindowsByName("Ankama")

;Detection des personnages configurés et récupération de leur id de fenêtre
characterNames := GetCharacterNames()
characterNames = %characterNames%

;MsgBox, %idd%





;MsgBox % List(characterNames,1)

Loop, Parse, characterNames, "|"
{
	;Pour chaque personnage
	;MsgBox, %A_LoopField%

}
CreateShowCharacterBox()

;MsgBox, "Stop"

Gui, Main:+AlwaysOnTop
Gui, Main:Show, x%MainWindowsX% y%MainWindowsY% w%MainWindowsW% h%MainWindowsH% , DofusMultiAccountTool


Return

GuiEscape:
GuiClose:
Quitter:
ExitApp

DetectWindowsByName(str)
{
	; Prend en paramètre une string, et retourne l'id de la fenêtre si cette string est inclue dans l'un des noms de fenêtre Windows. 

	SetTitleMatchMode 2
	UniqueID := WinExist(str)
	return UniqueID
	
}


GetCharacterNames(){
	
	IniRead, CharacterNameList, %A_ScriptDir%\config.ini, CharactersList, listCharacters
	return CharacterNameList



}

GetCharacterDetectedInGame(){
	IniRead, CharacterNameList, %A_ScriptDir%\config.ini, CharactersList, listCharacters
	finalList := "" 
	Loop, Parse, CharacterNameList, "|"
	{
		if (WinExist(A_LoopField)){
			if (finalList ==""){
				finalList = %A_LoopField%|
			}
			else{
				finalList = %finalList%%A_LoopField%|
			}
		}
	}
	return finalList

}

GroupCharacters(){
	characterNames := GetCharacterNames()
	characterNames = %characterNames%  
	
	if !(List(characterNames,2)){
		;Si il n'y a pas au moins 2 personnages, alors on arrête
		MsgBox, "Il vous faut au moins 2 personnages configurés pour pouvoir utiliser cette option"
		return
	}
	
	;On va choisir un personnage qui sera le meneur
	groupChefCharacter := List(characterNames,1)
	iddWindowsMainCharacter := DetectWindowsByName(groupChefCharacter)

	;On va vérifier si le timer setting qu'on a besoin est disponible
	ifexist, %A_ScriptDir%\config.ini
	{
        
		IniRead,value,%A_ScriptDir%\config.ini,Timers, GroupMin
		if(value == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, GroupMin
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, GroupMin
		}

		IniRead,value,%A_ScriptDir%\config.ini,Timers, GroupMax
		if(value == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, GroupMax
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, GroupMax
		}
        
	}
	
	;On va tenter de récupérer l'image encrypté sous le format actuel de l'écran si jamais c'est la première fois que le joueur utilise cette fonction

	IniRead, PositionAcceptGroupX, %A_ScriptDir%\config.ini,Position, AcceptGroupButtonX
	IniRead, PositionAcceptGroupY,%A_ScriptDir%\config.ini,Position, AcceptGroupButtonY
	TextEncrypt := ""
	if(not PositionAcceptGroupX or not PositionAcceptGroupY or PositionAcceptGroupX == "ERROR" or PositionAcceptGroupY == "Error"){
		;On va alors initialiser la procédure de detection du bouton accepter

		IniRead,value,%A_ScriptDir%\defaultConfig\staticTextEncrypt.ini,AcceptGroupButton_%A_ScreenWidth%x%A_ScreenHeight%, Text
		;AcceptGroupButton_1560x1440
		if(value == "ERROR"){
			;Le texte n'existe pas pour la résolution actuel du joueur, on s'arrête là
			MsgBox " [Optionnel] Votre résolution actuelle n'est pas supporté pour pouvoir utiliser la reconnaissance d'image du bouton 'Rejoindre le Groupe', vous pouvez envoyer un message au support pour que nous puissions ajouter votre résolution au programme, ceci n'est que du confort. Appuyer sur Ok pour continuer d'executer le script"
			
		}else{
			TextEncrypt := value
		
			; Text récupéré
			MsgBox, "C'est la premiere fois que vous utilisez la fonctionnalite Groupe. Nous allons effectue des reglages automatiquement une fois que vous aurez appuye sur le bouton Ok. `n N'oubliez pas de réinitialiser vos positions d'interface pour chacun de vos personnages avant de continuer. (Option/Interface/Reinitialiser les positions d'interface)"
			
		}

		

	}

	

	SetTitleMatchMode 2
	if(WinExist(groupChefCharacter)){

		WinActivate
		IniRead, MinvalueTimer, %A_ScriptDir%\config.ini,Timers, GroupMin
		IniRead, MaxValueTimer, %A_ScriptDir%\config.ini,Timers, GroupMax
		Loop, Parse, characterNames, "|"
			{
				;Pour chaque personnage qui n'est pas le chef de groupe
				if(A_LoopField == groupChefCharacter)
					Continue
				; On va les inviter dans le groupe après avoir focus la zone de tchat du personnage en question  
				

				
				
				Send {Space}
				send {Ctrl Down}a{Ctrl Up}
				send {BackSpace}
				; On envoie la commande d'invitation pour chaque autre personnage
				Send /invite %A_LoopField%
				Sleep 200
				Send {Enter}

				
				Random, timerValue, MinvalueTimer, MaxValueTimer

				Sleep timerValue
			}
			; A ce stade, tout les personnages ont été invités
			; On va à présent accepter les invitations

			Loop, Parse, characterNames, "|"
			{
				;Pour chaque personnage qui n'est pas le chef de groupe
				if(A_LoopField == groupChefCharacter)
					Continue
				
				;On focus
				if(WinExist(A_LoopField)){
					t1:=A_TickCount, X:=Y:=""
					if (TextEncrypt){
						WinActivate
						sleep 1000
						try_num := 1
						while(try_num < 5){
							Text := TextEncrypt
							ok:=FindText(X, Y, A_ScreenWidth, 0, -1, A_ScreenHeight, 0, 0, Text)
							;MsgBox, %X%,%Y%, %Text%
							if(ok.Length())
							{
								;Le bouton accepté a été trouvé
								;On sauvegarde la position trouvé
								IniWrite, %X%, %A_ScriptDir%\config.ini, Position, AcceptGroupButtonX
								IniWrite, %Y%, %A_ScriptDir%\config.ini, Position, AcceptGroupButtonY
								TextEncrypt := ""
								FindText().Click(X, Y, "L")
								try_num := 10
							}else{
								try_num := try_num +1
								sleep 200
							}

								
						}
						if(TextEncrypt){
							;Alors la detection automatique n'a pas marché. On va alors demander à l'utilisateur de cliquer sur le bouton Accepter pour faire les reglages
							MsgBox, "Nous n'avons pas pu cette fois detecté automatiquement la position du bouton Accepter.`n Après avoir appuyer sur le bouton Ok de cette popup, faites un clique gauche sur le bouton accepter sur votre fenêtre de jeu afin que nous enregistrions la position.` Vous avez 10 secondes pour effectuer cette action, après celà le script s'annulera."
							KeyWait, LButton , D T10
							if(ErrorLevel == 1){
								;L'utilisateur n'a pas appuyé sur le bon bouton au bon moment
								MsgBox, "Il semblerait que vous n'ayez pas cliqué sur le bouton accepté ! Annulation du script."
								return
							}
							MouseGetPos, MouseX, MouseY, MouseWin, MouseCtl, 2
							IniWrite, %MouseX%, %A_ScriptDir%\config.ini, Position, AcceptGroupButtonX
							IniWrite, %MouseY%, %A_ScriptDir%\config.ini, Position, AcceptGroupButtonY
							TextEncrypt := ""
							; On va appuyer pour ce cas ici sur le bouton accepter
							Sleep, 500
							FindText().Click(MouseX, MouseY, "L")
							
							

						}
						
					}
					else{
						;On connait les coordonnées
						IniRead, PositionAcceptGroupX, %A_ScriptDir%\config.ini,Position, AcceptGroupButtonX
						IniRead, PositionAcceptGroupY,%A_ScriptDir%\config.ini,Position, AcceptGroupButtonY
						;FindText().Click(PositionAcceptGroupX, PositionAcceptGroupY, "L")
						ControlClick x%PositionAcceptGroupX% y%PositionAcceptGroupY%, %A_LoopField%
					}


				}
				Random, timerValue, 500, 1500
				Sleep timerValue

			}



	}
	
	;On retourne sur la fenetre du chef de groupe
	if(WinExist(groupChefCharacter)){

		WinActivate

	
	}
	return ""
}

JoinFightForAllCharacters(){

	characterNames := GetCharacterNames()
	characterNames = %characterNames%  
	
	if !(List(characterNames,2)){
		;Si il n'y a pas au moins 2 personnages, alors on arrête
		MsgBox, "Il vous faut au moins 2 personnages configurés pour pouvoir utiliser cette option"
		return
	}
	
	;On va vérifier si le timer setting qu'on a besoin est disponible
	ifexist, %A_ScriptDir%\config.ini
	{
        
		IniRead,value,%A_ScriptDir%\config.ini,Timers, JoinFightMin
		if(value == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, JoinFightMin
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, JoinFightMin
		}

		IniRead,value,%A_ScriptDir%\config.ini,Timers, JoinFightMax
		if(value == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, JoinFightMax
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, JoinFightMax
		}
        
	}
	
	;On va tenter de récupérer l'image encrypté sous le format actuel de l'écran si jamais c'est la première fois que le joueur utilise cette fonction

	IniRead, PositionJoinFightX, %A_ScriptDir%\config.ini,Position, JoinFightButtonX
	IniRead, PositionJoinFightY,%A_ScriptDir%\config.ini,Position, JoinFightButtonY
	TextEncrypt := ""
	if(not PositionJoinFightX or not PositionJoinFightY or PositionJoinFightX == "ERROR" or PositionJoinFightY == "Error"){
		;On va alors initialiser la procédure de detection du bouton accepter

		IniRead,value,%A_ScriptDir%\defaultConfig\staticTextEncrypt.ini,JoinFightButton_%A_ScreenWidth%x%A_ScreenHeight%, Text
		if(value == "ERROR"){
			;Le texte n'existe pas pour la résolution actuel du joueur, on s'arrête là
			MsgBox "[Optionnel] Votre résolution actuelle n'est pas supporté pour pouvoir utiliser la reconnaissance d'image du bouton 'Rejoindre le fight', vous pouvez envoyer un message au support pour que nous puissions ajouter votre résolution au programme, ceci n'est que du confort. `n Appuyer sur Ok pour continuer d'executer le script"
			
		}else{
			TextEncrypt := value
		
			; Text récupéré
			MsgBox, "C'est la premiere fois que vous utilisez la fonctionnalite rejoindre un fight. Nous allons effectue des reglages automatiquement une fois que vous aurez appuye sur le bouton Ok. `n N'oubliez pas de réinitialiser vos positions d'interface pour chacun de vos personnages avant de continuer. (Option/Interface/Reinitialiser les positions d'interface)"
		}

		

	}

	

	SetTitleMatchMode 2
	if(TextEncrypt){
		;Si jamais on peut detecter le bouton Rejoindre
		Loop, Parse, characterNames, "|"
		{
			
			;On focus
			if(WinExist(A_LoopField)){
				t1:=A_TickCount, X:=Y:=""
				
				WinActivate
				sleep 1000
				try_num := 1
				while(try_num < 2){
					Text := TextEncrypt
					ok:=FindText(X, Y, A_ScreenWidth, 0, -1, A_ScreenHeight, 0, 0, Text)
					;MsgBox, %X%,%Y%, %Text%
					if(ok.Length())
					{
						;Le bouton accepté a été trouvé
						;On sauvegarde la position trouvé
						IniWrite, %X%, %A_ScriptDir%\config.ini, Position, JoinFightButtonX
						IniWrite, %Y%, %A_ScriptDir%\config.ini, Position, JoinFightButtonY
						TextEncrypt := ""
						;FindText().Click(X, Y, "L")
						try_num := 10
					}else{
						try_num := try_num +1
						sleep 200
					}

						
				}
						
			}
			Sleep 200

		}

		if(TextEncrypt){
			;Alors la detection automatique n'a pas marché. On va alors demander à l'utilisateur de cliquer sur le bouton Rejoindre pour faire les reglages
			MsgBox, "Nous n'avons pas pu cette fois detecté automatiquement la position du bouton Rejoindre.`n Mettez vous sur une fenêtre où le bouton Rejoindre d'affiche. `n Après avoir appuyer sur le bouton Ok de cette popup, faites un clique gauche sur le bouton Rejoindre sur votre fenêtre de jeu afin que nous enregistrions la position.` Vous avez 10 secondes pour effectuer cette action, après celà le script s'annulera."
			KeyWait, LButton , D T10
			if(ErrorLevel == 1){
				;L'utilisateur n'a pas appuyé sur le bon bouton au bon moment
				MsgBox, "Il semblerait que vous n'ayez pas cliqué sur le bouton accepté ! Annulation du script."
				return
			}
			MouseGetPos, MouseX, MouseY, MouseWin, MouseCtl, 2
			IniWrite, %MouseX%, %A_ScriptDir%\config.ini, Position, JoinFightButtonX
			IniWrite, %MouseY%, %A_ScriptDir%\config.ini, Position, JoinFightButtonY
			TextEncrypt := ""
			; On va appuyer pour ce cas ici sur le bouton accepter
			Sleep, 500
			FindText().Click(MouseX, MouseY, "L")
					
		}

		
	}

	IniRead, MinvalueTimer, %A_ScriptDir%\config.ini,Timers, JoinFightMin
	IniRead, MaxValueTimer, %A_ScriptDir%\config.ini,Timers, JoinFightMax
	Loop, Parse, characterNames, "|"
	{
			
			
		if(WinExist(A_LoopField)){
		
			
			;On connait les coordonnées
			IniRead, PositionAcceptGroupX, %A_ScriptDir%\config.ini,Position, JoinFightButtonX
			IniRead, PositionAcceptGroupY,%A_ScriptDir%\config.ini,Position, JoinFightButtonY
			;FindText().Click(PositionAcceptGroupX, PositionAcceptGroupY, "L")
			ControlClick x%PositionAcceptGroupX% y%PositionAcceptGroupY%, %A_LoopField%
			
		}
		Random, timerValue, MinvalueTimer, MaxValueTimer
		Sleep timerValue

	}

	return ""
}

CreateShowCharacterBox(){
global

		xaxe:=100
		yaxe:=50
		width:=70
		height:=40
	

	characterNames := GetCharacterDetectedInGame()
	characterNames = %characterNames%  
	Gui, Main:Add, Button,hide x14 y180 w0 h0 ; Permet de définir le début où sera positionné les boutons
	GUI, Main:Margin, 22,180
	i := 1
	listCharacterNotDetect := ""
	
	Loop, Parse, characterNames, "|"
	{
		
		;GUI, Add, Text, Section xm ym w52 h52
		if(A_LoopField == "")
			Continue
		;Gui, Add, Picture, x180 y330 w50 h40 gReloadGui, %dofus_icon_imageLocation%
		
		IniRead, classCharacter,%A_ScriptDir%\config.ini,ClassOfCharacter, %A_LoopField%
		
		;Récupération du nombre de fichiers
		CountItems := 0
		Loop,  %A_ScriptDir%\images\characters_bank_images\%classCharacter%\*.*
		{
			CountItems++
		}
		;MsgBox, % CountItems
		folder = %A_ScriptDir%\images\characters_bank_images\%classCharacter%
		listFiles := list_files(folder)
		
		fileSelectToShow := get_element_in_list_file(1,listFiles) ; Pour le moment on prend tjrs la première image
		fullPathPicture = %A_ScriptDir%\images\characters_bank_images\%classCharacter%\%fileSelectToShow%
		;classCharacterImageLocation = %A_ScriptDir%\images\%classCharacter%.png
		;MsgBox, %classCharacterImageLocation%
		;MsgBox, %classCharacter%
		;TempLocationForCharacter = %A_Temp%\DofusMultiAccountTools\Characters\
		;fullPathPicture = %A_ScriptDir%\images\characters_bank_images\%classCharacter%\%fileSelectToShow%
		;pictureToTempPath = %TempLocationForCharacter%%A_LoopField%.png
		;FileCopy, %fullPathPicture%,%pictureToTempPath%, 1
		if(i < 4)
			;GUI, Main:Add, Button, X+5 w70 h40 gSelectCharacter, % A_LoopField
			Gui,Add, Picture, X+15 w60 h60 vCharacterPic_%A_Index%, %fullPathPicture%
			GuiControl,+gSelectCharacter,CharacterPic_%A_Index%
		if(i ==4)
			;GUI, Main:Add, Button, xm+10 ym+10 w10 h0, Section
			GUI, Main:Add, Picture, ym+70 xm+10 w60 h60 vCharacterPic_%A_Index% ,%fullPathPicture%
			GuiControl,+gSelectCharacter,CharacterPic_%A_Index%
		if(i > 4)
			GUI, Main:Add, Picture,X+15 w60 h60 vCharacterPic_%A_Index% ,%fullPathPicture%
			GuiControl,+gSelectCharacter,CharacterPic_%A_Index%

		i := i+1


		CharacterSelect_%A_Index%: 
		CurrentCharacterSelect = %A_LoopField%

		Gui, Main:Show
	}

	return
}

FightReadyForAllCharacters(){
	SetTitleMatchMode 2
	characterNames := GetCharacterNames()
	characterNames = %characterNames% 

	;On va vérifier si le timer setting qu'on a besoin est disponible
	ifexist, %A_ScriptDir%\config.ini
	{
        
		IniRead,value,%A_ScriptDir%\config.ini,Timers, SkipMin
		if(value == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, SkipMin
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, SkipMin
		}

		IniRead,value,%A_ScriptDir%\config.ini,Timers, SkipMax
		if(value == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, SkipMax
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, SkipMax
		}
        
	}


	IniRead,SkipMinTimer,%A_ScriptDir%\config.ini,Timers, SkipMin
	IniRead,SkipMaxTimer,%A_ScriptDir%\config.ini,Timers, SkipMax
	Loop, Parse, characterNames, "|"
	{
			
			
		if(WinExist(A_LoopField)){
		
			
			;A rajouter plus tard, récupérer le raccourcie depuis la configuration
			IniRead,skipMyTurnShortcut,%A_ScriptDir%\config.ini,Shortcut, SkipMyTurn
			if(skipMyTurnShortcut == "ERROR"){
				IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, SkipMyTurn
				IniWrite,%value%,%A_ScriptDir%\config.ini,Shortcut, SkipMyTurn
				IniRead,skipMyTurnShortcut,%A_ScriptDir%\config.ini,Shortcut, SkipMyTurn
			}

			ControlSend, ahk_parent, {%skipMyTurnShortcut%}, %A_LoopField%
			
		}
		Random, timerValue, SkipMinTimer, SkipMaxTimer
		Sleep timerValue

	}



}
ReloadGui:
	WinGetPos, xPos,yPos,wPos,hPos
	MainWindowsX :=xPos 
	MainWindowsY :=yPos
	Gui, Main:Destroy
	;MsgBox , stop
	goto start
	
	
	return







SelectCharacter(){
	;TempLocationForCharacter = %A_Temp%\DofusMultiAccountTools\Characters\Lesipe.png
	IndexOfCharacter = 0
	Loop, Parse, A_GuiControl, _,
	{
		if (A_Index == 2){
			IndexOfCharacter = %A_LoopField%
		}
	}
	if(IndexOfCharacter == 0){
		;Si l'index n'est pas trouvé
		return
	}
	SetTitleMatchMode 2
	characterNames := GetCharacterDetectedInGame()
	characterNames = %characterNames%  
	Loop, Parse, characterNames, "|"
	{
		if(A_Index == IndexOfCharacter ){
			if (WinExist(A_LoopField)){
				WinActivate
			}
		}
	}
	
	
	return
}
;Si jamais la position pour accepter les invitations n'ai pas configuré
			

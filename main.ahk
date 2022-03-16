#include %A_ScriptDir%\CommonFunction.ahk
#include %A_ScriptDir%\AccountManagment.ahk
#include %A_ScriptDir%\AdvancedOptions.ahk


; Chargement des chemins d'image utilisées
dofus_icon_imageLocation = %A_ScriptDir%\images\dofus_icon.png
group_icon_imageLocation = %A_ScriptDir%\images\group_icon.png
ready_fight_imageLocation = %A_ScriptDir%\images\ready_fight.png
join_fight_icon_imageLocation = %A_ScriptDir%\images\join_fight_icon.png
Gui, Main:New, +Resize -MaximizeBox

Gui, Main:Add, Button, x12 y19 w110 h30 gAccountManagment , Personnages
Gui, Main:Add, Button, x150 y19 w110 h30 gAdvancedOptionsGui , Options avancées
Gui, Main:Add, GroupBox, x22 y299 w150 h100 , Options rapide
Gui, Main:Add, CheckBox, disabled x52 y329 w80 h20 , Follow auto
;Gui, Main:Add, Button,disabled x100 y180 w70 h40 , PERSONNAGE2
;Gui, Main:Add, Button,hide x22 y180 w70 h40 , PERSONNAGE1START
;Gui, Main:Add, Button,disabled x178 y180 w70 h40 , PERSONNAGE3
;Gui, Main:Add, Button,disabled x22 y240 w70 h40 , PERSONNAGE4
;Gui, Main:Add, Button, x180 y77 w75 h75 gGroupCharacters gGroupCharacters , GROUPER
;Gui, Main:Add, Button,disabled x22 y179 w100 h40 , PRET
Gui, Main:Add, CheckBox, disabled x52 y359 w90 h30 , Mode combat
Gui, Add, Picture, x180 y330 w50 h40 gDetectAndShowCharacterBox, %dofus_icon_imageLocation%
Gui, Add, Picture, x180 y77 w75 h75 gGroupCharacters, %group_icon_imageLocation%
Gui, Add, Picture, x100 y80 w70 h70, %join_fight_icon_imageLocation%
Gui, Add, Picture, x20 y80 w70 h70, %ready_fight_imageLocation%

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

Gui, Main:+AlwaysOnTop
Gui, Main:Show,x500 y361 w269 h454 , DofusMultiAccountTool

OnMessage(0x200, "WM_MOUSEMOVE")
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
			MsgBox "Votre résolution actuelle n'est pas supporté pour pouvoir utiliser la fonctionnalité de Groupe, veuillez envoyer un message au support pour que nous puissions ajouter votre résolution au programme."
			return
		}

		TextEncrypt := value
		
		; Text récupéré
		MsgBox, "C'est la premiere fois que vous utilisez la fonctionnalite Groupe. Nous allons effectue des reglages automatiquement une fois que vous aurez appuye sur le bouton Ok. `n N'oubliez pas de réinitialiser vos positions d'interface pour chacun de vos personnages avant de continuer. (Option/Interface/Reinitialiser les positions d'interface)"

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

DetectAndShowCharacterBox(){
		global
		xaxe:=100
		yaxe:=50
		width:=70
		height:=40




	characterNames := GetCharacterNames()
	characterNames = %characterNames%  
	Gui, Main:Add, Button,hide x22 y180 w0 h0 ; Permet de définir le début où sera positionné les boutons
	GUI, Main:Margin, 22,180
	i := 1
	Loop, Parse, characterNames, "|"
	{
		;GUI, Add, Text, Section xm ym w52 h52
		
		
		if(i < 4)
			GUI, Main:Add, Button, X+5 w70 h40 gSelectCharacter, % A_LoopField
		if(i ==4)
			;GUI, Main:Add, Button, xm+10 ym+10 w10 h0, Section
			GUI, Main:Add, Button, ym+60 xm+5 w70 h40 gSelectCharacter , % A_LoopField
		
		if(i > 4)
			GUI, Main:Add, Button,X+5 w70 h40 gSelectCharacter , % A_LoopField
			

		i := i+1


		CharacterSelect_%A_Index%: 
		CurrentCharacterSelect = %A_LoopField%
	}

	



	return
}

SelectCharacter:
 	;MsgBox, %A_GuiControl%
	SetTitleMatchMode 2
	if (WinExist(A_GuiControl)){
		WinActivate
	}
	return
;Si jamais la position pour accepter les invitations n'ai pas configuré
			
#include %A_ScriptDir%\CommonFunction.ahk
#include %A_ScriptDir%\AccountManagment.ahk
#include %A_ScriptDir%\AdvancedOptions.ahk


Gui, Main:New, +Resize -MaximizeBox

Gui, Main:Add, Button, x12 y19 w110 h30 gAccountManagment , Personnages
Gui, Main:Add, Button, x150 y19 w110 h30 gAdvancedOptionsGui , Options avancées
Gui, Main:Add, GroupBox, x22 y299 w150 h100 , Options rapide
Gui, Main:Add, CheckBox, x52 y329 w80 h20 , Follow auto
Gui, Main:Add, Button, x22 y119 w100 h40 , REJOINDRE COMBAT
Gui, Main:Add, Button, x132 y119 w90 h40 gGroupCharacters , GROUPER
Gui, Main:Add, Button, x22 y179 w100 h40 , PRET
Gui, Main:Add, CheckBox, x52 y359 w90 h30 , Mode combat


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


Gui, Main:Show,x500 y361 w269 h454, DofusMultiAccountTool

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

	ifexist, %A_ScriptDir%\CharacterConfig.conf
		{
			final_string := ""
			Fileread, Content, %A_ScriptDir%\CharacterConfig.conf
			Loop, parse, Content, `n, `r
			{
				StringSplit, i_, A_LoopField, `t
				final_string .= i_1
				final_string .= "|"
			}
			final_string:=SubStr(final_string, 1, StrLen(final_string)-1)
			return final_string
		
		}
	return ""



}

GroupCharacters(){
	characterNames := GetCharacterNames()
	characterNames = %characterNames%  
	
	if !(List(characterNames,2)){
		;Si il n'y a pas au moins 2 personnages, alors on arrête
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
		MsgBox, "C'est la première fois que vous utilisez la fonctionnalité Groupe. Ne toucher à rien pendant les prochaines secondes, nous allons automatiquement s'occuper de detecter la position de votre bouton Accepter."

	}



	SetTitleMatchMode 2
	if(WinExist(groupChefCharacter)){

		WinActivate

		Loop, Parse, characterNames, "|"
			{
				;Pour chaque personnage qui n'est pas le chef de groupe
				if(A_LoopField == groupChefCharacter )
					Continue
				; On va les inviter dans le groupe après avoir focus la zone de tchat du personnage en question  
				

				
				
				Send {Space}
				send {Ctrl Down}a{Ctrl Up}
				send {BackSpace}
				; On envoie la commande d'invitation pour chaque autre personnage
				Send /invite %A_LoopField%
				Sleep 200
				Send {Enter}

				IniRead, MinvalueTimer, %A_ScriptDir%\config.ini,Timers, GroupMin
				IniRead, MaxValueTimer, %A_ScriptDir%\config.ini,Timers, GroupMax
				Random, timerValue, MinvalueTimer, MaxValueTimer

				Sleep timerValue
			}
			; A ce stade, tout les personnages ont été invités
			; On va à présent accepter les invitations

			Loop, Parse, characterNames, "|"
			{
				;Pour chaque personnage qui n'est pas le chef de groupe
				if(A_LoopField == groupChefCharacter )
					Continue
				
				;On focus
				if(WinExist(A_LoopField)){
					WinActivate

					
					t1:=A_TickCount, X:=Y:=""
					if (TextEncrypt){
						sleep 1000
						try_nm := 1
						while(try_num < 5){
							Text := TextEncrypt
							ok:=FindText(X, Y, A_ScreenWidth, 0, -1, A_ScreenHeight, 0, 0, Text)
							MsgBox, %X%,%Y%, %Text%
							if(ok.Length())
							{
								;Le bouton accepté a été trouvé
								;On sauvegarde la position trouvé
								IniWrite, %X%, %A_ScriptDir%\config.ini, Position, AcceptGroupButtonX
								IniWrite, %Y%, %A_ScriptDir%\config.ini, Position, AcceptGroupButtonY
								TextEncrypt := ""
								FindText().Click(X, Y, "L")
								try_nm := 10
							}else{
								try_nm := try_nm + 1
							}

								
						}
						
						
					}
					else{
						;On connait les coordonnées
						IniRead, PositionAcceptGroupX, %A_ScriptDir%\config.ini,Position, AcceptGroupButtonX
						IniRead, PositionAcceptGroupY,%A_ScriptDir%\config.ini,Position, AcceptGroupButtonY
						FindText().Click(PositionAcceptGroupX, PositionAcceptGroupY, "L")
					}


				}
				
				

			}



	}
	

	return ""

}


;Si jamais la position pour accepter les invitations n'ai pas configuré
			
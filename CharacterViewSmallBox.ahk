#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

CreateShowCharacterSmallBox(){
    global

		xaxe:=100
		yaxe:=50
		width:=70
		height:=40
	
	Gui, CharacterSmallBox:New, -Resize +border
    Gui, +AlwaysOnTop -Caption 
	
	allCharacterFocus := FocusCharactersPath.GetAll()
	allCharacters :=  CharactersPath.GetAll()
	Loop, Parse, allCharacterFocus, | 
	{
		GuiControl,Hide, %A_LoopField%
	}
	Loop, Parse, allCharacters, | 
	{
		GuiControl,Hide, %A_LoopField%
	}

    FocusCharactersPath.SetList("")
	CharactersPath.SetList("")

	characterNames := GetCharacterDetectedInGame()
	characterNames = %characterNames%  
	;Gui, CharacterSmallBox:Add, Button,hide x14 y180 w0 h0 ; Permet de définir le début où sera positionné les boutons
	GUI, CharacterSmallBox:Margin, -2,180
    ;Gui,Color, b6be7f
    
	i := 1
	listCharacterNotDetect := ""
	Gui, CharacterSmallBox:Add, Button,Y+5 w0 h0 Disabled, Button hide
	GuiControl,Hide,Button hide
	Loop, Parse, characterNames, "|"
	{
		
		;GUI, Add, Text, Section xm ym w52 h52
		if(A_LoopField == "")
			Continue
		
		IniRead, classCharacter,%A_ScriptDir%\config.ini,ClassOfCharacter, %A_LoopField%
		sex := map_sexe_name.Get(SETTING.getSetting("SexOfCharacter",A_LoopField))
		sex := map_sexe_name.Get(sex) ; Deuxieme fois au cas où sex est vide
		;Récupération du nombre de fichiers
		CountItems := 0
		Loop,  %A_ScriptDir%\images\characters_bank_images\%classCharacter%\*.*
		{
			CountItems++
		}
		;MsgBox, % CountItems
		folder = %A_ScriptDir%\images\characters_bank_images\%classCharacter%\%sex%
		listFiles := list_files(folder)

		TempLocationForCharacter = %A_Temp%\OcreCompanion\Characters\
		
		fileSelectToShow := get_element_in_list_file(1,listFiles) ; Pour le moment on prend tjrs la première image
		characterName := StrReplace(fileSelectToShow, ".png")
		CharacterFocusNameFile := StrReplace(fileSelectToShow, ".png", "_focus") ; On récupére l'image focus de ce fichier
		
		pictureFocusToTempPath = %TempLocationForCharacter%%A_LoopField%_%loopCharacterCreationRun%_focus.png ; Sera le chemin TempPath\NomDuPersonnage.png
		fullPathPictureClass = %A_ScriptDir%\images\characters_bank_images\%classCharacter%\%sex%\%fileSelectToShow%
		pictureToTempPath = %TempLocationForCharacter%%A_LoopField%_%loopCharacterCreationRun%.png
		fullPathPictureFocus := StrReplace(fullPathPictureClass, ".png", "_focus.png")
		;MsgBox, %fullPathPictureFocus%
		FileCopy, %fullPathPictureFocus%,%pictureFocusToTempPath%, 1 ; On va enregister sous le nomDuPersonnage
		FileCopy, %fullPathPictureClass%, %pictureToTempPath%, 1
		;classCharacterImageLocation = %A_ScriptDir%\images\%classCharacter%.png
		;MsgBox, %classCharacterImageLocation%
		;MsgBox, %classCharacter%
		
		;fullPathPicture = %A_ScriptDir%\images\characters_bank_images\%classCharacter%\%fileSelectToShow%
		;MsgBox, %pictureToTempPath%, %fullPathPictureClass%
		
		if(i < 9){
			;GUI, Main:Add, Button, X+5 w70 h40 gSelectCharacter, % A_LoopField
			Gui,CharacterSmallBox:Add, Picture, X+5 w55 h55 vCharacterSmallPic_%A_Index%_%loopCharacterCreationRun%, %pictureToTempPath%
			Gui,CharacterSmallBox:Add, Picture, XP w60 h60 , %pictureFocusToTempPath%
			GuiControl,+gSelectCharacter,CharacterSmallPic_%A_Index%_%loopCharacterCreationRun%
			
		}

		i := i+1
		GuiControl, CharacterSmallBox:Hide, %pictureFocusToTempPath%
		FocusCharactersPath.Add(pictureFocusToTempPath)
		CharactersPath.Add(pictureToTempPath)

		
	}
	GUI, CharacterSmallBox:Margin, 2,2
	moveIconImage = %A_ScriptDir%\images\move-icon.png
	closeIconImage = %A_ScriptDir%\images\close_icon_nm.png
	Gui,CharacterSmallBox:Add, Picture, X+10 w19 h19 vCloseSmallCharacterBox, %closeIconImage%
	GuiControl,+gCloseSmallCharacterBox,CloseSmallCharacterBox
    Gui,CharacterSmallBox:Add, Picture, XP-2 Y+10 w25 h25 vMoveSmallCharacterBoxImage , %moveIconImage%
	GuiControl,+gMoveSmallCharacterBoxImage,MoveSmallCharacterBoxImage
    ;Gui, Color, Color_Transparent
    
    Gui, Color, 3e3e3e

	;; Verifier si il y'a des position sauvegardées
	IniRead, posX, %A_ScriptDir%\config.ini, PositionSmallBoxCharacter, X
	IniRead, posY, %A_ScriptDir%\config.ini, PositionSmallBoxCharacter, Y
	if(posX != "ERROR" && posY != "ERROR" && posX != "" && posY != "" ){
		Gui, CharacterSmallBox:Show,x%posX% y%posY%, %smallBoxCharacterWindowTitle%
	}
	else{
		Gui, CharacterSmallBox:Show,, %smallBoxCharacterWindowTitle%
	}

	
    ;WinSet, Transparent, 245, test
    ;WinSet,Transparent, Off, test
    ;WinSet, TransColor, White, Transparent GUI
	return
}
CloseSmallCharacterBox(){
	Gui, CharacterSmallBox:Destroy
}
MoveSmallCharacterBoxImage(){
	; permet de l'enregistre en tant que control gui
	return
}
VerifyPositionSmallCharacterBox(){
	global
	; On vérifie qu'il s'agit de la fenêtre principale du Script
  	WinGetTitle, title, A
	if(title != smallBoxCharacterWindowTitle){
		return
	}
		WinGetPos, x, y, w, h, %smallBoxCharacterWindowTitle% ; récupérer la position actuelle de la fenêtre active
		IniRead, posX, %A_ScriptDir%\config.ini, PositionSmallBoxCharacter, X
		IniRead, posY, %A_ScriptDir%\config.ini, PositionSmallBoxCharacter, Y
		if(posX == x && posY == y){
			return ; Pas besoin de sauvegarder inutilement
		}
		;Verifier que les nouvelles positions ne soient pas vide
		if(x =="" or y == ""){
			return
		}
		; On sauvegarde la position de la fenêtre
		IniWrite, %x%, %A_ScriptDir%\config.ini, PositionSmallBoxCharacter, X
		IniWrite, %y%, %A_ScriptDir%\config.ini, PositionSmallBoxCharacter, Y
}

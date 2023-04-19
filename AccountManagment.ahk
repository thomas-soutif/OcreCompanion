#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

AccountManagment(){
	global
	Gui, AccountManagment:New,+Resize -MaximizeBox
	

	Gui, Font, S8 Normal
	;Chargement de la liste des noms de personnage
	IniRead, listAllCharacterClass, %A_ScriptDir%\defaultConfig\defaultConfig.ini,AllClassCharacter, value

	; Chargement des chemins d'image utilisées
	arrow_up_image = %A_ScriptDir%\images\up_arrow.png
	arrow_down_image = %A_ScriptDir%\images\down_arrow.png

	Gui, Add, ListView, x152 y20 w480 h290  LV0x1 vListViewContent 
	Gui, Add, Text, x12 y20 w130 h20, Pseudo du personnage
	Gui, Add, Edit, x12 y40 w130 h20 vPseudo,
	Gui, Add, Text, x12 y80 w130 h20, Classe du personnage
	Gui, Add, DropDownList,  vClassCharacterChoice , %listAllCharacterClass%
	Gui, Add, Button, x12 y170 w130 h40 gAddCharacter, Add
	Gui, Add, Button, x12 y220 w130 h40 gRemoveCharacter, Remove
	Gui, Add, Button, x12 y330 w130 h40 gSaveCharacter, Sauvegarder
	Gui, Add, Picture, x40 y280 w35 h25 gMooveCharacterUp, %arrow_up_image%
	Gui, Add, Picture, x80 y280 w35 h25 gMooveCharacterDown, %arrow_down_image%
	LV_InsertCol(1, 100, "Personnage")
	LV_InsertCol(2, 100, "Classe")

	IniRead, CharacterNameList, %A_ScriptDir%\config.ini, CharactersList, listCharacters
	if (CharacterNameList == "ERROR"){
		IniWrite, "", %A_ScriptDir%\config.ini, CharactersList, listCharacters
		IniRead, CharacterNameList, %A_ScriptDir%\config.ini, CharactersList, listCharacters
	}
	Loop, Parse, CharacterNameList, "|"
        {
			IniRead, ClassCharacter, %A_ScriptDir%\config.ini,ClassOfCharacter,%A_LoopField%
			LV_Add("",A_LoopField,ClassCharacter)
		}



	Gui, +AlwaysOnTop
	Gui, Show, w664 h379, Gestion de vos personnages - Ocre Companion
	GuiControl, Focus, Name
	return

	AddCharacter:
		Gui, Submit, NoHide
		LV_Add("", Pseudo,ClassCharacterChoice)
		return

	RemoveCharacter:
		LV_Delete(LV_GetNext())
		return
	
	SaveCharacter:
	filePathDestination =%A_ScriptDir%\CharacterConfig.conf
	ControlGet, ListViewContent, List,, SysListView321
	if !(ListViewContent = Content) ; to prevent storing data when nothing has changed
	{

		Filedelete,%filePathDestination%
		;FileMove, %A_ScriptDir%\CharacterConfig.conf, %A_ScriptDir%\CharacterConfig_%a_now%.conf
		sleep 200
		only_one_charact = True
		Loop, parse, ListViewContent, `n, `r
		{	
			StringSplit, i_, A_LoopField, `t
			if %A_Index% ==1:
				listCharacters = %i_1%|
			else{
				listCharacters = %listCharacters%%i_1%|
				only_one_charact = False
			}
				
			IniWrite, %i_2%, %A_ScriptDir%\config.ini, ClassOfCharacter, %i_1%
		}
		if(only_one_charact == "False"){
			listCharacters:=SubStr(listCharacters,1,StrLen(listCharacters)-1)
		}
		IniWrite, %listCharacters%, %A_ScriptDir%\config.ini, CharactersList, listCharacters
	}
		listCharacters := ""
		CleanConfigOfUselessSettingInAccountManagement()
		Gui, Destroy
		return

	MooveCharacterUp:

	IndexElement := LV_GetNext()
	IndexPrevious := IndexElement - 1
	if (IndexPrevious < 1 || IndexElement == 0){
		Return
	}
	; Échanger les positions des deux éléments
	LV_GetText(TempCharacterNameCurrent, IndexElement, 1)
	LV_GetText(TempClassNameCurrent, IndexElement, 2)

	LV_GetText(TempCharacterNamePrevious, IndexPrevious, 1)
	LV_GetText(TempClassNamePrevious, IndexPrevious, 2)

	LV_Modify(IndexElement, 0, TempCharacterNamePrevious, TempClassNamePrevious)
	LV_Modify(IndexPrevious, 0, TempCharacterNameCurrent, TempClassNameCurrent)
	
	
	; Sélectionner l'élément déplacé
	LV_Modify(IndexElement, "-Select")
	LV_Modify(IndexPrevious, "Select")
	Return

	MooveCharacterDown:

	IndexElement := LV_GetNext()
	IndexNext := IndexElement + 1
	if (IndexNext > LV_GetCount() || IndexElement == 0){
		Return
	}
	; Échanger les positions des deux éléments
	LV_GetText(TempCharacterNameCurrent, IndexElement, 1)
	LV_GetText(TempClassNameCurrent, IndexElement, 2)

	LV_GetText(TempCharacterNameNext, IndexNext, 1)
	LV_GetText(TempClassNameNext, IndexNext, 2)

	LV_Modify(IndexElement, 0, TempCharacterNameNext, TempClassNameNext)
	LV_Modify(IndexNext, 0, TempCharacterNameCurrent, TempClassNameCurrent)
	
	
	; Sélectionner l'élément déplacé
	LV_Modify(IndexElement, "-Select")
	LV_Modify(IndexNext, "Select")

	Return

}



CleanConfigOfUselessSettingInAccountManagement(){

	;Clean the Character Class Name
	dict := SETTING.GetAllSettingOfSection("ClassOfCharacter")
	
	characterNames := GetCharacterNames()
	characterNames = %characterNames% 
	listCharacter :=  New ListCustom
	listCharacter.SetList(characterNames)
	dictKeys := dict.GetKeysName()
	dictKeys := dictKeys.GetAll()
	Loop,Parse,dictKeys, "|"
	{
		if(!listCharacter.find(A_LoopField)){
			;On supprime le nom qui n'existe plus
			SETTING.DeleteSetting("ClassOfCharacter",A_LoopField)
		}
	}
}
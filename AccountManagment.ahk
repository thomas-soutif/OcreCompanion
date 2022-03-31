#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

AccountManagment(){
	global
	Gui, AccountManagment:New,+Resize -MaximizeBox
	

	
	;Chargement de la liste des noms de personnage
	IniRead, listAllCharacterClass, %A_ScriptDir%\defaultConfig\defaultConfig.ini,AllClassCharacter, value

	Gui, Add, ListView, x152 y20 w480 h290  LV0x1 vListViewContent 
	Gui, Add, Text, x12 y20 w130 h20, Pseudo du personnage
	Gui, Add, Edit, x12 y40 w130 h20 vPseudo,
	Gui, Add, Text, x12 y80 w130 h20, Classe du personnage
	Gui, Add, DropDownList,  vClassCharacterChoice , %listAllCharacterClass%
	Gui, Add, Button, x12 y170 w130 h40 gAddCharacter, Add
	Gui, Add, Button, x12 y220 w130 h40 gRemoveCharacter, Remove
	Gui, Add, Button, x12 y330 w130 h40 gSaveCharacter, Sauvegarder
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
	Gui, Show, w664 h379, Gestion de vos personnages - DofusMultiAccountTool
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
	
		Gui, Hide
		return

}
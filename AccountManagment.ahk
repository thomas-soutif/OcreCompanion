#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

AccountManagment(){
	global
	Gui, AccountManagment:New,+Resize -MaximizeBox
	
	Gui, Add, ListView, x152 y20 w480 h290  LV0x1 vListViewContent
	Gui, Add, Edit, x12 y40 w130 h20 vPseudo, 
	Gui, Add, Text, x12 y20 w130 h20, Pseudo du personnage
	Gui, Add, Button, x12 y170 w130 h40 gAddCharacter, Add
	Gui, Add, Button, x12 y220 w130 h40 gRemoveCharacter, Remove
	Gui, Add, Button, x12 y330 w130 h40 gSaveCharacter, Sauvegarder
	LV_InsertCol(1, 100, "Personnage")



	ifexist, %A_ScriptDir%\CharacterConfig.conf
	{
		Fileread, Content, %A_ScriptDir%\CharacterConfig.conf
		Loop, parse, Content, `n, `r
		{
			StringSplit, i_, A_LoopField, `t
			LV_Add("", i_1)
		}
	
	}




	Gui, Show, w664 h379, Gestion de vos personnages - DofusMultiAccountTool
	GuiControl, Focus, Name
	return

	AddCharacter:
		Gui, Submit, NoHide
		LV_Add("", Pseudo)
		return

	RemoveCharacter:
		LV_Delete(LV_GetNext())
		return
	
	SaveCharacter:
	ControlGet, ListViewContent, List,, SysListView321
	if !(ListViewContent = Content) ; to prevent storing data when nothing has changed
	{
		Filedelete, %A_ScriptDir%\CharacterConfig.conf
		;FileMove, %A_ScriptDir%\CharacterConfig.conf, %A_ScriptDir%\CharacterConfig_%a_now%.conf
		sleep 1000
		Fileappend, %ListViewContent%, %A_ScriptDir%\CharacterConfig.conf, UTF-8
	}
		Gui, Hide
		return

}
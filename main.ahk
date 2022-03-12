
Gui, Main:New, +Resize -MaximizeBox, Test
Gui, Main:Add, Button, w90 y50 gAccountManagment Default, Gestion des comptes




Gui, Main:Show,x500 x1000 w1000 h500

Return

GuiEscape:
GuiClose:
Quitter:
ExitApp



AccountManagment:
{

     Gui, AccountManagment:New,+Resize -MaximizeBox
	
	Gui, Add, ListView, x152 y20 w480 h290  LV0x1
	Gui, Add, Edit, x12 y40 w130 h20 vPseudo, 
	Gui, Add, Text, x12 y20 w130 h20, Pseudo du personnage
	Gui, Add, Button, x12 y170 w130 h40 gAdd, Add
	Gui, Add, Button, x12 y220 w130 h40 gRemove, Remove

	LV_InsertCol(1, 100, "Personnage")

	Gui, Show, w664 h379, Untitled GUI
	GuiControl, Focus, Name
	return
    
	



    SaveAccountConfig:
    {

        
        MsgBox, Test
        return



    }

	Add:
		Gui, Submit, NoHide
		LV_Add("", Pseudo)
		return

	Remove:
		LV_Delete(LV_GetNext())
		return

}





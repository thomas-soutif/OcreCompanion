
Gui, Main:New, +Resize -MaximizeBox, Test
Gui, Main:Add, Button, w90 y50 gAccountManagment Default, Gestion des comptes






Gui, Main:Show,x350 y100 w300 h200

Return

GuiEscape:
GuiClose:
Quitter:
ExitApp



AccountManagment:
{

    Gui, AccountManagment:New,+Resize -MaximizeBox
    Gui, AccountManagment:Add, Text, tBold cBlue x30 y30,Compte principal
    Gui, AccountManagment:Add, Text, tBold cBlack x60 y70,Pseudo : 
    Gui, AccountManagment:Add, Edit, x100 y70 vName,
    Gui, AccountManagment:Add, Button, x30 y150 gSaveAccountConfig Default, Sauvegarder


    


    Gui AccountManagment:Show,x350 y100 w300 h200
    

    SaveAccountConfig:
    {

        
        
        return



    }

}



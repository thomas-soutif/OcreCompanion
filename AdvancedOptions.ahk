#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


AdvancedOptionsGui(){
    global
    Gui, AdvancedOptions:New,+Resize -MaximizeBox

    Gui, Add, GroupBox, x22 y19 w210 h160 , Timer
    Gui, Font, S8 CTeal, Verdana
    Gui, Add, Text, x132 y29 w30 h20 , Min
    Gui, Add, Text, x182 y29 w30 h20 , Max

    Gui, Font, S8 C, Verdana
    Gui, Add, Text, x32 y50 w40 h20 , Suivre
    Gui, Add, Edit, x122 y50 w50 h20 vFollowMin
    Gui, Add, Edit, x172 y50 w50 h20 vFollowMax
    
    
    Gui, Add, Text, x32 y80 w80 h20 , Grouper
    Gui, Add, Edit, x122 y80 w50 h20 vGroupMin
    Gui, Add, Edit, x172 y80 w50 h20 vGroupMax

    Gui, Add, Text, x32 y110 w80 h20 , Passer
    Gui, Add, Edit, x122 y110 w50 h20
    Gui, Add, Edit, x172 y110 w50 h20

    Gui, Add, Text, x32 y140 w80 h30 , Rejoindre (fight)
    Gui, Add, Edit, x122 y140 w50 h20
    Gui, Add, Edit, x172 y140 w50 h20

    Gui, Add, Button, x22 y199 w100 h30 gSaveAdvancedOptions , Sauvegarder
    Gui, Show, w664 h379, Options avancees - DofusMultiAccountTool

    return





    SaveAdvancedOptions:
        return
    

}
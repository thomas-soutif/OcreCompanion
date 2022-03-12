#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


AdvancedOptionsGui(){

    Gui, AdvancedOptions:New,+Resize -MaximizeBox

    Gui, Add, GroupBox, x22 y19 w210 h160 , Timer
    Gui, Add, Edit, x172 y39 w50 h20 , Edit
    Gui, Add, Edit, x122 y39 w50 h20 , Edit
    Gui, Add, Text, x32 y39 w40 h20 , Suivre
    Gui, Add, Text, x32 y69 w80 h20 , Grouper
    Gui, Add, Text, x32 y99 w80 h20 , Passer
    Gui, Add, Text, x32 y129 w80 h20 , Rejoindre (fight)
    Gui, Add, Edit, x122 y69 w50 h20 , Edit
    Gui, Add, Edit, x122 y99 w50 h20 , Edit
    Gui, Add, Edit, x122 y129 w50 h20 , Edit
    Gui, Add, Edit, x172 y69 w50 h20 , Edit
    Gui, Add, Edit, x172 y99 w50 h20 , Edit
    Gui, Add, Edit, x172 y129 w50 h20 , Edit

    Gui, Show, w664 h379, Options avancees - DofusMultiAccountTool

    return

}
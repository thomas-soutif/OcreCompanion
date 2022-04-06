#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


AdvancedOptionsGui(){
    global
    Gui, AdvancedOptions:New,+Resize -MaximizeBox
    allVNameTimerOption = FollowMin|FollowMax|GroupMin|GroupMax|SkipMin|SkipMax|JoinFightMin|JoinFightMax
    allVNamePositionOption = AcceptGroupButtonX|AcceptGroupButtonY|JoinFightButtonX|JoinFightButtonY
    allVNameAccessibility = ConfirmCharactersAllReady
    ;Chargement des paramètres

    ifexist, %A_ScriptDir%\config.ini
	{
        Loop, Parse, allVNameTimerOption, "|"
        {
            IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Timers, %A_LoopField%
             if(%A_LoopField% == "ERROR"){
                IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, %A_LoopField%
                IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, %A_LoopField%
                IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Timers, %A_LoopField%
            }
        }

         Loop, Parse, allVNamePositionOption, "|"
        {
            IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Position, %A_LoopField%
             if(%A_LoopField% == "ERROR"){
                IniWrite, "", %A_ScriptDir%\config.ini, Position, %A_LoopField%
                IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Position, %A_LoopField%
            }
        }

        Loop, Parse, allVNameAccessibility, "|"
        {
            IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Accessibility, %A_LoopField%
             if(%A_LoopField% == "ERROR"){
                IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Accessibility, %A_LoopField%
                IniWrite, %value%, %A_ScriptDir%\config.ini, Accessibility, %A_LoopField%
                IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Accessibility, %A_LoopField%
            }
        }

	}


    TextConfirmCharactersAllReady := "Confirmer avant de mettre Prêt tout les persos"

    
Gui, Add, GroupBox, x22 y19 w210 h160 , Timer
Gui, Font, S8 CTeal, Verdana
Gui, Add, Text, x132 y29 w30 h20 , Min
Gui, Add, Text, x182 y29 w30 h20 , Max
Gui, Font, S8 C, Verdana
Gui, Add, Text, x32 y50 w40 h20 , Suivre
Gui, Add, Edit, x122 y50 w50 h20 vFollowMin, %FollowMin%
Gui, Add, Edit, x172 y50 w50 h20 vFollowMax, %FollowMax%
Gui, Add, Text, x32 y80 w80 h20 , Grouper
Gui, Add, Edit, x122 y80 w50 h20 vGroupMin, %GroupMin%
Gui, Add, Edit, x172 y80 w50 h20 vGroupMax, %GroupMax%
Gui, Add, Text, x32 y110 w80 h20 , Passer
Gui, Add, Edit, x122 y110 w50 h20 vSkipMin, %SkipMin%
Gui, Add, Edit, x172 y110 w50 h20 vSkipMax, %SkipMax%
Gui, Add, Text, x32 y140 w80 h30 , Rejoindre (fight)
Gui, Add, Edit, x122 y140 w50 h20 vJoinFightMin, %JoinFightMin%
Gui, Add, Edit, x172 y140 w50 h20 vJoinFightMax, %JoinFightMax%
Gui, Add, Button, x32 y309 w100 h40 gSaveAdvancedOptions, Sauvegarder
Gui, Add, GroupBox, x262 y19 w210 h160 , Position
Gui, Add, Text, x352 y29 w30 h20 , X
Gui, Add, Text, x402 y29 w30 h20 , Y
Gui, Add, Edit, x342 y49 w50 h20 vAcceptGroupButtonX, %AcceptGroupButtonX%
Gui, Add, Edit, x392 y49 w50 h20 vAcceptGroupButtonY, %AcceptGroupButtonY%
Gui, Add, Edit, x342 y85 w50 h20 vJoinFightButtonX, %JoinFightButtonX%
Gui, Add, Edit, x392 y85 w50 h20 vJoinFightButtonY, %JoinFightButtonY%
Gui, Add, Text, x272 y49 w60 h30 , Accepter (Groupe)
Gui, Add, Text, x272 y85 w60 h30 , Rejoindre (Fight)
Gui, Add, Button, x262 y179 w210 h30 gDetectAutomatically, Detecter automatiquement
Gui, Add, GroupBox, x492 y19 w180 h160 , Accessibilité
Gui, Add, Edit, x572 y69 w-594 h-200 , Edit
Gui, Add, CheckBox, x502 y49 w160 h40 vConfirmCharactersAllReady ,%TextConfirmCharactersAllReady%
Gui, Add, Button, x22 y179 w100 h40 , Reset Default
;Gui, Add, Button, x492 y179 w100 h40 , Reset Default
Gui, Add, GroupBox, x262 y219 w210 h160 , Follow auto position
Gui, Add, Button, x262 y379 w210 h30 , Detecter automatiquement
Gui, Add, Text, x272 y259 w60 h20 , Haut
Gui, Add, Text, x272 y289 w60 h20 , Bas
Gui, Add, Text, x272 y319 w60 h20 , Gauche
Gui, Add, Text, x362 y239 w30 h20 , X
Gui, Add, Text, x412 y239 w30 h20 , Y
Gui, Add, Edit, x352 y259 w50 h20 , 
Gui, Add, Text, x272 y349 w60 h20 , Droite
Gui, Add, Edit, x402 y259 w50 h20 , 
Gui, Add, Edit, x352 y289 w50 h20 , 
Gui, Add, Edit, x402 y289 w50 h20 , 
Gui, Add, Edit, x352 y319 w50 h20 , 
Gui, Add, Edit, x402 y319 w50 h20 , 
Gui, Add, Edit, x352 y349 w50 h20 , 
Gui, Add, Edit, x402 y349 w50 h20 , 

if(ConfirmCharactersAllReady == 1){
        GuiControl,, %TextConfirmCharactersAllReady%, 1
        
}else{
    GuiControl,, %TextConfirmCharactersAllReady%, 0
}




    Gui, +AlwaysOnTop
    Gui, Show, w680 h430, Options avancees - DofusMultiAccountTool



    return


    SaveAdvancedOptions:
        Gui, Submit, NoHide
        Loop, Parse, allVNameTimerOption, "|"
        {   
            value := %A_LoopField%
            valueRound := floor(value)
            if !(valueRound == 0)
            {
                IniWrite, %valueRound%, %A_ScriptDir%\config.ini, Timers, %A_LoopField%
            }
            else{
                GuiControl, focus, %A_LoopField%,
                send {Ctrl Down}a{Ctrl Up}
                send {BackSpace}
                IniRead, oldValue, %A_ScriptDir%\config.ini,Timers, %A_LoopField%


                send %oldValue%
               
            }
        }
        Loop, Parse, allVNamePositionOption, "|"
        {   
            value := %A_LoopField%
            valueRound := floor(value)
            if(valueRound == 0)
                IniWrite, "", %A_ScriptDir%\config.ini, Position, %A_LoopField%
            else
                IniWrite, %valueRound%, %A_ScriptDir%\config.ini, Position, %A_LoopField%
            
        }

        Loop, Parse, allVNameAccessibility, "|"
        {   
            value := %A_LoopField%
            if (value == 0 || value == 1)
            {
                IniWrite, %value%, %A_ScriptDir%\config.ini, Accessibility, %A_LoopField%
            }
        }

        Gui, Hide
        return

    ResetDefault:
        Loop, Parse, allVNameTimerOption, "|"
        {
        IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Timers, %A_LoopField%
            IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, %A_LoopField%
            IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, %A_LoopField%
            IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Timers, %A_LoopField%
    
        }
        Gui, Hide
        AdvancedOptionsGui()
        return

    DetectAutomatically:
        MsgBox, 4096,Detection Automatique, "Au prochain lancement d'une fonctionnalité, le programme essayera de detecter les positions des différents éléments et le sauvegarder.`n Vous pourrez toujours le modifier par la suite"
        Loop, Parse, allVNamePositionOption, "|"
        {
            GuiControl, focus, %A_LoopField%,
            send {Ctrl Down}a{Ctrl Up}
            send {BackSpace}
            IniWrite, "", %A_ScriptDir%\config.ini, Position, %A_LoopField%
            GuiControl, focus, %DetectAutomatically%
        }
        return
}
       
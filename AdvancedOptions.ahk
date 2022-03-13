#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


AdvancedOptionsGui(){
    global
    Gui, AdvancedOptions:New,+Resize -MaximizeBox
    allVName = FollowMin|FollowMax|GroupMin|GroupMax|SkipMin|SkipMax|JoinFightMin|JoinFightMax
    ;Chargement des paramètres

    ifexist, %A_ScriptDir%\config.ini
	{
        Loop, Parse, allVName, "|"
        {
            IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Timers, %A_LoopField%
             if(%A_LoopField% == "ERROR"){
                IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, %A_LoopField%
                IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, %A_LoopField%
                IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Timers, %A_LoopField%
            }
        }
	}


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

    Gui, Add, Button, x22 y199 w100 h30 gSaveAdvancedOptions , Sauvegarder


    



    Gui, Show, w664 h379, Options avancees - DofusMultiAccountTool

    return


   
 test:
        ;^!Backspace::
           ; KeyWait, Alt
            ;Send ^{Delete}

    SaveAdvancedOptions:
        Gui, Submit, NoHide
        Loop, Parse, allVName, "|"
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
        Gui, Hide
        return

}
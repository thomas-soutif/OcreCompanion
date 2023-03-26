#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


AdvancedOptionsGui(){
    global
    Gui, AdvancedOptions:New,+Resize -MaximizeBox
    allVNameTimerOption = FollowMin|FollowMax|GroupMin|GroupMax|SkipMin|SkipMax|JoinFightMin|JoinFightMax
    allVNamePositionOption = AcceptGroupButtonX|AcceptGroupButtonY|JoinFightButtonX|JoinFightButtonY
    allVNamePositionFollowAuto = UpDirectionX|UpDirectionY|DownDirectionX|DownDirectionY|LeftDirectionX|LeftDirectionY|RightDirectionX|RightDirectionY
    allVNameAccessibility = ConfirmCharactersAllReady|ShowCharacterSmallBoxStartup
    allVNamePositionResolution = AcceptGroupButtonResolution|JoinFightButtonResolution
    allVNameIllustrationNamePosition = topLeftX|topLeftY|bottomRightX|bottomRightY

    ;Chargement des paramètres

    ifexist, %A_ScriptDir%\config.ini
	{
        Loop, Parse, allVNameTimerOption, "|"
        {
            %A_LoopField% := SETTING.GetSetting("Timers",A_LoopField)
        }

         Loop, Parse, allVNamePositionOption, "|"
        {
             %A_LoopField% := SETTING.GetSetting("Position",A_LoopField)
        }

        Loop, Parse, allVNameAccessibility, "|"
        {
            %A_LoopField% := SETTING.GetSetting("Accessibility",A_LoopField)
        }
        Loop,Parse, allVNamePositionResolution, "|"
        {
            %A_LoopField% := SETTING.GetSetting("PositionResolution",A_LoopField)
        }
        Loop,Parse, allVNameIllustrationNamePosition, "|"
        {
            %A_LoopField% := SETTING.GetSetting("IllustrationNamePosition",A_LoopField)
        }

	}


    TextConfirmCharactersAllReady := "Confirmer avant de mettre Prêt tout les persos"
    TextShowCharacterSmallBoxStartup := "Ouvrir la popup des personnages au démarrage"
Gui, Font, Bold s8    
Gui, Add, GroupBox, x22 y19 w210 h160  , Timer
Gui, Font, Normal s8
Gui, Font,S8 CTeal, Verdana
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
Gui, Font, Bold s8
Gui, Add, GroupBox, x262 y19 w270 h150 , Position
Gui, Font, Normal s8
Gui, Font,S8 CTeal, Verdana
Gui, Add, Text, x352 y29 w30 h20 , X
Gui, Add, Text, x402 y29 w30 h20 , Y
Gui, Font, S8 C, Verdana
Gui, Add, Edit, x342 y49 w50 h20 vAcceptGroupButtonX, %AcceptGroupButtonX%
Gui, Add, Edit, x392 y49 w50 h20 vAcceptGroupButtonY, %AcceptGroupButtonY%
Gui, Add, Text, x448 y52 w72 h20 , (%AcceptGroupButtonResolution%)
Gui, Add, Edit, x342 y85 w50 h20 vJoinFightButtonX, %JoinFightButtonX%
Gui, Add, Edit, x392 y85 w50 h20 vJoinFightButtonY, %JoinFightButtonY%
Gui, Add, Text, x448 y87 w72 h20 , (%JoinFightButtonResolution%)
Gui, Add, Text, x272 y49 w60 h30 , Accepter (Groupe)
Gui, Add, Text, x272 y85 w60 h30 , Rejoindre (Fight)
Gui, Add, Button, x262 y170 w270 h30 gDetectAutomatically, Détecter automatiquement les positions
Gui, Add, Edit, x572 y69 w-594 h-200 , Edit
Gui, Add, Button, x22 y179 w100 h40 gResetDefaultTimerOption , Reset Default
;Gui, Add, Button, x262 y379 w210 h30 disabled, Configurer (pas utilisé)
Gui, Font, Bold s8  
Gui, Add, GroupBox, x542 y19 w180 h150 , Accessibilité
Gui, Font, Normal s8
Gui, Add, CheckBox, x552 y49 w160 h40 vConfirmCharactersAllReady , %TextConfirmCharactersAllReady%
Gui, Add, CheckBox, x552 y+15 w160 h40 vShowCharacterSmallBoxStartup , %TextShowCharacterSmallBoxStartup%
GuiControl,, %TextConfirmCharactersAllReady%, %ConfirmCharactersAllReady%
GuiControl,, %TextShowCharacterSmallBoxStartup%, %ShowCharacterSmallBoxStartup%
Gui, Font, Bold s8
Gui, Add, GroupBox, x262 y219 w270 h150 , Position Illustration (Mode combat)
Gui, Font, Normal s8
Gui, Font,S8 CTeal, Verdana
Gui, Add, Text, x352 y237 w30 h20 , X
Gui, Add, Text, x402 y237 w30 h20 , Y
Gui, Font, S8 C, Verdana
Gui, Add, Text, x272 y257 w60 h30 , Top Left
Gui, Add, Text, x272 y287 w60 h30, Bottom Right
Gui, Add, Edit, x342 y256 w50 h20 vtopLeftX, %topLeftX%
Gui, Add, Edit, x392 y256 w50 h20 vtopLeftY, %topLeftY%
Gui, Add, Edit, x342 y286 w50 h20 vBottomRightX, %bottomRightX%
Gui, Add, Edit, x392 y286 w50 h20 vBottomRightY, %bottomRightY%
Gui, Add, Button, x262 y369 w270 h30 gInstructionsIllustrationFight, Instructions
;Gui, Add, Text, x272 y85 w60 h30 , Rejoindre (Fight)
Gui, +AlwaysOnTop
Gui, AdvancedOptions:Show, w750 h430, Options avancees - DofusMultiAccountTool

GuiClose:
    OnGuiCloseForAdvancedOptions()

return


SaveAdvancedOptions:
    Gui, Submit, NoHide
    Loop, Parse, allVNameTimerOption, "|"
    {   
        value := %A_LoopField%
        valueRound := floor(value)
        if !(valueRound == 0)
        {
            SETTING.setSetting("Timers", A_LoopField, valueRound)
        }
        else{
            GuiControl, focus, %A_LoopField%,
            send {Ctrl Down}a{Ctrl Up}
            send {BackSpace}
             oldValue := SETTING.getSetting("Timers", A_LoopField)

            send %oldValue%
            
        }
    }
    Loop, Parse, allVNamePositionOption, "|"
    {   
        value := %A_LoopField%
        valueRound := floor(value)
        if(valueRound == 0)
            SETTING.setSetting("Position", A_LoopField, "")
        else
            SETTING.setSetting("Position", A_LoopField, valueRound)
        
    }

    Loop, Parse, allVNameAccessibility, "|"
    {   
        GuiControlGet, value,, %A_LoopField%
        if (value == 0 || value == 1)
        {
            SETTING.setSetting("Accessibility", A_LoopField, value)
        }
    }

    Loop,Parse, allVNameIllustrationNamePosition, "|"
    {

        value := %A_LoopField%
        valueRound := floor(value)
        if(valueRound == 0)
            SETTING.setSetting("IllustrationNamePosition", A_LoopField, "")
        else
            SETTING.setSetting("IllustrationNamePosition", A_LoopField, valueRound)
    }

    Gui, Destroy
    return

ResetDefaultTimerOption:
    Loop, Parse, allVNameTimerOption, "|"
    {
    SETTING.SetSettingFromDefault("Timers",A_LoopField)
    }
    Gui, Destroy
    AdvancedOptionsGui()
    return

DetectAutomatically:
    MsgBox, 4096,Detection Automatique, "Au prochain lancement d'une fonctionnalité, le programme essayera de detecter les positions des différents éléments et le sauvegarder.`n Vous pourrez toujours le modifier par la suite"
    Loop, Parse, allVNamePositionOption, "|"
    {
        GuiControl, focus, %A_LoopField%,
        send {Ctrl Down}a{Ctrl Up}
        send {BackSpace}
        ;IniWrite, "", %A_ScriptDir%\config.ini, Position, %A_LoopField%
        SETTING.SetSetting("Position",A_LoopField,"")
        GuiControl, focus, %DetectAutomatically%
    }
    Loop,Parse, allVNamePositionResolution, "|"
    {
            ;IniWrite,"",%A_ScriptDir%\config.ini,PositionResolution, %A_LoopField%
            SETTING.SetSetting("PositionResolution",A_LoopField,"")
            %A_LoopField% := ""

    }
    Gui, AdvancedOptions:Submit, NoHide
    return

InstructionsIllustrationFight:
    MsgBox,4096,Instructions,"Lire le document Instructions.pdf situé dans le dossier IllustrationNameCharacter/"
    return
}

OnGuiCloseForAdvancedOptions()
{
    global
   ;On va relancer le programme de détection des personnages en combat si l'option est activé
   Gui, Main:Submit, NoHide
   if(FightModeActive == 1){
    CloseScript("FightTurnDetection")
    sleep 100
    RunFightTurnDetectionFile()
   }
}
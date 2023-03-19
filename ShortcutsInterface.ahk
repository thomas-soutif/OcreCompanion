#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


ShortcutManagementGui(){
global
Gui, ShortcutInterface:New,+Resize -MaximizeBox
allVNameShortcut = ShortcutNextCharacter|ShortcutPreviousCharacter|ShortcutSkipTurn

 ifexist, %A_ScriptDir%\config.ini
	{
        Loop,Parse, allVNameShortcut, "|"
        {
             IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Shortcut, %A_LoopField%
             if(%A_LoopField% == "ERROR"){
                IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, %A_LoopField%
                IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
                IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Shortcut, %A_LoopField%
            }

        }

    }


Gui, Add, GroupBox, x22 y19 w210 h160 , Personnages
Gui, Font, S8 CTeal, Verdana
;Gui, Font, s12, CharSet:0x201
Gui, Font, S8 C, Verdana
Gui, Add, Text, x32 y50 w70 h30 , Personnage suivant
Gui, Add, Text, x32 y90 w70 h30 , Personnage precedent
Gui, Add, Edit, x122 y50 w50 h20 vShortcutNextCharacter, %ShortcutNextCharacter%
Gui, Add, Edit, x122 y90 w50 h20 vShortcutPreviousCharacter, %ShortcutPreviousCharacter%
Gui, Add, Button, x22 y179 w100 h40 gResetDefaultShortcutCharacter, ResetDefault

Gui, Add, Button, x32 y309 w100 h40 gSaveShortcuts, Sauvegarder

Gui, Add, GroupBox, x262 y19 w210 h160 , Combat
Gui, Add, Text, x272 y49 w60 h30 , Terminer le tour
Gui, Add, Edit, x342 y49 w50 h20 vShortcutSkipTurn, %ShortcutSkipTurn%
Gui, Add, Button, x262 y179 w100 h40 gResetDefaultShortcutFight, ResetDefault

Gui, Add, Edit, x572 y69 w-594 h-200 , Edit

;Gui, Add, GroupBox, x262 y219 w210 h160 , Raccourci


;Gui, Add, GroupBox, x542 y19 w180 h150 ,

Gui, +AlwaysOnTop
Gui, ShortcutInterface:Show, w750 h430, Raccourcis - DofusMultiAccountTool

return

SaveShortcuts:
        Gui, Submit, NoHide
        Loop, Parse, allVNameShortcut, "|"
        {   
            value := %A_LoopField%
            
            if(value == "")
                IniWrite, "", %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
            else
                IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
            
        }

        Gui, Destroy
        return

 ResetDefaultShortcutCharacter:
        nameShortcut = ShortcutNextCharacter|ShortcutPreviousCharacter
        ResetAndReload(nameShortcut)
        return

ResetDefaultShortcutFight:
        nameShortcut = ShortcutSkipTurn
        ResetAndReload(nameShortcut)
        return

}


ResetAndReload(listShortcut){
    Loop, Parse, listShortcut, "|"
        {
            IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, %A_LoopField%
            IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
        }
        Gui, Destroy
        ShortcutManagementGui()
}

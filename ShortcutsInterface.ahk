#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


ShortcutManagementGui(){
global
Gui, ShortcutInterface:New,+Resize -MaximizeBox
allVNameShortcut = ShortcutNextCharacter|ShortcutPreviousCharacter|ShortcutSkipTurn|ShortcutJoinFight|ShortcutGroup|ShortcutFightReady

 ifexist, %A_ScriptDir%\config.ini
	{
        Loop,Parse, allVNameShortcut, "|"
        {
             IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Shortcut, %A_LoopField%
             if(%A_LoopField% == "ERROR"){
                IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, %A_LoopField%
                IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
                IniRead,%A_LoopField%,%A_ScriptDir%\config.ini,Shortcut, %A_LoopField%
                ;HotkeyManager.DisableHotkey(A_LoopField)
            }
            
        }

    }
Gui, Font, S8 C, Verdana
Gui, Font, Bold s8
Gui, Add, GroupBox, x22 y19 w210 h160 , Personnages
Gui, Font, Normal s8

Gui, Add, Text, x32 y50 w70 h30 , Personnage suivant
Gui, Add, Text, x32 y90 w70 h30 , Personnage précédent
Gui, Add, Hotkey, x122 y50 w70 h20 vShortcutNextCharacter, %ShortcutNextCharacter%
Gui, Add, Hotkey, x122 y90 w70 h20 vShortcutPreviousCharacter, %ShortcutPreviousCharacter%
Gui, Add, Button, x22 y179 w100 h40 gResetDefaultShortcutCharacter, ResetDefault

Gui, Add, Button, x32 y309 w100 h40 gSaveShortcuts, Sauvegarder
Gui, Font, Bold s8
Gui, Add, GroupBox, x262 y19 w210 h200 , Combat
Gui, Font, Normal s8
Gui, Add, Text, x272 y49 w60 h30 , Terminer le tour
Gui, Add, Hotkey, x342 y49 w70 h20 vShortcutSkipTurn, %ShortcutSkipTurn%
Gui, Add, Text, x272 y89 w60 h30 , Rejoindre le combat
Gui, Add, Hotkey, x342 y89 w70 h20 vShortcutJoinFight, %ShortcutJoinFight%
Gui, Add, Text, x272 y129 w60 h30 , Grouper
Gui, Add, Hotkey, x342 y129 w70 h20 vShortcutGroup, %ShortcutGroup%
Gui, Add, Text, x272 y169 w60 h30 , Prêt
Gui, Add, Hotkey, x342 y169 w70 h20 vShortcutFightReady, %ShortcutFightReady%

Gui, Add, Button, x262 y219 w100 h40 gResetDefaultShortcutFight, ResetDefault
Gui, Add, Edit, x572 y69 w-594 h-200 , Edit

;Gui, Add, GroupBox, x500 y19 w210 h160 , Raccourci


;Gui, Add, GroupBox, x542 y19 w180 h150 ,

Gui, +AlwaysOnTop
Gui, ShortcutInterface:Show, w750 h430, Raccourcis - DofusMultiAccountTool
GuiClose:
   OnGuiCloseForShortcut()
return

SaveShortcuts:
        Gui, Submit, NoHide
        goStartBool := 0
        Loop, Parse, allVNameShortcut, "|"
        {   
            value := %A_LoopField%
            IniRead, oldValue, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
        
            if(value == oldValue){
                Continue ; On ne fait rien
            }
            if(value == "")
                IniWrite, "", %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
            else
                IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
            
            try{
                 HotkeyManager.UpdateHotkey(value,A_LoopField)
            }
            catch e{
                If(e == "KEY_DISABLED"){
                    ;On reload le logiciel pour prendre en compte les nouvelles touches, c'est du au fait qu'une key désactivée l'est pr tjrs pendant l'execution du script
                    goStartBool := 1
                }
            }
           
        }
        Gui, Destroy
        if(goStartBool){
            Reload
        }

        return

 ResetDefaultShortcutCharacter:
        nameShortcut = ShortcutNextCharacter|ShortcutPreviousCharacter
        ResetAndReload(nameShortcut)
        return

ResetDefaultShortcutFight:
        nameShortcut = ShortcutSkipTurn|ShortcutJoinFight|ShortcutGroup|ShortcutFightReady
        ResetAndReload(nameShortcut)
        return

}


ResetAndReload(listShortcut){
    Loop, Parse, listShortcut, "|"
        {
            Gui, Submit, NoHide
            ;IniRead, oldValue, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
            
            IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, %A_LoopField%
            HotkeyManager.AddKeyUsed(value)
            value := HotkeyToSend(value)
            GuiControl, focus, %A_LoopField%
            send %value%
            GuiControl, focus, ResetDefault
            
        }

        ;Gui, Destroy
        ;ShortcutManagementGui()
}


OnGuiCloseForShortcut()
{
   ; On va réactiver tout les Shortcut
    ;HotkeyManager.InitHotkeys()
}
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

VerifyShortcuts(virtualKey){

    ; Verify the shortcut for next Character
    IniRead,shortcut,%A_ScriptDir%\config.ini,Shortcut, ShortcutNextCharacter
    if(shortcut == "ERROR"){
        IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, ShortcutNextCharacter
        IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, ShortcutNextCharacter
        IniRead,shortcut,%A_ScriptDir%\config.ini,Shortcut, ShortcutNextCharacter
    }
    if(virtualKey == GetKeyVK(shortcut)){
        
        ; On a trouvé une correspondance entre les raccourcie
        ; On va aller switcher sur le second personnage
        characterNames := GetCharacterDetectedInGame()
        if !(List(characterNames,2)){
            ;Si il n'y a pas au moins 2 personnages, alors on arrête
            MsgBox, 4096,Attention, "Il vous faut au moins 2 personnages connectes en jeu pour pouvoir utiliser le raccourci qui permet de basculer sur le personnage suivant"
            return
        }
        ;On va récupérer le personnage qui est focus actuellement
        currentFocusCharacter := GetCurrentCharacterFocusing()
        customListCharacter := New ListCustom
        customListCharacter.SetList(characterNames)
        nextCharacter := customListCharacter.FindAndGetNext(currentFocusCharacter)
        ;;On active la fenêtre pour le personnage suivant
        WinActivate, %nextCharacter%
    }


}


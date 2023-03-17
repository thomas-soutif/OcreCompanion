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
        SwitchToNextCharacter()
        Return
    }

    ; or previous Character
    IniRead,shortcut,%A_ScriptDir%\config.ini,Shortcut, ShortcutPreviousCharacter
    if(shortcut == "ERROR"){
        IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, ShortcutPreviousCharacter
        IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, ShortcutPreviousCharacter
        IniRead,shortcut,%A_ScriptDir%\config.ini,Shortcut, ShortcutPreviousCharacter
    }

    if(virtualKey == GetKeyVK(shortcut)){
        SwitchToPreviousCharacter()
        Return
    }

    ; Shortcut to skip the tour
    IniRead,shortcut,%A_ScriptDir%\config.ini,Shortcut, ShortcutSkipTurn
    if(shortcut == "ERROR"){
        IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, ShortcutSkipTurn
        IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, ShortcutSkipTurn
        IniRead,shortcut,%A_ScriptDir%\config.ini,Shortcut, ShortcutSkipTurn
    }

    if(virtualKey == GetKeyVK(shortcut)){
        SkipTheTurn()
        Return
    }
}


SkipTheTurn(){

    characterNames := GetCharacterDetectedInGame()
    if !(List(characterNames,2)){
        ;Si il n'y a pas au moins 2 personnages, alors on arrête
        MsgBox, 4096,Attention, "Il vous faut au moins 2 personnages connectes en jeu pour pouvoir utiliser le raccourci qui permet de passer son tour et passer au personnage suivant"
        return
    }

    sleep 500
    SwitchToNextCharacter()

}


SwitchToNextCharacter(){

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
    ;;On active la fenêtre pour le personnage
    WinActivate, %nextCharacter%
}

SwitchToPreviousCharacter(){

    characterNames := GetCharacterDetectedInGame()
    if !(List(characterNames,2)){
        ;Si il n'y a pas au moins 2 personnages, alors on arrête
        MsgBox, 4096,Attention, "Il vous faut au moins 2 personnages connectes en jeu pour pouvoir utiliser le raccourci qui permet de basculer sur le personnage précédent"
        return
    }
    ;On va récupérer le personnage qui est focus actuellement
    currentFocusCharacter := GetCurrentCharacterFocusing()
    customListCharacter := New ListCustom
    customListCharacter.SetList(characterNames) 
    previousCharacter := customListCharacter.FindAndGetPrevious(currentFocusCharacter)

    ;;On active la fenêtre pour le personnage
    WinActivate, %previousCharacter%
}


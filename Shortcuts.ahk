#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

SkipTheTurn(){

    characterNames := GetCharacterDetectedInGame()
    if !(List(characterNames,2)){
        ;Si il n'y a pas au moins 2 personnages, alors on arrête
        MsgBox, 4096,Attention, "Il vous faut au moins 2 personnages connectes en jeu pour pouvoir utiliser le raccourci qui permet de passer son tour et passer au personnage suivant"
        return
    }
    currentFocusCharacter := GetCurrentCharacterFocusing()
    SetTitleMatchMode, 2
    ;On charge le raccourcie qui permet de passer le tour
    IniRead,key,%A_ScriptDir%\config.ini,Shortcut, ShortcutSkipTurn
    if(key == "ERROR"){
        IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, ShortcutSkipTurn
        IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, ShortcutSkipTurn
        IniRead,key,%A_ScriptDir%\config.ini,Shortcut, ShortcutSkipTurn
    }
    key := HotkeyToSend(key)
    Send, %key%
    sleep 100
    SwitchToNextCharacter()

}

SwitchToNextCharacter(){
    ;On vérifie les raccourcis uniquement si la fenetre active est une des personnages connectés
    if(GetCurrentCharacterFocusing() == ""){
        return
    }

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
    ;On vérifie les raccourcis uniquement si la fenetre active est une des personnages connectés
    if(GetCurrentCharacterFocusing() == ""){
        return
    }
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

switchToFirstCharacter(){
    ;On vérifie les raccourcis uniquement si la fenetre active est une des personnages connectés
    if(GetCurrentCharacterFocusing() == ""){
        return
    }
	; On va rebasculer sur le premier personnage qui est censé avoir l'initiative
	characterNames := GetCharacterDetectedInGame()
	customListCharacter := New ListCustom
    customListCharacter.SetList(characterNames)
	firstCharacter := customListCharacter.Get(1)
	WinActivate, %firstCharacter%
}


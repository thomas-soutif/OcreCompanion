﻿#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


ShortcutNextCharacter:
    SwitchToNextCharacter()
    Return

ShortcutPreviousCharacter:
    SwitchToPreviousCharacter()
    return

ShortcutSkipTurn:
    SkipTheTurn()
    return

ShortcutJoinFight:
    JoinFightForAllCharacters()
    return

ShortcutGroup:
    GroupCharacters()
    return

ShortcutFightReady:
    FightReadyForAllCharacters()
    return
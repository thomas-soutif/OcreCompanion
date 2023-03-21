#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


class HotkeyManager{

    Hotkeys := []
    keysUsedForShortcut := New ListCustom
     __New(){
        This.InitHotkeys()
    }
    AddKeyUsed(key){
        This.keysUsedForShortcut.Add(key)
    }
    UpdateHotkey(key, labelName){
        
        This.VerifyIfKeyHasBeenDisablePreviously(key)
   
        This.DisableHotkey(labelName)
        This.Hotkeys[labelName] := key
        Hotkey, IfWinActive, ahk_exe Dofus.exe
        Hotkey, % this.Hotkeys[labelName], %labelName%
    }
    DisableHotkey(labelName){
        key := this.Hotkeys[labelName]
        This.AddKeyUsed(key)
        Hotkey, % this.Hotkeys[labelName],, UseErrorLevel
        If ErrorLevel in 5,6
            return
        Else
            Hotkey, % this.Hotkeys[labelName],Off

    }
    VerifyIfKeyHasBeenDisablePreviously(key){
        if(This.keysUsedForShortcut.Find(key) != ""){
            ;already set before
            Throw "KEY_DISABLED" ; Error code that say the key has been set before 
        }
    }
    InitHotkeys(){
        allVNameShortcut = ShortcutNextCharacter|ShortcutPreviousCharacter|ShortcutSkipTurn

        ifexist, %A_ScriptDir%\config.ini
	    {
            Loop,Parse, allVNameShortcut, "|"
            {
                IniRead,key,%A_ScriptDir%\config.ini,Shortcut, %A_LoopField%
                if(key == "ERROR"){
                    IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Shortcut, %A_LoopField%
                    IniWrite, %value%, %A_ScriptDir%\config.ini, Shortcut, %A_LoopField%
                    IniRead,key,%A_ScriptDir%\config.ini,Shortcut, %A_LoopField%
                }
                
                try {
                    This.UpdateHotkey(key,A_LoopField)
                }
                catch e{
                    Continue
                }
                
                This.AddKeyUsed(key)
                
            }

        }
    }
}

HotkeyToSend(hotkey, format := "{$0}") {
    ;Convert a hotkey configure with Hotkey for exemple to a string thagt will be understandable by the commande Send
    if RegExMatch(hotkey, "(.*)[ `t]&[ `t](.*)", m)
        return HotkeyToSend(m1, "{$0 down}")
             . HotkeyToSend(m2)
             . HotkeyToSend(m1, "{$0 up}")
    return RegExReplace(RegExReplace(hotkey, "\w+(?i:[ `t]up)?|\W$", format), "(?<!{)[~$*<>]")
}
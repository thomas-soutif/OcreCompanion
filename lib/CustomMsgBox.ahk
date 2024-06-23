#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

;Function to show a custom message box

ShowCustomMsgBox(title := "Confirmation", text :="Custom text here", value1 := "Oui", value2 := "Non") {
    global
    result := ""
    Gui, CustomMsgBox:New,+Resize -MaximizeBox
    Gui, Font, S10, Arial ; Set the font and size for the GUI

    ; Add the text to the GUI
    Gui, Add, Text, x10 y10 w280 h50, %text%
    ; Add custom buttons
    Gui, Add, Button, x40 y60 w80 h30 gButton1, %value1%
    Gui, Add, Button, x160 y60 w80 h30 gButton2, %value2%

    ; Show the GUI centered on the screen
    Gui, Show, Center AutoSize, %title%

    ; Make the GUI modal (blocks other input)
    WinWaitClose, %title%
    return result
    
    ; Define the button click handlers
    Button1:
        Gui, Submit
        Gui, CustomMsgBox:Destroy
        result := "1"
        return

    Button2:
        Gui, Submit
        Gui, CustomMsgBox:Destroy
        result := "2"
        return

    
}

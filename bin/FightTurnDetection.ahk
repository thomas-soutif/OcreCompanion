SetWorkingDir, %parentRoot%
parentRoot = %1%
configPath = %2%
IniRead, topLeftX, %configPath%, IllustrationNamePosition, topLeftX
IniRead, topLeftY, %configPath%, IllustrationNamePosition, topLeftY
IniRead, bottomRightX, %configPath%, IllustrationNamePosition, bottomRightX
IniRead, bottomRightY, %configPath%, IllustrationNamePosition, bottomRightY

 SetTitleMatchMode 2
Loop {
	characterNames := GetCharacterDetectedInGame()
    FindOutX := ""
    FindOutY := ""
    Loop, Parse, characterNames, "|"
    {
        ImageSearch, FindOutX, FindOutY,%topLeftX%,%topLeftY%,%bottomRightX%,%bottomRightY%, *20 %A_WorkingDir%\IllustrationNameCharacter\%A_LoopField%.png
        if FindOutX || FindOutY
            WinActivate, %A_LoopField%
    }

    sleep 200

}

GetCharacterDetectedInGame(){
    global
    IniRead, CharacterNameList, %configPath%, CharactersList, listCharacters
	finalList := "" 
	Loop, Parse, CharacterNameList, "|"
	{
		if (WinExist(A_LoopField)){
			if (finalList ==""){
				finalList = %A_LoopField%|
			}
			else{
				finalList = %finalList%%A_LoopField%|
			}
		}
	}
	return finalList

}
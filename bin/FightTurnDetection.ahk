SetWorkingDir, %parentRoot%
parameterString = %1%
parameterDict := new DictCustom
parameterDict := parameterDict.FromDictRepresentation(parameterString)
parentRoot := parameterDict.Get("directory")


if(parentRoot == "")
{
    MsgBox, 4096,, Le programme ne peut être lancé que par le programme principale. Fermeture.
    ExitApp
}
configPath := parameterDict.Get("locationSetting")
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
		
		if(A_LoopField == ""){
			Continue
		}
        ;MsgBox, %A_LoopField%
        ImageSearch, FindOutX, FindOutY,%topLeftX%,%topLeftY%,%bottomRightX%,%bottomRightY%, *20 %A_WorkingDir%\IllustrationNameCharacter\%A_LoopField%.png
        if (FindOutX || FindOutY){
			    WinActivate, %A_LoopField%
		    }
            
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


Class DictCustom{

  dictCustom := Object()

  Add(key,value){

    This.dictCustom[key] := value
    return This.dictCustom
  }
  Remove(key){
    This.dictCustom := This.dictCustom.Delete(key)
    return This.dictCustom
  }
  Update(key,value){
    if(This.Get(key) != ""){
       This.Remove(key)
    }
    This.Add(key,value)
    return This.dictCustom
  }

  Get(key){
    return This.dictCustom[key]
  }

  GetDictRepresentation(){
    final_dict := "{"
    For key, value in This.dictCustom
      final_dict := final_dict key ":" value ","
    final_dict := final_dict "}"
    return final_dict
  }

  FindByKey(key){
    for itemKey, itemValue in This.dictCustom {
        if (itemKey = key) {
            return itemValue
        }
    }
    return ""
  }
  GetKeysName(){
    ; Return a CustomList
    customList := ListCustom
    customList.SetList("")
    for itemKey, itemValue in This.dictCustom {
        customList.Add(itemKey)
    }
    return customList
  }

  FromDictRepresentation(dictString) {
        dictString := RegExReplace(dictString, "\{|\}", "") ; remove { and }
        dictArray := StrSplit(dictString, ",") ; split by comma
        newDict := new DictCustom
        for _, keyValue in dictArray {
			
            keyValueArray := StrSplit(keyValue, ":",,2)
            key := Trim(keyValueArray[1])
            value := Trim(keyValueArray[2])
            newDict.Add(key, value)
        }
        return newDict
    }

}
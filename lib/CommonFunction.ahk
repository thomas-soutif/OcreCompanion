#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

List(listName,integer)
{
 Loop, parse, listName, |
 {
  If (integer = A_Index) {
   returnValue := A_LoopField
  }
 }
 return returnValue
}

list_files(Directory)
{
	files =
	Loop %Directory%\*.*
	{
    if (files == ""){
      files = %files%%A_LoopFileName%
    }else{
      files = %files%|%A_LoopFileName%
    }
		
	}
	return files
}

Class ListCustom{
  listCustomAttr := "|"


  Add(element){
    if This.listCustomAttr == "|"
       This.listCustomAttr := element
    else
       This.listCustomAttr := This.listCustomAttr "|" element
    return This.listCustomAttr
  }
  Pop(){
    return This.Remove(1)
  }

  Poll(){
    value := This.Get(1)
    This.Remove(1)
    return value
  }
  Remove(index){

    finalList := New ListCustom
    listC := This.listCustomAttr
    Loop, parse, listC , |
    {
      If (A_Index != index) {
        finalList.Add(A_LoopField)
      }
    }
    This.listCustomAttr := finalList.GetAll()
    return finalList.GetAll()
  }
  GetAll(){
    return This.listCustomAttr
  }
  Get(index){
    listC := This.listCustomAttr
    Loop, parse, listC, |
    {
      If (index = A_Index) {
      return A_LoopField
      }
    }
  }
  SetList(listCustom){
    if (listCustom == "")
      This.listCustomAttr := "|"
    else
      This.listCustomAttr := listCustom
    return
  }
  Find(value){
    ;; Retourne l'index de l'élément si il a été trouvé, sinon ""
    listC := This.listCustomAttr
    Loop, parse, listC , |
    {
      If (A_LoopField == value) {
        return A_Index
      }
    }
    return ""
  }
  FindAndGetNext(value){
    ;; Cherche une valeur dans la liste, et retourne la valeur de l'élément suivant (n+1).Si l'élément qu'on cherche
    ;; est le dernier de la liste, alors on retourne la valeur de l'élément 1

    index := This.Find(value)
    if(index + 1 > This.GetSize()){
      return This.Get(1)
    }
    return This.Get(index + 1)
  }
  FindAndGetPrevious(value){
    ;; Cherche une valeur dans la liste, et retourne la valeur de l'élément précédent(n-1).Si l'élément qu'on cherche
    ;; est le premier de la liste, alors on retourne la valeur du dernier élement

    index := This.Find(value)
    if(index - 1 < 1){
      return This.Get(This.GetSize())
    }
    return This.Get(index - 1)
  }
  GetSize(){
    listC := This.listCustomAttr
    if(listC == "|")
    {
      return 0
    }
    size := 0
    Loop, parse, listC , |
    {
      size := size + 1
    }
    return size -1
  }
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
get_element_in_list_file(Index,ListFile){
  Loop, Parse, ListFile, "|"
  {
    if(A_Index == Index){
       return A_LoopField
    }
     

  }
  return ""

  }




GetCharacterDetectedInGame(){
	IniRead, CharacterNameList, %A_ScriptDir%\config.ini, CharactersList, listCharacters
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

GetCharacterNames(){
	
	IniRead, CharacterNameList, %A_ScriptDir%\config.ini, CharactersList, listCharacters
	return CharacterNameList



}

GetCurrentCharacterFocusing(){

  characters := GetCharacterDetectedInGame()
  SetTitleMatchMode 2
  WinGetTitle, title, A
  Loop, Parse, characters, "|"
		{
      
      if InStr(title, A_LoopField){
        return A_LoopField
      }
    }
    return ""

}
GetCurrentCharacterFocusingIndex(){

  characters := GetCharacterDetectedInGame()
  SetTitleMatchMode 2
  WinGetTitle, title, A
  Loop, Parse, characters, "|"
		{
      
      if InStr(title, A_LoopField){
        return A_Index
      }
    }
    return ""

}


DetectWindowsByName(str)
{
	; Prend en paramètre une string, et retourne l'id de la fenêtre si cette string est inclue dans l'un des noms de fenêtre Windows. 

	SetTitleMatchMode 2
	UniqueID := WinExist(str)
	return UniqueID
	
}


Class PositionScreen{

  xPosition := 0
  yPosition := 0

PositionScreen(positionX=0, positionY=0){
  This.xPosition := positionX
  This.yPosition := positionY

}

  SavePosition(positionX, positionY){
    This.xPosition := positionX
    This.yPosition := positionY 
    return This.GetPosition
    }

  GetPosition(){
    return This.xPosition ";" This.yPosition
  }
  GetX(){
    return This.xPosition
  }
  GetY(){
    return This.yPosition
  }

  LoadPosition(position){
    StringSplit, positionArray, position,";"
    This.xPosition := positionArray1
    This.yPosition := positionArray2
  }
  


}


CloseScript(Name) ; Name should not contain .exe or .ahk, will be detected automatically
{
  Name := ConvertFileNameToCorrectScriptType(Name)
	DetectHiddenWindows On
	SetTitleMatchMode RegEx
	IfWinExist, i)%Name%.* ahk_class AutoHotkey
	{
		WinClose
		WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , 2
		If ErrorLevel
			return "Unable to close " . Name
		else
			return "Closed " . Name
	}
	else
		return Name . " not found"
}

ConvertFileNameToCorrectScriptType(Name){
   ModultiScriptType = %A_ScriptName%
  StringRight, ModultiScriptType, ModultiScriptType, 3
  if (ModultiScriptType == "ahk"){
     Name := Name . ".ahk"
  }
  else if(ModultiScriptType = "exe"){
     Name := Name . ".exe"
  }
  return Name
}

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
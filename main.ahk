#include %A_ScriptDir%\CommonFunction.ahk
#include %A_ScriptDir%\AccountManagment.ahk
#include %A_ScriptDir%\AdvancedOptions.ahk


Gui, Main:New, +Resize -MaximizeBox

Gui, Main:Add, Button, x12 y19 w110 h30 gAccountManagment , Personnages
Gui, Main:Add, Button, x150 y19 w110 h30 gAdvancedOptionsGui , Options avancées
Gui, Main:Add, GroupBox, x22 y299 w150 h100 , Options rapide
Gui, Main:Add, CheckBox, x52 y329 w80 h20 , Follow auto
Gui, Main:Add, Button, x22 y119 w100 h40 , REJOINDRE COMBAT
Gui, Main:Add, Button, x132 y119 w90 h40 , GROUPER
Gui, Main:Add, Button, x22 y179 w100 h40 , PRET
Gui, Main:Add, CheckBox, x52 y359 w90 h30 , Mode combat


;idd := DetectWindowsByName("Ankama")

;Detection des personnages configurés et récupération de leur id de fenêtre
characterNames := GetCharacterNames()
characterNames = %characterNames%
;MsgBox % List(characterNames,1)

Loop, Parse, characterNames, "|"
{
	;Pour chaque personnage
	;MsgBox, %A_LoopField%

}


Gui, Main:Show,x500 y361 w269 h454, DofusMultiAccountTool

Return

GuiEscape:
GuiClose:
Quitter:
ExitApp



DetectWindowsByName(str)
{
	; Prend en paramètre une string, et retourne l'id de la fenêtre si cette string est inclue dans l'un des noms de fenêtre Windows. 

	SetTitleMatchMode 2
	UniqueID := WinExist(str)
	return UniqueID
	
}


GetCharacterNames(){

	ifexist, %A_ScriptDir%\CharacterConfig.conf
		{
			final_string := ""
			Fileread, Content, %A_ScriptDir%\CharacterConfig.conf
			Loop, parse, Content, `n, `r
			{
				StringSplit, i_, A_LoopField, `t
				final_string .= i_1
				final_string .= "|"
			}
			final_string:=SubStr(final_string, 1, StrLen(final_string)-1)
			return final_string
		
		}
	return ""



}

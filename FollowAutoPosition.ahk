#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


VerifyNewPositionFollowAuto(){
	global

	if(VerifyNewPositionFollowAutoLock == 1)
		return

	Gui, Main:Submit, NoHide
	if (FollowAutoActive == 0){
		return
	}

	VerifyNewPositionFollowAutoLock := 1
	tickMax := 3000 / timerVerifyNewPosition
	tickMax := floor(tickMax)
	SetTitleMatchMode 2
	characterNames := GetCharacterDetectedInGame()
	characterNames = %characterNames%  
	IniRead,FollowMinTimer,%A_ScriptDir%\config.ini,Timers, FollowMin
	if(FollowMinTimer == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, FollowMin
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, FollowMin
			IniRead,FollowMinTimer,%A_ScriptDir%\config.ini,Timers, FollowMin
		}
	IniRead,FollowMaxTimer,%A_ScriptDir%\config.ini,Timers, FollowMax
	if(FollowMaxTimer == "ERROR"){
			IniRead, value, %A_ScriptDir%\defaultConfig\defaultConfig.ini,Timers, FollowMax
			IniWrite, %value%, %A_ScriptDir%\config.ini, Timers, FollowMax
			IniRead,FollowMinTimer,%A_ScriptDir%\config.ini,Timers, FollowMin
		}

	Loop, Parse, characterNames, "|"
	{
		if(WinExist(A_LoopField)){
			

			
			
			;MsgBox, %tickCharacter%
			currentPositionsWaiting := DictPositionFollowCharacter.Get(A_LoopField)
			customList := New ListCustom
			;MsgBox, %currentPositionsWaiting%
			if(currentPositionsWaiting == "" or currentPositionsWaiting == "|"){
				DictPositionFollowCharacterTick.Add(A_LoopField,tickMax)
				continue
			}


			;On vérifie le tick
			tickCharacter := DictPositionFollowCharacterTick.Get(A_LoopField)
			if(tickCharacter != ""){
				if(tickCharacter < tickMax){
					tickCharacter := tickCharacter + 1
					;MsgBox, %tickCharacter%
					DictPositionFollowCharacterTick.Add(A_LoopField,tickCharacter)
					Continue
					;On ignore la position du personnage car il ne s'est pas écoulé assez de temps
				}else{
					DictPositionFollowCharacterTick.Add(A_LoopField,0)

				}
				
			}else{
				DictPositionFollowCharacterTick.Add(A_LoopField,0)
			}

			customList.SetList(currentPositionsWaiting)
			customListPosition := customList.GetAll()
			;MsgBox, %customListPosition%
			position := customList.Get(1)
			customList.Pop()
			customListPosition := customList.GetAll()
			
			DictPositionFollowCharacter.Add(A_LoopField,customListPosition)
			dictContent := DictPositionFollowCharacter.GetDictRepresentation()
			
			;MsgBox, %position%
			positionScreen := New PositionScreen
			positionScreen.LoadPosition(position)
			xPosition := positionScreen.GetX()
			yPosition := positionScreen.GetY()
			;MsgBox, %xPosition%;%yPosition%

			Random, timerValue, FollowMinTimer, FollowMaxTimer
			Sleep timerValue
			ControlClick x%xPosition% y%yPosition%,%A_LoopField%
			

			;customListPosition := customList.GetAll()
			
			

		}

	}

	VerifyNewPositionFollowAutoLock  := 0
}


FollowAutoActiveClick(){
	global
	Gui, Main:Submit, NoHide
	if(FollowAutoActive == 1 and NoDelayActive == 1){
		;MsgBox,4096, "Action impossible", "Vous ne pouvez pas activer Follow Auto et No Delay en même temps"
		;GuiControl, focus, %FollowAutoText%,
		;ControlClick, %FollowAutoText%, A
		;return

	}
	if(FollowAutoActive == 0)
	{
		
		;On retire toute les positions des personnages
		characterNames := GetCharacterDetectedInGame()
		characterNames = %characterNames%  
		Loop, Parse, characterNames, "|"
		{
			DictPositionFollowCharacter.Add(A_LoopField,"|")
		}

	}
}





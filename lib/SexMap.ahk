#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

class SexMap {

    sex_map := New DictCustom


    __New(){
	    this.sex_map.Add("male", "male")
	    this.sex_map.Add("female", "female")
    }

    GetCharacterSex(characterName){
        
        sex := this.sex_map.Get(SETTING.getSetting("SexOfCharacter",characterName))
        if(sex == ""){
            SETTING.setSetting("SexOfCharacter",characterName,this._getDefaultSex()) ; Set default sex
            return this._getDefaultSex()
        }
        return sex

    }

    _getDefaultSex(){
        return "male"
    }

}
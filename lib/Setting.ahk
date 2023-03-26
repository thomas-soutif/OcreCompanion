#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


class SETTING{

    locationSetting := ""
    locationDefaultSetting := ""

    __New(locationSetting, locationDefaultSetting){
        This.locationSetting := locationSetting
        This.locationDefaultSetting := locationDefaultSetting
        
    }
    GetSetting(groupName, labelName){
        locSet := This.locationSetting
        locSetDefault := This.locationDefaultSetting
        IniRead,value,%locSet%,%groupName%, %labelName%
            if(value == "ERROR"){
                IniRead, value,%locSetDefault%,%groupName%, %labelName%
                This.SetSetting(groupName,labelName,value)
            }
        return value
    }
    GetSettingDefault(groupName, labelName){
        locSetDefault := This.locationDefaultSetting
        IniRead,value,%locSetDefault%,%groupName%, %labelName%
        return value
    }

    SetSettingFromDefault(groupName, labelName){

        value:= This.GetSettingDefault(groupName,labelName)
        This.SetSetting(groupName,labelName,value)
    }

    SetSetting(groupName, labelName,value){
        locSet := This.locationSetting
        IniWrite, %value%, %locSet%, %groupName%, %labelName%
    }

    DeleteSetting(groupName,labelName){
        locSet := This.locationSetting
        IniDelete, %locSet%, %groupName% , %labelName%
    }

    GetAllSettingOfSection(groupName){
        ;Return a DictCustom
        locSet := This.locationSetting
        IniRead,sectionValues, %locSet%, %groupName%
        dictCustom := New DictCustom
        Loop , parse, sectionValues, `n,`r
	    {
            values:= StrSplit(A_LoopField, "=")
            dictCustom.Add(values[1],values[2])

        }
        return dictCustom
    }
}
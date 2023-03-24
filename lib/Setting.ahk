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

    SetSetting(groupName, labelName,value){
        locSet := This.locationSetting
        IniWrite, %value%, %locSet%, %groupName%, %labelName%
    }
}
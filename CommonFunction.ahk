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
    This.Remove(1)
    return This.GetALL()
  }
  Remove(index){

    finalList := New ListCustom
    listC := This.listCustomAttr
    Loop, parse, listC , |
    {
      If (A_Index != index) {
        finalList.Add(This.Get(A_Index))
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
    This.listCustomAttr = listCustom
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
    
    }

  GetPosition(){
    return This.xPosition ";" This.yPosition
  }

  


}


;/*
;===========================================
;  FindText - Capture screen image into text and then find it
;  https://autohotkey.com/boards/viewtopic.php?f=6&t=17834
;
;  Author  : FeiYue
;  Version : 8.7
;  Date    : 2022-01-24
;
;  Usage:  (required AHK v1.1.31+)
;  1. Capture the image to text string.
;  2. Test find the text string on full Screen.
;  3. When test is successful, you may copy the code
;     and paste it into your own script.
;     Note: Copy the "FindText()" function and the following
;     functions and paste it into your own script Just once.
;  4. The more recommended way is to save the script as
;     "FindText.ahk" and copy it to the "Lib" subdirectory
;     of AHK program, instead of copying the "FindText()"
;     function and the following functions, add a line to
;     the beginning of your script: #Include <FindText>
;  5. If you want to call a method in the "FindTextClass" class,
;     use the parameterless FindText() to get the default object
;
;===========================================
;*/


if (!A_IsCompiled and A_LineFile=A_ScriptFullPath)
  FindText().Gui("Show")


;===== Copy The Following Functions To Your Own Code Just once =====


;--------------------------------
;  FindText - Capture screen image into text and then find it
;--------------------------------
;  returnArray := FindText(
;      OutputX --> The name of the variable used to store the returned X coordinate
;    , OutputY --> The name of the variable used to store the returned Y coordinate
;    , X1 --> the search scope's upper left corner X coordinates
;    , Y1 --> the search scope's upper left corner Y coordinates
;    , X2 --> the search scope's lower right corner X coordinates
;    , Y2 --> the search scope's lower right corner Y coordinates
;    , err1 --> Fault tolerance percentage of text       (0.1=10%)
;    , err0 --> Fault tolerance percentage of background (0.1=10%)
;    , Text --> can be a lot of text parsed into images, separated by "|"
;    , ScreenShot --> if the value is 0, the last screenshot will be used
;    , FindAll --> if the value is 0, Just find one result and return
;    , JoinText --> if the value is 1, Join all Text for combination lookup
;    , offsetX --> Set the max text offset (X) for combination lookup
;    , offsetY --> Set the max text offset (Y) for combination lookup
;    , dir --> Nine directions for searching: up, down, left, right and center
;  )
;
;  The function returns a second-order array containing
;  all lookup results, Any result is an associative array
;  {1:X, 2:Y, 3:W, 4:H, x:X+W//2, y:Y+H//2, id:Comment}
;  if no image is found, the function returns 0.
;  All coordinates are relative to Screen, colors are in RGB format
;
;  If the return variable is set to "ok", ok[1] is the first result found.
;  ok[1][1], ok[1][2] is the X, Y coordinate of the upper left corner of the found image,
;  ok[1][3] is the width of the found image, and ok[1][4] is the height of the found image,
;  ok[1].x <==> ok[1][1]+ok[1][3]//2 ( is the Center X coordinate of the found image ),
;  ok[1].y <==> ok[1][2]+ok[1][4]//2 ( is the Center Y coordinate of the found image ),
;  ok[1].id is the comment text, which is included in the <> of its parameter.
;
; If OutputX is equal to "wait" or "wait1"(appear), or "wait0"(disappear)
; it means using a loop to wait for the image to appear or disappear.
; the OutputY is the wait time in seconds, time less than 0 means infinite waiting
; Timeout means failure, return 0, and return other values means success
; If you want to appear and the image is found, return the found array object
; If you want to disappear and the image cannot be found, return 1
; Example 1: FindText(X:="wait", Y:=3, 0,0,0,0,0,0,Text)   ; Wait 3 seconds for appear
; Example 2: FindText(X:="wait0", Y:=-1, 0,0,0,0,0,0,Text) ; Wait indefinitely for disappear
;--------------------------------

FindText(ByRef x:="FindTextClass", ByRef y:="", args*)
{
  global FindTextClass
  if (x=="FindTextClass")
    return FindTextClass
  else
    return FindTextClass.FindText(x, y, args*)
}

Class FindTextClass
{  ;// Class Begin

static bind:=[], bits:=[], Lib:=[], Cursor:=0

__New()
{
  this.bind:=[], this.bits:=[], this.Lib:=[], this.Cursor:=0
}

__Delete()
{
  if (this.bits.hBM)
    DllCall("DeleteObject", "Ptr",this.bits.hBM)
}

FindText(ByRef OutputX:="", ByRef OutputY:=""
  , x1:=0, y1:=0, x2:=0, y2:=0, err1:=0, err0:=0
  , text:="", ScreenShot:=1, FindAll:=1
  , JoinText:=0, offsetX:=20, offsetY:=10, dir:=1)
{
  local
  if RegExMatch(OutputX, "i)^\s*wait[10]?\s*$")
  {
    found:=!InStr(OutputX,"0"), time:=OutputY
    , timeout:=A_TickCount+Round(time*1000)
    , OutputX:=OutputY:=""
    Loop
    {
      ; Wait for the image to remain stable
      While (ok:=this.FindText(OutputX, OutputY
        , x1, y1, x2, y2, err1, err0, text, ScreenShot, FindAll
        , JoinText, offsetX, offsetY, dir)) and (found)
      {
        v:=ok[1], x:=v[1], y:=v[2], w:=v[3], h:=v[4]
        hash:=this.GetPicHash(x,y,x+w-1,y+h-1,0)
        Sleep, 10
        if (hash=this.GetPicHash(x,y,x+w-1,y+h-1,1))
          return ok
      }
      if (!found and !ok)
        return 1
      if (time>=0 and A_TickCount>=timeout)
        Break
      Sleep, 100
    }
    return 0
  }
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  centerX:=Round(x1+x2)//2, centerY:=Round(y1+y2)//2
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy,zw,zh)
  , x-=zx, y-=zy, info:=[], this.ok:=0
  Loop Parse, text, |
    if IsObject(j:=this.PicInfo(A_LoopField))
      info.Push(j)
  if (w<1 or h<1 or !(num:=info.Length()) or !bits.Scan0)
  {
    SetBatchLines, %bch%
    return 0
  }
  arr:=[], ini:={zx:zx, zy:zy, zw:zw, zh:zh
    , sx:x, sy:y, sw:w, sh:h, comment:""}, k:=0
  For i,j in info
    k:=Max(k, j[2]*j[3]), ini.comment .= j[11]
  VarSetCapacity(s1, k*4), VarSetCapacity(s0, k*4)
  , VarSetCapacity(ss, 2*(w+2)*(h+2))
  , FindAll:=(dir=9 ? 1 : FindAll)
  , JoinText:=(num=1 ? 0 : JoinText)
  , allpos_max:=(FindAll or JoinText ? 10240 : 1)
  , VarSetCapacity(allpos, allpos_max*8)
  Loop 2
  {
    if (err1=0 and err0=0) and (num>1 or A_Index>1)
      err1:=0.05, err0:=0.05
    Loop % JoinText ? 1 : num
    {
      this.PicFind(arr, ini, info, A_Index, err1, err0
        , FindAll, JoinText, offsetX, offsetY, dir
        , bits, ss, s1, s0, allpos, allpos_max)
      if (!FindAll and arr.Length())
        Break, 2
    }
    if (err1!=0 or err0!=0 or arr.Length() or info[1][12])
      Break
  }
  if (dir=9)
    arr:=this.Sort2(arr, centerX, centerY)
  SetBatchLines, %bch%
  if (arr.Length())
  {
    OutputX:=arr[1].x, OutputY:=arr[1].y, this.ok:=arr
    return arr
  }
  return 0
}

PicFind(arr, ini, info, index, err1, err0
  , FindAll, JoinText, offsetX, offsetY, dir
  , bits, ByRef ss, ByRef s1, ByRef s0
  , ByRef allpos, allpos_max)
{
  local
  static MyFunc:=""
  if (!MyFunc)
  {
    x32:=""
    . "5557565383EC6C8BAC248000000083FD050F84DB0800008B8424C4000000C744"
    . "24100000000085C00F8E6B0D000031FF31C089AC2480000000C744240C000000"
    . "0031C9C744241800000000897C241489C58B5C24148BBC24C00000008B742418"
    . "8B54241001DF89D829DE8B9C24C000000003B424BC00000085DB7E68897C2404"
    . "89EB89D7EB248D76008DBC27000000008BAC24B800000083C70483C00189548D"
    . "0083C10139442404742D83BC24800000000389FA0F45D0803C063175D38BAC24"
    . "B400000083C70483C00189549D0083C3013944240475D38BB424C00000000174"
    . "241889DD8344240C018BBC24A80000008B44240C017C24148B9C249400000001"
    . "5C2410398424C40000000F8541FFFFFF896C240C8BAC2480000000894C241031"
    . "C08B74240C39B424C80000008B7C24100F4DF039BC24CC0000008974240C0F4C"
    . "C739C6894424100F4DC683FD03894424040F84AF0800008B8424940000008BB4"
    . "24A00000000FAF8424A4000000C1E6028974243801F08BB42494000000894424"
    . "348B8424A8000000F7D885ED8D0486894424240F858B0300008B842484000000"
    . "C744242000000000C744242800000000C1E8100FB6E88B8424840000000FB6C4"
    . "894424140FB6842484000000894424188B8424A8000000C1E002894424308B84"
    . "24AC00000085C00F8EC70000008B7C24088B442434896C241C8BAC24A8000000"
    . "85ED0F8E8E0000008BB424900000008B6C242803AC24B000000001C603442430"
    . "8944242C0384249000000089442408900FB67E028B4C241C0FB6160FB646012B"
    . "5424182B44241489FB01CF29CB8D8F000400000FAFC00FAFCBC1E00B0FAFCBBB"
    . "FE05000029FB0FAFDA01C10FAFD301CA399424880000000F93450083C60483C5"
    . "013B74240875A98B9C24A8000000015C24288B44242C8344242001034424248B"
    . "74242039B424AC0000000F8549FFFFFF897C24088B8424A80000002B8424C000"
    . "0000C644244F00C644244E00C744245400000000C74424600000000089442458"
    . "8B8424AC0000002B8424C40000008944243C8B84248C00000083E80183F8070F"
    . "87D005000083F803894424440F8ECB0500008B4424608B742454894424548974"
    . "24608B742458397424540F8F760A00008B4424588B74240CC744243000000000"
    . "8944245C8B8424B40000008D04B08B7424448944245089F083E0018944244889"
    . "F08BB4249000000083E003894424648B4424608B7C243C39F80F8F7F01000083"
    . "7C2464018B5C24540F4F5C245C897C242C89442420895C24408DB42600000000"
    . "8B7C24488B44242C85FF0F44442420837C244403894424240F8FD2020000807C"
    . "244E008B442440894424288B4424280F85DA020000807C244F000F8580030000"
    . "0FAF8424A80000008B5424048B5C242485D28D2C180F8E840000008BBC24CC00"
    . "00008B9424B000000031C08B9C24C8000000896C24348B4C240C8974241C01EA"
    . "897C24188B6C24048B7C2410895C241439C17E1C8B9C24B40000008B348301D6"
    . "803E00750B836C2414010F886004000039C77E1C8B9C24B80000008B348301D6"
    . "803E00740B836C2418010F884004000083C00139E875B98B6C24348B74241C8B"
    . "44240C85C074278BBC24B00000008B8424B40000008B5C24508D0C2F8D742600"
    . "8B1083C00401CA39D8C6020075F28B442424038424A00000008B5C24308BBC24"
    . "D00000008904DF8B442428038424A40000008944DF0483C3013B9C24D4000000"
    . "895C24307D308344242001836C242C018B4424203944243C0F8DA2FEFFFF8344"
    . "245401836C245C018B442454394424580F8D59FEFFFF8B44243083C46C5B5E5F"
    . "5DC2580083FD010F849507000083FD020F84F90400008B8424840000000FB6BC"
    . "2484000000C744242C00000000C744243000000000C1E8100FB6D08B84248400"
    . "000089D50FB6DC8B842488000000C1E8100FB6C88B84248800000029CD01D189"
    . "6C243C89DD894C24140FB6F40FB684248800000029F501DE896C241889FD8974"
    . "241C29C501F8894424288B8424A8000000896C2420C1E002894424388B8424AC"
    . "00000085C00F8EE9FCFFFF8B4C24348B6C243C8B8424A800000085C00F8E8F00"
    . "00008B8424900000008B542430039424B000000001C8034C243889CF894C2434"
    . "03BC2490000000EB3B8DB42600000000395C24147C3D394C24187F37394C241C"
    . "7C3189F30FB6F3397424200F9EC3397424280F9DC183C00483C20121D9884AFF"
    . "39C7741E0FB658020FB648010FB63039DD7EBD31C983C00483C201884AFF39C7"
    . "75E28BB424A8000000017424308B4C24348344242C01034C24248B44242C3984"
    . "24AC0000000F8548FFFFFFE924FCFFFF8B442424807C244E00894424288B4424"
    . "40894424248B4424280F8426FDFFFF0FAF8424940000008B5C24048B4C242485"
    . "DB8D2C880F8EE4FDFFFF8BBC24C800000031C9896C241489F68DBC2700000000"
    . "8B8424B40000008B5C2414031C888B8424B80000008B2C880FB6441E0289EAC1"
    . "EA100FB6D229D00FB6541E010FB61C1E0FAFC03B4424087F2789E80FB6C429C2"
    . "0FAFD23B5424087F1789E80FB6C029C30FAFDB3B5C24087E108DB42600000000"
    . "83EF010F887701000083C1013B4C2404758E89AC2484000000E950FDFFFF6690"
    . "0FAF8424940000008B4C24248D048889442414038424840000000FB64C06010F"
    . "B67C06020FB60406894C24188B4C24048944241C85C90F8E12FDFFFF8B8424CC"
    . "00000031DB894424388B8424C8000000894424348B442408897C24088D742600"
    . "395C240C7E658B8424B40000008B4C24148B7C2408030C980FB6440E020FB654"
    . "0E010FB60C0E2B5424182B4C241C89C501F829FD8DB8000400000FAFD20FAFFD"
    . "C1E20B0FAFFDBDFE05000029C50FAFE901FA0FAFCD01D1398C2488000000730B"
    . "836C2434010F88A1000000395C24107E618B8424B80000008B4C24148B7C2408"
    . "030C980FB6440E020FB6540E010FB60C0E2B5424182B4C241C89C501F829FD8D"
    . "B8000400000FAFD20FAFFDC1E20B0FAFFDBDFE05000029C50FAFE901FA0FAFCD"
    . "01D1398C24880000007207836C243801783A83C3013B5C24040F8521FFFFFF89"
    . "442408E906FCFFFF908DB426000000008B74241CE92DFCFFFF8DB42600000000"
    . "89AC2484000000E91AFCFFFF89442408E911FCFFFFC7442444000000008B4424"
    . "3C8B742458894424588974243CE930FAFFFF8B84248800000031FF89AC248000"
    . "00008BB424BC00000031D289FD894424048B8424840000000FAFC08944240831"
    . "C0EB18B90A0000006BFA0AF7E189D9C1FB1F01FA01C811DA83C6010FBE0E85C9"
    . "744A8D59D083FB0976D983F92F75E989D389C10FB7C00FACD9108B9C24B40000"
    . "008D3CAD000000000FB7C90FAF8C24940000008D04818904AB8B9C24B8000000"
    . "83C50131C089143B31D2EBAC8BAC248000000083FD058B8424A80000000F9444"
    . "244E83FD030F9444244F038424A00000002B8424C0000000894424588B8424A4"
    . "000000038424AC0000002B8424C40000008944243C8B8424A4000000C78424A4"
    . "00000000000000894424548B8424A0000000C78424A000000000000000894424"
    . "60E9ECF8FFFF8B8424840000000FB7942484000000C1E8100FAF842494000000"
    . "8D049089842484000000E964FFFFFF8B8424A80000008BB424A40000000FAF84"
    . "24AC00000083EE01038424B0000000897424148944241C8B8424A80000000384"
    . "24A0000000894424208B8424A4000000038424AC00000039F00F8C0A0100008B"
    . "B424A000000083C0012BAC24A00000008944242C8B442420C744242800000000"
    . "83EE01897424308B74241401C50FAFB424940000008D7801896C243489742424"
    . "8B442430394424200F8C9D0000008B4C24148B5C24248B742428035C24382BB4"
    . "24A0000000039C2490000000C1E91F0374241C894C2418EB528DB42600000000"
    . "398424980000007E4B807C24180075448B4C2414398C249C0000007E370FB64B"
    . "FE0FB653FD83C3040FB66BF86BD24B6BC92601D189EAC1E20429EA01CAC1FA07"
    . "8854060183C00139F8741889C2C1EA1F84D274ACC64406010083C00183C30439"
    . "F875E88B7424340174242883442414018B9C24940000008B442414015C242439"
    . "44242C0F8537FFFFFF8B8424A80000008B8C24AC00000083C00285C989442420"
    . "0F8E0EF7FFFF8B8424AC0000008B6C241C036C2420C744241C01000000C74424"
    . "240000000083C001894424288B8424A8000000896C241883C0048944242C8B84"
    . "24880000008B9424A800000085D20F8EA70000008B4424188B5C24248B74242C"
    . "039C24B000000089C12B8C24A800000089C201C6894C2414908DB42600000000"
    . "0FB642010FB62ABF010000000384248400000039E8723D0FB66A0239E872358B"
    . "4C24140FB669FF39E872290FB66EFF39E872210FB669FE39E872190FB62939E8"
    . "72120FB66EFE39E8720A0FB63E39F80F92C189CF89F9834424140183C201880B"
    . "83C60183C3018B7C2414397C241875908BBC24A8000000017C24248344241C01"
    . "8B5C24208B74241C015C2418397424280F852FFFFFFF89842488000000E9F2F5"
    . "FFFF8B8424840000008BB424AC00000031EDC74424180000000083C001C1E007"
    . "898424840000008B8424A8000000C1E00285F68944241C0F8EB7F5FFFF896C24"
    . "148B4424348BAC24840000008B9C24A800000085DB7E638B8C24900000008B5C"
    . "2418039C24B000000001C10344241C894424200384249000000089C78D742600"
    . "0FB651020FB641010FB6316BC04B6BD22601C289F0C1E00429F001D039C50F97"
    . "0383C10483C30139F975D58BBC24A8000000017C24188B442420834424140103"
    . "4424248B74241439B424AC0000000F8578FFFFFFE91BF5FFFFC744240C000000"
    . "00E979F3FFFFC744243000000000E963F7FFFF90909090909090909090909090"
    x64:=""
    . "4157415641554154555756534881EC88000000488BBC24F0000000488BB42430"
    . "01000083F90589542468448944240844898C24E8000000488B9C243801000048"
    . "8BAC24400100000F84300900008B8424580100004531ED4531E485C00F8EDC00"
    . "000044897C240C448BBC245001000031D231C04889BC24F00000004889B42430"
    . "0100004531F64531ED4531E4C704240000000089D789C6660F1F840000000000"
    . "4585FF7E6548631424478D1C374489F048039424480100004189F8EB1F0F1F00"
    . "83C0014D63D54183C0044183C5014883C2014139C346894C9500742A83F90345"
    . "89C1440F45C8803A3175D583C0014D63D44183C0044183C4014883C2014139C3"
    . "46890C9375D644013C2483C6014403B4242001000003BC24F800000039B42458"
    . "0100000F8577FFFFFF448B7C240C488BBC24F0000000488BB4243001000031C0"
    . "4439A42460010000440F4DE04439AC2468010000440F4DE84539EC4589EE450F"
    . "4DF483F9030F848A0800008B8424F80000008B9424100100000FAF8424180100"
    . "008D04908B9424F8000000894424208B842420010000F7D885C98D0482890424"
    . "0F85C40300008B4C24684889C84189CB0FB6C441C1EB1089C20FB6C1450FB6DB"
    . "4189C28B84242801000085C00F8E370100008B842420010000448964242831C9"
    . "44896C24304889B42430010000448B6C2420448B6424088BB42420010000C1E0"
    . "0244897424184889BC24F00000004889AC24400100004189CEC744240C000000"
    . "008944241089D748899C24380100004489D585F60F8E8A000000488B9C24F000"
    . "00004963C54531D24C8D4C030248635C240C48039C2430010000660F1F440000"
    . "450FB639410FB651FE410FB641FF29EA4489F94501DF4189D0418D9700040000"
    . "4429D929F80FAFD10FAFC00FAFD1C1E00B8D0402BAFE0500004429FA410FAFD0"
    . "410FAFD001D04139C4420F9304134983C2014983C1044439D67FA544036C2410"
    . "0174240C4183C60144032C244439B424280100000F8558FFFFFF448B74241844"
    . "8B642428448B6C2430488BBC24F0000000488BB42430010000488B9C24380100"
    . "00488BAC24400100008B8424200100002B842450010000C644245700C644244C"
    . "00C744246C00000000C744247800000000894424708B8424280100002B842458"
    . "010000894424408B8424E800000083E80183F8070F870606000083F803894424"
    . "480F8E010600008B4424788B4C246C8944246C894C24788B4C2470394C246C0F"
    . "8F050B00008B4424708B4C244848899C24380100004889AC24400100004489ED"
    . "4589E5C74424300000000089442474418D4424FF4C8BA42440010000488D4483"
    . "044889F3488BB42438010000488944246089C883E0018944245089C883E00389"
    . "44247C4489F04589FE4189C78B4424788B4C244039C80F8F3E010000837C247C"
    . "018B54246C0F4F542474894C2428890424895424448B44245085C08B4424280F"
    . "440424837C2448038944240C0F8FCF020000807C244C008B442444894424100F"
    . "85D7020000807C2457000F85700300008B4C24100FAF8C2420010000034C240C"
    . "4585FF7E59448B942468010000448B8C246001000031C0660F1F840000000000"
    . "4139C589C27E184189C84403048642803C0300750A4183E9010F888500000039"
    . "D57E1289CA41031484803C130074064183EA01786F4883C0014139C77FC24585"
    . "ED741E4C8B4424604889F00F1F44000089CA03104883C0044C39C0C604130075"
    . "EF8B4C24308B54240C039424100100004C8B94247001000089C801C048984189"
    . "14828B54241003942418010000418954820489C883C0013B8424780100008944"
    . "24307D2E83042401836C2428018B0424394424400F8DDBFEFFFF8344246C0183"
    . "6C2474018B44246C394424700F8D9AFEFFFF8B4424304881C4880000005B5E5F"
    . "5D415C415D415E415FC383F9010F844108000083F9020F84070500008B542468"
    . "448B542408C744241000000000C74424180000000089D0440FB6C2C1E810440F"
    . "B6C84889D00FB6CC4489D04589CBC1E810894C240C0FB6D04C89D00FB6C44129"
    . "D34401CA89C18B44240C29C8034C240C89442430410FB6C24589C24129C24401"
    . "C0448B8424280100008944240C8B842420010000C1E0024585C0894424280F8E"
    . "05FDFFFF448974243C44896C244448899C2438010000448B742420448B6C2430"
    . "8B9C242001000044897C243844896424404189CF4889AC24400100004189D444"
    . "89D585DB7E784C635424184963C631D2488D4407024901F2EB37660F1F440000"
    . "4539C47C3E4139CD7F394139CF7C344439CD410F9EC044394C240C0F9DC14883"
    . "C0044421C141880C124883C20139D37E24440FB6000FB648FF440FB648FE4539"
    . "C37EBD31C94883C00441880C124883C20139D37FDC4403742428015C24188344"
    . "241001440334248B442410398424280100000F856AFFFFFF448B7C2438448B74"
    . "243C448B642440448B6C2444488B9C2438010000488BAC2440010000E908FCFF"
    . "FF8B44240C807C244C00894424108B4424448944240C0F8429FDFFFF8B442410"
    . "8B4C240C0FAF8424F80000004585FF448D14880F8EA8FDFFFF448B8C24600100"
    . "004531C04989DB660F1F840000000000428B1486438B1C844401D289D98D4202"
    . "C1E9100FB6C948980FB6040729C88D4A014863D20FAFC00FB614174863C90FB6"
    . "0C0F4439F07F1A0FB6C729C10FAFC94439F17F0D0FB6C329C20FAFD24439F27E"
    . "0A4183E9010F88950100004983C0014539C77F9C895C24684C89DBE921FDFFFF"
    . "8B4424108B4C240C0FAF8424F80000008D048889C1034424684585FF8D500248"
    . "63D2440FB614178D500148980FB604074863D20FB614170F8EE4FCFFFF448B9C"
    . "246801000048895C24584531C948897424184C8964242089CB89C64189D44489"
    . "5C243C448B9C246001000044895C24384539CD4589C87E6E488B442418428B14"
    . "8801DA8D42024898440FB634078D42014863D20FB6141748980FB604074589F3"
    . "4501D6418D8E000400004529D329F2410FAFCB4429E00FAFC0410FAFCB41BBFE"
    . "050000C1E00B4529F3440FAFDA01C8410FAFD301C239542408730B836C243801"
    . "0F88A60000004439C57E6A488B442420428B148801DA8D42024898440FB63407"
    . "8D42014863D20FB6141748980FB604074589F04501D6418D8E000400004529D0"
    . "29F2410FAFC84429E00FAFC0410FAFC841B8FE050000C1E00B4529F0440FAFC2"
    . "01C8410FAFD001C2395424087207836C243C0178374983C1014539CF0F8F0EFF"
    . "FFFF488B5C2458488B7424184C8B642420E9ABFBFFFF662E0F1F840000000000"
    . "895C24684C89DBE9D8FBFFFF488B5C2458488B7424184C8B642420E9C4FBFFFF"
    . "C7442448000000008B4424408B4C247089442470894C2440E9FAF9FFFF8B4424"
    . "68448B7424084531D24531DB4189C7440FAFF8488B842448010000EB0F4B8D14"
    . "924D63C04D8D14504883C0010FBE1085D2745D448D42D04183F80976E083FA2F"
    . "75E64C89D2450FB7CA4D63C348C1EA1049C1EA204183C3010FB7D20FAF9424F8"
    . "000000428D148A4289148346895485004531D2EBB38B54246889D00FB7D2C1E8"
    . "100FAF8424F80000008D04908944246883F9058B8424200100000F9444244C83"
    . "F9030F94442457038424100100002B842450010000894424708B842418010000"
    . "038424280100002B842458010000894424408B842418010000C7842418010000"
    . "000000008944246C8B842410010000C78424100100000000000089442478E9C4"
    . "F8FFFF8B8424200100008B9424180100000FAF842428010000448D5AFF489848"
    . "01F0488904248B842420010000038424100100008944240C8B84241801000003"
    . "8424280100004439D80F8C610100008B94241001000083C001448B9424F80000"
    . "00894424282B8C24100100004489642448448BA4240001000083EA01C7442418"
    . "0000000044897C24408D049500000000895424384489742444450FAFD344896C"
    . "244C48899C243801000089442420489848894424308B44240C448954241001C1"
    . "448D5001894C243C8B4424383944240C0F8CA40000008B4C24108B5424204589"
    . "DE488B5C24304C6344241841C1EE1F4C03042401CA4C63F94863D24C8D0C1748"
    . "29D3EB514139C47E554584F6755044399C24080100007E46410FB64902410FB6"
    . "510183C0014983C0016BD24B6BC92601D14A8D140B4983C104460FB62C3A4489"
    . "EAC1E2044429EA01D1C1F907418848FF4139C2741D89C2C1EA1F84D274A683C0"
    . "0141C600004983C1044983C0014139C275E38B5C243C015C24184183C3018B9C"
    . "24F8000000015C241044395C24280F8534FFFFFF448B7C2440448B742444448B"
    . "642448448B6C244C488B9C24380100008B842420010000448B94242801000083"
    . "C0024585D20F8EBEF6FFFF488B0C24489844897C24384889442410448B7C2468"
    . "48899C2438010000C7042401000000488D440101C744240C0000000044897424"
    . "3C4889C18B8424280100004889CB83C001894424184863842420010000488D50"
    . "0348F7D048894424288B84242001000048895424208B54240883E8014883C001"
    . "4889442430448B8C24200100004585C90F8EAD000000488B44242048634C240C"
    . "4C8D0C18488B4424284801F14C8D0418488B4424304C8D34184889D80F1F4000"
    . "0FB610440FB650FF41BB010000004401FA4439D2724A440FB650014439D27240"
    . "450FB650FF4439D27236450FB651FF4439D2722C450FB650FE4439D27222450F"
    . "B6104439D27219450FB651FE4439D2720F450FB6114439D2410F92C30F1F4000"
    . "4883C0014488194983C1014883C1014983C0014C39F075888B8C242001000001"
    . "4C240C8304240148035C24108B0424394424180F852CFFFFFF448B7C2438448B"
    . "74243C89542408488B9C2438010000E955F5FFFF8B8424200100008B54246845"
    . "31DBC744240C00000000C1E00283C201894424108B842428010000C1E2078954"
    . "246885C00F8E1FF5FFFF44897C241848899C2438010000448B7C2468448B9424"
    . "200100008B5C242044897424284585D27E504C6374240C4863C34531C0488D4C"
    . "07024901F60FB6110FB641FF440FB649FE6BC04B6BD22601C24489C8C1E00444"
    . "29C801D04139C7430F9704064983C0014883C1044539C27FCC035C2410440154"
    . "240C4183C301031C2444399C2428010000759A448B7C2418448B742428488B9C"
    . "2438010000E97FF4FFFFC744243000000000E9BBF6FFFF909090909090909090"
    this.MCode(MyFunc, A_PtrSize=8 ? x64:x32)
  }
  num:=info.Length(), j:=info[index]
  , text:=j[1], w:=j[2], h:=j[3]
  , e1:=(!j[12] ? Floor(j[4]*err1) : j[6])
  , e0:=(!j[12] ? Floor(j[5]*err0) : j[7])
  , mode:=j[8], color:=j[9], n:=j[10], comment:=j[11]
  , sx:=ini.sx, sy:=ini.sy, sw:=ini.sw, sh:=ini.sh
  if (JoinText and index>1)
  {
    x:=ini.x, y:=ini.y, sw:=Min(x+offsetX+w,sx+sw), sx:=x, sw-=sx
    , sh:=Min(y+offsetY+h,sy+sh), sy:=Max(y-offsetY,sy), sh-=sy
    , allpos_max:=1
  }
  ok:=!bits.Scan0 ? 0 : DllCall(&MyFunc
    , "int",mode, "uint",color, "uint",n, "int",dir
    , "Ptr",bits.Scan0, "int",bits.Stride
    , "int",ini.zw, "int",ini.zh
    , "int",sx, "int",sy, "int",sw, "int",sh
    , "Ptr",&ss, "Ptr",&s1, "Ptr",&s0
    , "AStr",text, "int",w, "int",h, "int",e1, "int",e0
    , "Ptr",&allpos, "int",allpos_max)
  Loop % ok
  {
    x:=NumGet(allpos, 8*A_Index-8, "uint")
    , y:=NumGet(allpos, 8*A_Index-4, "uint")
    if (!JoinText)
    {
      x1:=x+ini.zx, y1:=y+ini.zy
      , arr.Push( {1:x1, 2:y1, 3:w, 4:h
      , x:x1+w//2, y:y1+h//2, id:comment} )
    }
    else if (index=1)
    {
      ini.x:=x+w, ini.y:=y, ini.minY:=y, ini.maxY:=y+h
      Loop % num-1
        if !this.PicFind(arr, ini, info, A_Index+1, err1, err0
        , FindAll, JoinText, offsetX, offsetY, 5
        , bits, ss, s1, s0, allpos, 1)
          Continue, 2
      x1:=x+ini.zx, y1:=ini.minY+ini.zy
      , w1:=ini.x-x, h1:=ini.maxY-ini.minY
      , arr.Push( {1:x1, 2:y1, 3:w1, 4:h1
      , x:x1+w1//2, y:y1+h1//2, id:ini.comment} )
    }
    else
    {
      ini.x:=x+w, ini.y:=y
      , (y<ini.minY && ini.minY:=y)
      , (y+h>ini.maxY && ini.maxY:=y+h)
      return 1
    }
    if (!FindAll)
      return
  }
}

GetBitsFromScreen(ByRef x:=0, ByRef y:=0, ByRef w:=0, ByRef h:=0
  , ScreenShot:=1, ByRef zx:="", ByRef zy:="", ByRef zw:="", ByRef zh:="")
{
  local
  (!IsObject(this.bits) && this.bits:=[]), bits:=this.bits
  if (!ScreenShot and bits.Scan0)
  {
    zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
    if IsByRef(x)
      w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x
      , h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
    return bits
  }
  bch:=A_BatchLines, cri:=A_IsCritical
  Critical
  if (id:=this.BindWindow(0,0,1))
  {
    WinGet, id, ID, ahk_id %id%
    WinGetPos, zx, zy, zw, zh, ahk_id %id%
  }
  if (!id)
  {
    SysGet, zx, 76
    SysGet, zy, 77
    SysGet, zw, 78
    SysGet, zh, 79
  }
  bits.zx:=zx, bits.zy:=zy, bits.zw:=zw, bits.zh:=zh
  , w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x
  , h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
  if (zw>bits.oldzw or zh>bits.oldzh or !bits.hBM)
  {
    DllCall("DeleteObject", "Ptr",bits.hBM)
    , bits.hBM:=this.CreateDIBSection(zw, zh, bpp:=32, ppvBits)
    , bits.Scan0:=(!bits.hBM ? 0:ppvBits)
    , bits.Stride:=((zw*bpp+31)//32)*4
    , bits.oldzw:=zw, bits.oldzh:=zh
  }
  if (!ScreenShot or w<1 or h<1 or !bits.hBM)
  {
    Critical, %cri%
    SetBatchLines, %bch%
    return bits
  }
  if IsFunc(k:="GetBitsFromScreen2")
    and %k%(bits, x-zx, y-zy, w, h)
  {
    zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
    Critical, %cri%
    SetBatchLines, %bch%
    return bits
  }
  mDC:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM:=DllCall("SelectObject", "Ptr",mDC, "Ptr",bits.hBM, "Ptr")
  if (id)
  {
    if (mode:=this.BindWindow(0,0,0,1))<2
    {
      hDC2:=DllCall("GetDCEx", "Ptr",id, "Ptr",0, "int",3, "Ptr")
      DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , "Ptr",hDC2, "int",x-zx, "int",y-zy, "uint",0xCC0020|0x40000000)
      DllCall("ReleaseDC", "Ptr",id, "Ptr",hDC2)
    }
    else
    {
      hBM2:=this.CreateDIBSection(zw, zh)
      mDC2:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
      oBM2:=DllCall("SelectObject", "Ptr",mDC2, "Ptr",hBM2, "Ptr")
      DllCall("PrintWindow", "Ptr",id, "Ptr",mDC2, "uint",(mode>3)*3)
      DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , "Ptr",mDC2, "int",x-zx, "int",y-zy, "uint",0xCC0020|0x40000000)
      DllCall("SelectObject", "Ptr",mDC2, "Ptr",oBM2)
      DllCall("DeleteDC", "Ptr",mDC2)
      DllCall("DeleteObject", "Ptr",hBM2)
    }
  }
  else
  {
    win:=DllCall("GetDesktopWindow", "Ptr")
    hDC:=DllCall("GetWindowDC", "Ptr",win, "Ptr")
    DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
      , "Ptr",hDC, "int",x, "int",y, "uint",0xCC0020|0x40000000)
    DllCall("ReleaseDC", "Ptr",win, "Ptr",hDC)
  }
  if this.CaptureCursor(0,0,0,0,0,1)
    this.CaptureCursor(mDC, zx, zy, zw, zh)
  DllCall("SelectObject", "Ptr",mDC, "Ptr",oBM)
  DllCall("DeleteDC", "Ptr",mDC)
  Critical, %cri%
  SetBatchLines, %bch%
  return bits
}

CreateDIBSection(w, h, bpp:=32, ByRef ppvBits:=0, ByRef bi:="")
{
  VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
  , NumPut(w, bi, 4, "int"), NumPut(-h, bi, 8, "int")
  , NumPut(1, bi, 12, "short"), NumPut(bpp, bi, 14, "short")
  return DllCall("CreateDIBSection", "Ptr",0, "Ptr",&bi
    , "int",0, "Ptr*",ppvBits:=0, "Ptr",0, "int",0, "Ptr")
}

PicInfo(text)
{
  local
  static info:=[]
  if !InStr(text,"$")
    return
  key:=(r:=StrLen(text))<1000 ? text
    : DllCall("ntdll\RtlComputeCrc32", "uint",0
    , "Ptr",&text, "uint",r*(1+!!A_IsUnicode), "uint")
  if (info[key])
    return info[key]
  v:=text, comment:="", seterr:=e1:=e0:=0
  ; You Can Add Comment Text within The <>
  if RegExMatch(v,"<([^>\n]*)>",r)
    v:=StrReplace(v,r), comment:=Trim(r1)
  ; You can Add two fault-tolerant in the [], separated by commas
  if RegExMatch(v,"\[([^\]\n]*)]",r)
  {
    v:=StrReplace(v,r), r:=StrSplit(r1, ",")
    , seterr:=1, e1:=r[1], e0:=r[2]
  }
  color:=StrSplit(v,"$")[1], v:=Trim(SubStr(v,InStr(v,"$")+1))
  mode:=InStr(color,"##") ? 5
    : InStr(color,"-") ? 4 : InStr(color,"#") ? 3
    : InStr(color,"**") ? 2 : InStr(color,"*") ? 1 : 0
  color:=RegExReplace(color, "[*#\s]")
  if (mode=5)
  {
    if (v~="[^\s\w/]") and FileExist(v)  ; ImageSearch
    {
      if !(hBM:=LoadPicture(v))
        return
      this.GetBitmapWH(hBM, w, h)
      if (w<1 or h<1)
        return
      hBM2:=this.CreateDIBSection(w, h, 32, Scan0)
      this.CopyHBM(hBM2, 0, 0, hBM, 0, 0, w, h)
      DllCall("DeleteObject", "Ptr",hBM)
      if (!Scan0)
        return
      c1:=NumGet(Scan0+0,"uint")&0xFFFFFF
      c2:=NumGet(Scan0+(w-1)*4,"uint")&0xFFFFFF
      c3:=NumGet(Scan0+(w*h-w)*4,"uint")&0xFFFFFF
      c4:=NumGet(Scan0+(w*h-1)*4,"uint")&0xFFFFFF
      if (c1!=c2 or c1!=c3 or c1!=c4)
        c1:=-1
      VarSetCapacity(v, w*h*18*(1+!!A_IsUnicode)), i:=-4, n:=0
      SetFormat, IntegerFast, d
      Loop %h%
      {
        y:=A_Index-1
        Loop %w%
          if (c:=NumGet(Scan0+(i+=4),"uint")&0xFFFFFF)!=c1
            v.=(A_Index-1)|y<<16|c<<32 . "/", n++
      }
      DllCall("DeleteObject", "Ptr",hBM2)
    }
    else
    {
      v:=Trim(StrReplace(RegExReplace(v,"\s"),",","/"),"/")
      r:=StrSplit(v,"/"), n:=r.Length()//3
      if (!n)
        return
      VarSetCapacity(v, n*18*(1+!!A_IsUnicode))
      x1:=x2:=r[1], y1:=y2:=r[2]
      SetFormat, IntegerFast, d
      Loop % n + (i:=-2)*0
        x:=r[i+=3], y:=r[i+1]
        , (x<x1 && x1:=x), (x>x2 && x2:=x)
        , (y<y1 && y1:=y), (y>y2 && y2:=y)
      Loop % n + (i:=-2)*0
        v.=(r[i+=3]-x1)|(r[i+1]-y1)<<16|(Floor("0x"
        . StrReplace(r[i+2],"0x"))&0xFFFFFF)<<32 . "/"
      w:=x2-x1+1, h:=y2-y1+1
    }
    len1:=n, len0:=0
  }
  else
  {
    r:=StrSplit(v,"."), w:=r[1]
    , v:=this.base64tobit(r[2]), h:=StrLen(v)//w
    if (w<1 or h<1 or StrLen(v)!=w*h)
      return
    if (mode=4)
    {
      r:=StrSplit(StrReplace(color,"0x"),"-")
      , color:=Floor("0x" r[1]), n:=Floor("0x" r[2])
    }
    else
    {
      r:=StrSplit(color,"@")
      , color:=r[1], n:=Round(r[2],2)+(!r[2])
      , n:=Floor(512*9*255*255*(1-n)*(1-n))
      if (mode=3)
        color:=(((color-1)//w)<<16)|Mod(color-1,w)
    }
    StrReplace(v,"1","",len1), len0:=StrLen(v)-len1
  }
  e1:=Floor(len1*e1), e0:=Floor(len0*e0)
  return info[key]:=[v, w, h, len1, len0, e1, e0
    , mode, color, n, comment, seterr]
}

GetBitmapWH(hBM, ByRef w, ByRef h)
{
  local
  VarSetCapacity(bm, size:=(A_PtrSize=8 ? 32:24), 0)
  r:=DllCall("GetObject", "Ptr",hBM, "int",size, "Ptr",&bm)
  w:=NumGet(bm,4,"int"), h:=Abs(NumGet(bm,8,"int"))
  return r
}

CopyHBM(hBM1, x1, y1, hBM2, x2, y2, w2, h2)
{
  local
  if (w2<1 or h2<1 or !hBM1 or !hBM2)
    return
  mDC1:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM1:=DllCall("SelectObject", "Ptr",mDC1, "Ptr",hBM1, "Ptr")
  mDC2:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM2:=DllCall("SelectObject", "Ptr",mDC2, "Ptr",hBM2, "Ptr")
  DllCall("BitBlt", "Ptr",mDC1
    , "int",x1, "int",y1, "int",w2, "int",h2, "Ptr",mDC2
    , "int",x2, "int",y2, "uint",0xCC0020)
  DllCall("SelectObject", "Ptr",mDC2, "Ptr",oBM2)
  DllCall("DeleteDC", "Ptr",mDC2)
  DllCall("SelectObject", "Ptr",mDC1, "Ptr",oBM1)
  DllCall("DeleteDC", "Ptr",mDC1)
}

CopyBits(Scan01,Stride1,x1,y1,Scan02,Stride2,x2,y2,w2,h2,Reverse:=0)
{
  local
  if (w2<1 or h2<1 or !Scan01 or !Scan02)
    return
  p1:=Scan01+(y1-1)*Stride1+x1*4
  , p2:=Scan02+(y2-1)*Stride2+x2*4, w2*=4
  if (Reverse)
    p2+=(h2+1)*Stride2, Stride2:=-Stride2
  Loop % h2
    DllCall("RtlMoveMemory","Ptr",p1+=Stride1,"Ptr",p2+=Stride2,"Ptr",w2)
}

; Bind the window so that it can find images when obscured
; by other windows, it's equivalent to always being
; at the front desk. Unbind Window using FindText().BindWindow(0)

BindWindow(bind_id:=0, bind_mode:=0, get_id:=0, get_mode:=0)
{
  local
  (!IsObject(this.bind) && this.bind:=[]), bind:=this.bind
  if (get_id)
    return bind.id
  if (get_mode)
    return bind.mode
  if (bind_id)
  {
    bind.id:=bind_id, bind.mode:=bind_mode, bind.oldStyle:=0
    if (bind_mode & 1)
    {
      WinGet, oldStyle, ExStyle, ahk_id %bind_id%
      bind.oldStyle:=oldStyle
      WinSet, Transparent, 255, ahk_id %bind_id%
      Loop 30
      {
        Sleep, 100
        WinGet, i, Transparent, ahk_id %bind_id%
      }
      Until (i=255)
    }
  }
  else
  {
    bind_id:=bind.id
    if (bind.mode & 1)
      WinSet, ExStyle, % bind.oldStyle, ahk_id %bind_id%
    bind.id:=0, bind.mode:=0, bind.oldStyle:=0
  }
}

; Use FindText().CaptureCursor(1) to Capture Cursor
; Use FindText().CaptureCursor(0) to Cancel Capture Cursor

CaptureCursor(hDC:=0, zx:=0, zy:=0, zw:=0, zh:=0, get_cursor:=0)
{
  local
  if (get_cursor)
    return this.Cursor
  if (hDC=1 or hDC=0) and (zw=0)
  {
    this.Cursor:=hDC
    return
  }
  VarSetCapacity(mi, 40, 0), NumPut(16+A_PtrSize, mi, "int")
  DllCall("GetCursorInfo", "Ptr",&mi)
  bShow   := NumGet(mi, 4, "int")
  hCursor := NumGet(mi, 8, "Ptr")
  x := NumGet(mi, 8+A_PtrSize, "int")
  y := NumGet(mi, 12+A_PtrSize, "int")
  if (!bShow) or (x<zx or y<zy or x>=zx+zw or y>=zy+zh)
    return
  VarSetCapacity(ni, 40, 0)
  DllCall("GetIconInfo", "Ptr",hCursor, "Ptr",&ni)
  xCenter  := NumGet(ni, 4, "int")
  yCenter  := NumGet(ni, 8, "int")
  hBMMask  := NumGet(ni, (A_PtrSize=8?16:12), "Ptr")
  hBMColor := NumGet(ni, (A_PtrSize=8?24:16), "Ptr")
  DllCall("DrawIconEx", "Ptr",hDC
    , "int",x-xCenter-zx, "int",y-yCenter-zy, "Ptr",hCursor
    , "int",0, "int",0, "int",0, "int",0, "int",3)
  DllCall("DeleteObject", "Ptr",hBMMask)
  DllCall("DeleteObject", "Ptr",hBMColor)
}

MCode(ByRef code, hex)
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  VarSetCapacity(code, len:=StrLen(hex)//2)
  Loop % len
    NumPut("0x" SubStr(hex,2*A_Index-1,2),code,A_Index-1,"uchar")
  DllCall("VirtualProtect","Ptr",&code,"Ptr",len,"uint",0x40,"Ptr*",0)
  SetBatchLines, %bch%
}

base64tobit(s)
{
  local
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  Loop Parse, Chars
  {
    s:=RegExReplace(s, "[" A_LoopField "]"
    , StrReplace( ((i:=A_Index-1)>>5&1) . (i>>4&1)
    . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1), "0x"))
  }
  return RegExReplace(RegExReplace(s,"[^01]+"),"10*$")
}

bit2base64(s)
{
  local
  s:=RegExReplace(s,"[^01]+")
  s.=SubStr("100000",1,6-Mod(StrLen(s),6))
  s:=RegExReplace(s,".{6}","|$0")
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  Loop Parse, Chars
  {
    s:=StrReplace(s, StrReplace("|" . ((i:=A_Index-1)>>5&1)
    . (i>>4&1) . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    , "0x"), A_LoopField)
  }
  return s
}

xywh2xywh(x1,y1,w1,h1, ByRef x, ByRef y, ByRef w, ByRef h
  , ByRef zx:="", ByRef zy:="", ByRef zw:="", ByRef zh:="")
{
  SysGet, zx, 76
  SysGet, zy, 77
  SysGet, zw, 78
  SysGet, zh, 79
  w:=Min(x1+w1,zx+zw), x:=Max(x1,zx), w-=x
  , h:=Min(y1+h1,zy+zh), y:=Max(y1,zy), h-=y
}

ASCII(s)
{
  local
  if RegExMatch(s,"\$(\d+)\.([\w+/]+)",r)
  {
    s:=RegExReplace(this.base64tobit(r2),".{" r1 "}","$0`n")
    s:=StrReplace(StrReplace(s,"0","_"),"1","0")
  }
  else s:=""
  return s
}

; You can put the text library at the beginning of the script,
; and Use FindText().PicLib(Text,1) to add the text library to PicLib()'s Lib,
; Use FindText().PicLib("comment1|comment2|...") to get text images from Lib

PicLib(comments, add_to_Lib:=0, index:=1)
{
  local
  (!IsObject(this.Lib) && this.Lib:=[]), Lib:=this.Lib
  , (!Lib[index] && Lib[index]:=[]), Lib:=Lib[index]
  if (add_to_Lib)
  {
    re:="<([^>\n]*)>[^$\n]+\$\d+\.[\w+/]+"
    Loop Parse, comments, |
      if RegExMatch(A_LoopField,re,r)
      {
        s1:=Trim(r1), s2:=""
        Loop Parse, s1
          s2.="_" . Format("{:d}",Ord(A_LoopField))
        Lib[s2]:=r
      }
    Lib[""]:=""
  }
  else
  {
    Text:=""
    Loop Parse, comments, |
    {
      s1:=Trim(A_LoopField), s2:=""
      Loop Parse, s1
        s2.="_" . Format("{:d}",Ord(A_LoopField))
      Text.="|" . Lib[s2]
    }
    return Text
  }
}

; Decompose a string into individual characters and get their data

PicN(Number, index:=1)
{
  return this.PicLib(RegExReplace(Number,".","|$0"), 0, index)
}

; Use FindText().PicX(Text) to automatically cut into multiple characters
; Can't be used in ColorPos mode, because it can cause position errors

PicX(Text)
{
  local
  if !RegExMatch(Text,"(<[^$\n]+)\$(\d+)\.([\w+/]+)",r)
    return Text
  v:=this.base64tobit(r3), Text:=""
  c:=StrLen(StrReplace(v,"0"))<=StrLen(v)//2 ? "1":"0"
  txt:=RegExReplace(v,".{" r2 "}","$0`n")
  While InStr(txt,c)
  {
    While !(txt~="m`n)^" c)
      txt:=RegExReplace(txt,"m`n)^.")
    i:=0
    While (txt~="m`n)^.{" i "}" c)
      i:=Format("{:d}",i+1)
    v:=RegExReplace(txt,"m`n)^(.{" i "}).*","$1")
    txt:=RegExReplace(txt,"m`n)^.{" i "}")
    if (v!="")
      Text.="|" r1 "$" i "." this.bit2base64(v)
  }
  return Text
}

; Screenshot and retained as the last screenshot.

ScreenShot(x1:=0, y1:=0, x2:=0, y2:=0)
{
  this.FindText(0, 0, x1, y1, x2, y2)
}

; Get the RGB color of a point from the last screenshot.
; If the point to get the color is beyond the range of
; Screen, it will return White color (0xFFFFFF).

GetColor(x, y, fmt:=1)
{
  local
  bits:=this.GetBitsFromScreen(0,0,0,0,0,zx,zy,zw,zh)
  , c:=(x<zx or x>=zx+zw or y<zy or y>=zy+zh or !bits.Scan0)
  ? 0xFFFFFF : NumGet(bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4,"uint")
  return (fmt ? Format("0x{:06X}",c&0xFFFFFF) : c)
}

; Set the RGB color of a point in the last screenshot

SetColor(x, y, color:=0x000000)
{
  local
  bits:=this.GetBitsFromScreen(0,0,0,0,0,zx,zy,zw,zh)
  if !(x<zx or x>=zx+zw or y<zy or y>=zy+zh or !bits.Scan0)
    NumPut(color,bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4,"uint")
}

; Identify a line of text or verification code
; based on the result returned by FindText().
; offsetX is the maximum interval between two texts,
; if it exceeds, a "*" sign will be inserted.
; offsetY is the maximum height difference between two texts.
; overlapW is used to set the width of the overlap.
; Return Association array {text:Text, x:X, y:Y, w:W, h:H}

Ocr(ok, offsetX:=20, offsetY:=20, overlapW:=0)
{
  local
  ocr_Text:=ocr_X:=ocr_Y:=min_X:=dx:=""
  For k,v in ok
    x:=v[1]
    , min_X:=(A_Index=1 or x<min_X ? x : min_X)
    , max_X:=(A_Index=1 or x>max_X ? x : max_X)
  While (min_X!="" and min_X<=max_X)
  {
    LeftX:=""
    For k,v in ok
    {
      x:=v[1], y:=v[2]
      if (x<min_X) or Abs(y-ocr_Y)>offsetY
        Continue
      ; Get the leftmost X coordinates
      if (LeftX="" or x<LeftX)
        LeftX:=x, LeftY:=y, LeftW:=v[3], LeftH:=v[4], LeftOCR:=v.id
    }
    if (LeftX="")
      Break
    if (ocr_X="")
      ocr_X:=LeftX, min_Y:=LeftY, max_Y:=LeftY+LeftH
    ; If the interval exceeds the set value, add "*" to the result
    ocr_Text.=(ocr_Text!="" and LeftX>dx ? "*":"") . LeftOCR
    ; Update for next search
    min_X:=LeftX+LeftW-(overlapW>LeftW//2 ? LeftW//2:overlapW)
    , dx:=LeftX+LeftW+offsetX, ocr_Y:=LeftY
    , (LeftY<min_Y && min_Y:=LeftY)
    , (LeftY+LeftH>max_Y && max_Y:=LeftY+LeftH)
  }
  return {text:ocr_Text, x:ocr_X, y:min_Y
    , w: min_X-ocr_X, h: max_Y-min_Y}
}

; Sort the results returned by FindText() from left to right
; and top to bottom, ignore slight height difference

Sort(ok, dy:=10)
{
  local
  if !IsObject(ok)
    return ok
  ypos:=[]
  For k,v in ok
  {
    x:=v.x, y:=v.y, add:=1
    For k2,v2 in ypos
      if Abs(y-v2)<=dy
      {
        y:=v2, add:=0
        Break
      }
    if (add)
      ypos.Push(y)
    n:=(y*150000+x) "." k, s:=A_Index=1 ? n : s "-" n
  }
  Sort, s, N D-
  ok2:=[]
  Loop Parse, s, -
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return ok2
}

; Reordering according to the nearest distance

Sort2(ok, px, py)
{
  local
  if !IsObject(ok)
    return ok
  For k,v in ok
    n:=((v.x-px)**2+(v.y-py)**2) "." k, s:=A_Index=1 ? n : s "-" n
  Sort, s, N D-
  ok2:=[]
  Loop Parse, s, -
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return ok2
}

; Prompt mouse position in remote assistance

MouseTip(x:="", y:="", w:=10, h:=10, d:=4)
{
  local
  if (x="")
  {
    VarSetCapacity(pt,16,0), DllCall("GetCursorPos","ptr",&pt)
    x:=NumGet(pt,0,"uint"), y:=NumGet(pt,4,"uint")
  }
  x:=Round(x-w-d), y:=Round(y-h-d), w:=(2*w+1)+2*d, h:=(2*h+1)+2*d
  ;-------------------------
  Gui, _MouseTip_: +AlwaysOnTop -Caption +ToolWindow +Hwndmyid -DPIScale
  Gui, _MouseTip_: Show, Hide w%w% h%h%
  ;-------------------------
  DetectHiddenWindows, % (dhw:=A_DetectHiddenWindows)?"On":"On"
  i:=w-d, j:=h-d
  s:="0-0 " (w "-0 ") (w "-" h) (" 0-" h) " 0-0  "
    . (d "-" d) " " (i "-" d) " " (i "-" j) " " (d "-" j) " " (d "-" d)
  WinSet, Region, %s%, ahk_id %myid%
  DetectHiddenWindows, %dhw%
  ;-------------------------
  Gui, _MouseTip_: Show, NA x%x% y%y%
  Loop 4
  {
    Gui, _MouseTip_: Color, % A_Index & 1 ? "Red" : "Blue"
    Sleep, 500
  }
  Gui, _MouseTip_: Destroy
}

; Quickly get the search data of screen image

GetTextFromScreen(x1, y1, x2, y2, Threshold:=""
  , ScreenShot:=1, ByRef rx:="", ByRef ry:="")
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy,zw,zh)
  if (w<1 or h<1)
  {
    SetBatchLines, %bch%
    return
  }
  gs:=[], k:=0
  Loop %h%
  {
    j:=y+A_Index-1
    Loop %w%
      i:=x+A_Index-1, c:=this.GetColor(i,j,0)
      , gs[++k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
  }
  if InStr(Threshold,"**")
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
      Threshold:=50
    s:="", sw:=w, w-=2, h-=2, x++, y++
    Loop %h%
    {
      y1:=A_Index
      Loop %w%
        x1:=A_Index, i:=y1*sw+x1+1, j:=gs[i]+Threshold
        , s.=( gs[i-1]>j || gs[i+1]>j
        || gs[i-sw]>j || gs[i+sw]>j
        || gs[i-sw-1]>j || gs[i-sw+1]>j
        || gs[i+sw-1]>j || gs[i+sw+1]>j ) ? "1":"0"
    }
    Threshold:="**" Threshold
  }
  else
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
    {
      pp:=[]
      Loop 256
        pp[A_Index-1]:=0
      Loop % w*h
        pp[gs[A_Index]]++
      IP0:=IS0:=0
      Loop 256
        k:=A_Index-1, IP0+=k*pp[k], IS0+=pp[k]
      Threshold:=Floor(IP0/IS0)
      Loop 20
      {
        LastThreshold:=Threshold
        IP1:=IS1:=0
        Loop % LastThreshold+1
          k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
        IP2:=IP0-IP1, IS2:=IS0-IS1
        if (IS1!=0 and IS2!=0)
          Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
        if (Threshold=LastThreshold)
          Break
      }
    }
    s:=""
    Loop % w*h
      s.=gs[A_Index]<=Threshold ? "1":"0"
    Threshold:="*" Threshold
  }
  ;--------------------
  w:=Format("{:d}",w), CutUp:=CutDown:=0
  re1:="(^0{" w "}|^1{" w "})"
  re2:="(0{" w "}$|1{" w "}$)"
  While RegExMatch(s,re1)
    s:=RegExReplace(s,re1), CutUp++
  While RegExMatch(s,re2)
    s:=RegExReplace(s,re2), CutDown++
  rx:=x+w//2, ry:=y+CutUp+(h-CutUp-CutDown)//2
  s:="|<>" Threshold "$" w "." this.bit2base64(s)
  ;--------------------
  SetBatchLines, %bch%
  return s
}

; Quickly save screen image to BMP file for debugging

SavePic(file, x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 or h<1 or !bits.Scan0)
    return
  hBM:=this.CreateDIBSection(w, -h, bpp:=24, ppvBits, bi)
  hBM2:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
  this.CopyHBM(hBM, 0, 0, hBM2, 0, 0, w, h)
  DllCall("DeleteObject", "Ptr",hBM2)
  size:=((w*bpp+31)//32)*4*h, NumPut(size, bi, 20, "uint")
  VarSetCapacity(bf, 14, 0), StrPut("BM", &bf, "CP0")
  NumPut(54+size, bf, 2, "uint"), NumPut(54, bf, 10, "uint")
  f:=FileOpen(file,"w"), f.RawWrite(bf,14), f.RawWrite(bi,40)
  , f.RawWrite(ppvBits+0, size), f.Close()
  DllCall("DeleteObject", "Ptr",hBM)
}

; Show the saved Picture file

ShowPic(file:="", show:=1, ByRef x:="", ByRef y:="", ByRef w:="", ByRef h:="")
{
  local
  if (file="")
  {
    this.ShowScreenShot()
    return
  }
  if !FileExist(file) or !(hBM:=LoadPicture(file))
    return
  this.GetBitmapWH(hBM, w, h)
  bits:=this.GetBitsFromScreen(0,0,0,0,0,x,y)
  this.CopyHBM(bits.hBM, 0, 0, hBM, 0, 0, w, h)
  DllCall("DeleteObject", "Ptr",hBM)
  if (show)
    this.ShowScreenShot(x, y, x+w-1, y+h-1, 0)
}

; Show the memory Screenshot for debugging

ShowScreenShot(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  static hPic, oldw, oldh
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
  {
    Gui, FindText_Screen: Destroy
    return
  }
  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 or h<1 or !bits.Scan0)
    return
  hBM:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
  ;---------------
  Gui, FindText_Screen: +LastFoundExist
  IfWinNotExist
  {
    Gui, FindText_Screen: +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000
    Gui, FindText_Screen: Margin, 0, 0
    Gui, FindText_Screen: Add, Pic, HwndhPic w%w% h%h%
    Gui, FindText_Screen: Show, NA x%zx% y%zy% w%w% h%h%, Show Pic
  }
  if (oldw!=w or oldh!=h)
  {
    oldw:=w, oldh:=h
    GuiControl, FindText_Screen: Move, %hPic%, w%w% h%h%
    Gui, FindText_Screen: Show, NA w%w% h%h%
  }
  mDC:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM:=DllCall("SelectObject", "Ptr",mDC, "Ptr",hBM, "Ptr")
  DllCall("BitBlt", "Ptr",mDC, "int",0, "int",0, "int",w, "int",h
    , "Ptr",mDC, "int",0, "int",0, "uint",0xC000CA) ; MERGECOPY
  ;---------------
  hDC:=DllCall("GetDC", "Ptr",hPic, "Ptr")
  DllCall("BitBlt", "Ptr",hDC, "int",0, "int",0, "int",w, "int",h
    , "Ptr",mDC, "int",0, "int",0, "uint",0xCC0020)
  DllCall("ReleaseDC", "Ptr",hPic, "Ptr",hDC)
  ;---------------
  DllCall("SelectObject", "Ptr",mDC, "Ptr",oBM)
  DllCall("DeleteDC", "Ptr",mDC)
  DllCall("DeleteObject", "Ptr",hBM)
}

; Wait for the screen image to change within a few seconds
; Take a Screenshot before using it: FindText().ScreenShot()

WaitChange(time:=-1, x1:=0, y1:=0, x2:=0, y2:=0)
{
  local
  hash:=this.GetPicHash(x1, y1, x2, y2, 0)
  timeout:=A_TickCount+Round(time*1000)
  Loop
  {
    if this.GetPicHash(x1, y1, x2, y2, 1)!=hash
      return 1
    if (time>=0 and A_TickCount>=timeout)
      Break
    Sleep, 10
  }
  return 0
}

GetPicHash(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  static h:=DllCall("LoadLibrary", "Str","ntdll", "Ptr")
  if (x1*x1+y1*y1+x2*x2+y2*y2<=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 or h<1 or !bits.Scan0)
    return 0
  hash:=0, Stride:=bits.Stride, p:=bits.Scan0+(y-1)*Stride+x*4, w*=4
  Loop % h
    hash:=(hash*31+DllCall("ntdll\RtlComputeCrc32", "uint",0
      , "Ptr",p+=Stride, "uint",w, "uint"))&0xFFFFFFFF
  return hash
}

WindowToScreen(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  WinGetPos, winx, winy,,, % id ? "ahk_id " id : "A"
  x:=x1+Floor(winx), y:=y1+Floor(winy)
}

ScreenToWindow(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  this.WindowToScreen(dx,dy,0,0,id), x:=x1-dx, y:=y1-dy
}

ClientToScreen(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  if (!id)
    WinGet, id, ID, A
  VarSetCapacity(pt,8,0), NumPut(0,pt,"int64")
  , DllCall("ClientToScreen", "Ptr",id, "Ptr",&pt)
  , x:=x1+NumGet(pt,"int"), y:=y1+NumGet(pt,4,"int")
}

ScreenToClient(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  this.ClientToScreen(dx,dy,0,0,id), x:=x1-dx, y:=y1-dy
}

; It is not like FindText always use Screen Coordinates,
; But like built-in command ImageSearch using CoordMode Settings

ImageSearch(ByRef rx, ByRef ry, x1, y1, x2, y2, text
  , ScreenShot:=1, FindAll:=0)
{
  local
  dx:=dy:=0
  if (A_CoordModePixel="Window")
    this.WindowToScreen(dx,dy,0,0)
  else if (A_CoordModePixel="Client")
    this.ClientToScreen(dx,dy,0,0)
  if FileExist(pic:=RegExReplace(text,"\*\S+\s+"))
    text:="|<>##0$" pic
  if (ok:=this.FindText(x, y, x1+dx, y1+dy, x2+dx, y2+dy
    , 0, 0, text, ScreenShot, FindAll))
  {
    rx:=x-dx, ry:=y-dy, ErrorLevel:=0
    return 1
  }
  else
  {
    rx:=ry:="", ErrorLevel:=1
    return 0
  }
}

Click(x:="", y:="", other:="")
{
  local
  bak:=A_CoordModeMouse
  CoordMode, Mouse, Screen
  MouseMove, x, y, 0
  Click, %x%, %y%, %other%
  CoordMode, Mouse, %bak%
}

; Running AHK code dynamically with new threads

Class Thread
{
  __New(args*)
  {
    this.pid:=this.Exec(args*)
  }
  __Delete()
  {
    DetectHiddenWindows, On
    IfWinExist, % "ahk_class AutoHotkey ahk_pid " this.pid
    {
      PostMessage, 0x111, 65307
      WinWaitClose,,, 0.5
      IfEqual, ErrorLevel, 1, Process, Close, % this.pid
    }
  }
  Exec(s, Ahk:="", args:="")
  {
    local
    Ahk:=Ahk ? Ahk:A_IsCompiled ? A_ScriptDir "\AutoHotkey.exe":A_AhkPath
    s:="DllCall(""SetWindowText"",""Ptr"",A_ScriptHwnd,""Str"",""<AHK>"")`n"
      . StrReplace(s,"`r")
    Try
    {
      shell:=ComObjCreate("WScript.Shell")
      oExec:=shell.Exec("""" Ahk """ /force * " args)
      oExec.StdIn.Write(s)
      oExec.StdIn.Close(), pid:=oExec.ProcessID
    }
    Catch
    {
      f:=A_Temp "\~ahk.tmp"
      s:="`n FileDelete, " f "`n" s
      FileDelete, %f%
      FileAppend, %s%, %f%
      r:=this.Clear.Bind(this)
      SetTimer, %r%, -3000
      Run, "%Ahk%" /force "%f%" %args%,, UseErrorLevel, pid
    }
    return pid
  }
  Clear()
  {
    FileDelete, % A_Temp "\~ahk.tmp"
    SetTimer,, Off
  }
}

; FindText().QPC() Use the same as A_TickCount

QPC()
{
  static f:=0, c:=DllCall("QueryPerformanceFrequency", "Int*",f)
  return (!DllCall("QueryPerformanceCounter","Int64*",c))*0+(c/f)*1000
}

; FindText().ToolTip() Use the same as ToolTip

ToolTip(s:="", x:="", y:="", num:=1, arg:="")
{
  local
  static ini:=[]
  f:= "ToolTip_" . Round(num)
  if (s="")
  {
    ini.Delete(f)
    Gui, %f%: Destroy
    return
  }
  ;-----------------
  r1:=A_CoordModeToolTip
  r2:=A_CoordModeMouse
  CoordMode, Mouse, Screen
  MouseGetPos, x1, y1
  CoordMode, Mouse, %r1%
  MouseGetPos, x2, y2
  CoordMode, Mouse, %r2%
  x:=Round(x="" ? x1+16 : x+x1-x2)
  y:=Round(y="" ? y1+16 : y+y1-y2)
  ;-----------------
  bgcolor:=arg.bgcolor ? arg.bgcolor : "FAFBFC"
  color:=arg.color ? arg.color : "Black"
  font:=arg.font ? arg.font : "Consolas"
  size:=arg.size ? arg.size : "8"
  bold:=arg.bold ? arg.bold : ""
  ;-----------------
  r:=bgcolor "|" color "|" font "|" size "|" bold "|" s
  if (ini[f]!=r)
  {
    ini[f]:=r
    Gui, %f%: Destroy
    Gui, %f%: +AlwaysOnTop -Caption +ToolWindow +Border -DPIScale +E0x08000000
    Gui, %f%: Margin, 2, 2
    Gui, %f%: Color, %bgcolor%
    Gui, %f%: Font, c%color% s%size% %bold%, %font%
    Gui, %f%: Add, Text,, %s%
    Gui, %f%: Show, Hide, %f%
  }
  Gui, %f%: +AlwaysOnTop
  Gui, %f%: Show, NA x%x% y%y%
}

; FindText().ObjView()  view object values for Debug

ObjView(obj, keyname="")
{
  if IsObject(obj)  ; thanks lexikos's type(v)
  {
    s:=""
    For k,v in obj
      s.=this.ObjView(v, keyname "[" ([k].GetCapacity(1)?"""" k """":k) "]")
  }
  else
    s:=keyname ": " ([obj].GetCapacity(1) ? """" obj """":obj) "`n"
  if (keyname!="")
    return s
  ;------------------
  Gui, Gui_DeBug_Gui: Destroy
  Gui, Gui_DeBug_Gui: +AlwaysOnTop +Hwndid
  Gui, Gui_DeBug_Gui: Add, Button, y270 w350 gCancel Default, OK
  Gui, Gui_DeBug_Gui: Add, Edit, xp y10 w350 h250 -WantReturn, %s%
  Gui, Gui_DeBug_Gui: Show,, Debug view object values
  DetectHiddenWindows, Off
  WinWaitClose, ahk_id %id%
  Gui, Gui_DeBug_Gui: Destroy
}


/***** C source code of machine code *****

int __attribute__((__stdcall__)) PicFind(
  int mode, unsigned int c, unsigned int n, int dir
  , unsigned char * Bmp, int Stride, int zw, int zh
  , int sx, int sy, int sw, int sh
  , char * ss, unsigned int * s1, unsigned int * s0
  , char * text, int w, int h, int err1, int err0
  , unsigned int * allpos, int allpos_max )
{
  int ok=0, o, i, j, k, v, r, g, b, rr, gg, bb;
  int x, y, x1, y1, x2, y2, len1, len0, e1, e0, max;
  int r_min, r_max, g_min, g_max, b_min, b_max, x3, y3;
  unsigned char * gs;
  unsigned long long sum;
  //----------------------
  // MultiColor or PixelSearch or ImageSearch Mode
  if (mode==5)
  {
    max=n; v=c*c;
    for (i=0, sum=0, o=0; (j=text[o++])!='\0';)
    {
      if (j>='0' && j<='9')
        sum = sum*10 + (j-'0');
      else if (j=='/')
      {
        s1[i]=((sum>>16)&0xFFFF)*Stride+(sum&0xFFFF)*4;
        s0[i++]=sum>>32; sum=0;
      }
    }
    goto StartLookUp;
  }
  //----------------------
  // Generate Lookup Table
  o=0; len1=0; len0=0;
  for (y=0; y<h; y++)
  {
    for (x=0; x<w; x++)
    {
      i=(mode==3) ? y*Stride+x*4 : y*sw+x;
      if (text[o++]=='1')
        s1[len1++]=i;
      else
        s0[len0++]=i;
    }
  }
  if (err1>=len1) len1=0;
  if (err0>=len0) len0=0;
  max=(len1>len0) ? len1 : len0;
  //----------------------
  // Color Position Mode
  // only used to recognize multicolored Verification Code
  if (mode==3)
    { c=(c>>16)*Stride+(c&0xFFFF)*4; goto StartLookUp; }
  //----------------------
  // Generate Two Value Image
  o=sy*Stride+sx*4; j=Stride-sw*4; i=0;
  if (mode==0)  // Color Mode
  {
    rr=(c>>16)&0xFF; gg=(c>>8)&0xFF; bb=c&0xFF;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]-rr; g=Bmp[1+o]-gg; b=Bmp[o]-bb; v=r+rr+rr;
        ss[i]=((1024+v)*r*r+2048*g*g+(1534-v)*b*b<=n) ? 1:0;
      }
  }
  else if (mode==1)  // Gray Threshold Mode
  {
    c=(c+1)<<7;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
        ss[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15<c) ? 1:0;
  }
  else if (mode==2)  // Gray Difference Mode
  {
    gs=(unsigned char *)(ss+sw*sh);
    x2=sx+sw; y2=sy+sh;
    for (y=sy-1; y<=y2; y++)
    {
      for (x=sx-1; x<=x2; x++, i++)
        if (x<0 || x>=zw || y<0 || y>=zh)
          gs[i]=0;
        else
        {
          o=y*Stride+x*4;
          gs[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15)>>7;
        }
    }
    k=sw+2; i=0;
    for (y=1; y<=sh; y++)
      for (x=1; x<=sw; x++, i++)
      {
        o=y*k+x; n=gs[o]+c;
        ss[i]=(gs[o-1]>n || gs[o+1]>n
          || gs[o-k]>n   || gs[o+k]>n
          || gs[o-k-1]>n || gs[o-k+1]>n
          || gs[o+k-1]>n || gs[o+k+1]>n) ? 1:0;
      }
  }
  else  // (mode==4) Color Difference Mode
  {
    r=(c>>16)&0xFF; g=(c>>8)&0xFF; b=c&0xFF;
    rr=(n>>16)&0xFF; gg=(n>>8)&0xFF; bb=n&0xFF;
    r_min=r-rr; g_min=g-gg; b_min=b-bb;
    r_max=r+rr; g_max=g+gg; b_max=b+bb;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]; g=Bmp[1+o]; b=Bmp[o];
        ss[i]=(r>=r_min && r<=r_max
            && g>=g_min && g<=g_max
            && b>=b_min && b<=b_max) ? 1:0;
      }
  }
  //----------------------
  StartLookUp:
  if (mode==5 || mode==3)
    { x1=sx; y1=sy; x2=sx+sw-w; y2=sy+sh-h; sx=0; sy=0; }
  else
    { x1=0; y1=0; x2=sw-w; y2=sh-h; }
  if (dir<1 || dir>8) dir=1;
  // 1 ==> ( Left to Right ) Top to Bottom
  // 2 ==> ( Right to Left ) Top to Bottom
  // 3 ==> ( Left to Right ) Bottom to Top
  // 4 ==> ( Right to Left ) Bottom to Top
  // 5 ==> ( Top to Bottom ) Left to Right
  // 6 ==> ( Bottom to Top ) Left to Right
  // 7 ==> ( Top to Bottom ) Right to Left
  // 8 ==> ( Bottom to Top ) Right to Left
  if (--dir>3) { i=y1; y1=x1; x1=i; i=y2; y2=x2; x2=i; }
  for (y3=y1; y3<=y2; y3++)
  {
    for (x3=x1; x3<=x2; x3++)
    {
      y=((dir&3)>1) ? y1+y2-y3 : y3;
      x=(dir&1) ? x1+x2-x3 : x3;
      if (dir>3) { i=y; y=x; x=i; }
      //----------------------
      e1=err1; e0=err0;
      if (mode==5)
      {
        o=y*Stride+x*4;
        for (i=0; i<max; i++)
        {
          j=o+s1[i]; c=s0[i]; r=Bmp[2+j]-((c>>16)&0xFF);
          g=Bmp[1+j]-((c>>8)&0xFF); b=Bmp[j]-(c&0xFF);
          if ((r*r>v || g*g>v || b*b>v) && (--e1)<0)
            goto NoMatch;
        }
      }
      else if (mode==3)
      {
        o=y*Stride+x*4;
        j=o+c; rr=Bmp[2+j]; gg=Bmp[1+j]; bb=Bmp[j];
        for (i=0; i<max; i++)
        {
          if (i<len1)
          {
            j=o+s1[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb; v=r+rr+rr;
            if ((1024+v)*r*r+2048*g*g+(1534-v)*b*b>n && (--e1)<0)
              goto NoMatch;
          }
          if (i<len0)
          {
            j=o+s0[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb; v=r+rr+rr;
            if ((1024+v)*r*r+2048*g*g+(1534-v)*b*b<=n && (--e0)<0)
              goto NoMatch;
          }
        }
      }
      else
      {
        o=y*sw+x;
        for (i=0; i<max; i++)
        {
          if (i<len1 && ss[o+s1[i]]==0 && (--e1)<0) goto NoMatch;
          if (i<len0 && ss[o+s0[i]]!=0 && (--e0)<0) goto NoMatch;
        }
        // Clear the image that has been found
        for (i=0; i<len1; i++)
          ss[o+s1[i]]=0;
      }
      allpos[ok*2]=sx+x; allpos[ok*2+1]=sy+y;
      if (++ok>=allpos_max) goto Return1;
      NoMatch:;
    }
  }
  //----------------------
  Return1:
  return ok;
}

*/


;==== Optional GUI interface ====


Gui(cmd, arg1:="")
{
  local
  static
  local bch, cri
  static init:=0
  if (!init)
  {
    init:=1
    Gui_ := this.Gui.Bind(this)
    Gui_G := this.Gui.Bind(this, "G")
    Gui_Run := this.Gui.Bind(this, "Run")
    Gui_Off := this.Gui.Bind(this, "Off")
    Gui_Show := this.Gui.Bind(this, "Show")
    Gui_KeyDown := this.Gui.Bind(this, "KeyDown")
    Gui_LButtonDown := this.Gui.Bind(this, "LButtonDown")
    Gui_MouseMove := this.Gui.Bind(this, "MouseMove")
    Gui_ScreenShot := this.Gui.Bind(this, "ScreenShot")
    Gui_ShowPic := this.Gui.Bind(this, "ShowPic")
    Gui_Slider := this.Gui.Bind(this, "Slider")
    Gui_ToolTip := this.Gui.Bind(this, "ToolTip")
    Gui_ToolTipOff := this.Gui.Bind(this, "ToolTipOff")
    Gui_SaveScr := this.Gui.Bind(this, "SaveScr")
    bch:=A_BatchLines, cri:=A_IsCritical
    Critical
    #NoEnv
    %Gui_%("Load_Language_Text")
    %Gui_%("MakeCaptureWindow")
    %Gui_%("MakeMainWindow")
    OnMessage(0x100, Gui_KeyDown)
    OnMessage(0x201, Gui_LButtonDown)
    OnMessage(0x200, Gui_MouseMove)
    Menu, Tray, Add
    Menu, Tray, Add, % Lang["s1"], %Gui_Show%
    if (!A_IsCompiled and A_LineFile=A_ScriptFullPath)
    {
      Menu, Tray, Default, % Lang["s1"]
      Menu, Tray, Click, 1
      Menu, Tray, Icon, Shell32.dll, 23
    }
    Critical, %cri%
    SetBatchLines, %bch%
  }
  Switch cmd
  {
  Case "Off":
    return hk:=SubStr(A_ThisHotkey,2)
  Case "G":
    GuiControl, +g, %id%, %Gui_Run%
    return
  Case "Run":
    Critical
    %Gui_%(A_GuiControl)
    return
  Case "Show":
    Gui, FindText_Main: Default
    Gui, Show, Center
    GuiControl, Focus, scr
    return
  Case "MakeCaptureWindow":
    WindowColor:="0xDDEEFF"
    Gui, FindText_Capture: New
    Gui, +AlwaysOnTop -DPIScale
    Gui, Margin, 15, 15
    Gui, Color, %WindowColor%
    Gui, Font, s12, Verdana
    Gui, -Theme
    ww:=35, hh:=12, nW:=71, nH:=25, w:=11, C_:=[], Cid_:=[]
    Loop % nW*(nH+1)
    {
      i:=A_Index, j:=i=1 ? "" : Mod(i,nW)=1 ? "xm y+1":"x+1"
      Gui, Add, Progress, w%w% h%w% %j% Hwndid
      Control, ExStyle, -0x20000,, ahk_id %id%
      C_[i]:=id, Cid_[id]:=i
    }
    Gui, +Theme
    GuiControlGet, p, Pos, %id%
    w:=pX+pW-15, h:=pY+pH-15
    Gui, Add, Slider, xm w%w% vMySlider1 Hwndid Disabled
      +Center Page20 Line10 NoTicks AltSubmit
    %Gui_G%()
    Gui, Add, Slider, ym h%h% vMySlider2 Hwndid Disabled
      +Center Page20 Line10 NoTicks AltSubmit +Vertical
    %Gui_G%()
    GuiControlGet, p, Pos, %id%
    k:=pX+pW, MySlider1:=MySlider2:=dx:=dy:=0
    ;--------------
    Gui, Add, Button, xm Hwndid Hidden Section, % Lang["Auto"]
    GuiControlGet, p, Pos, %id%
    w:=Round(pW*0.75), i:=Round(w*3+15+pW*0.5-w*1.5)
    Gui, Add, Button, xm+%i% yp w%w% hp -Wrap vRepU Hwndid, % Lang["RepU"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutU Hwndid, % Lang["CutU"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutU3 Hwndid, % Lang["CutU3"]
    %Gui_G%()
    Gui, Add, Button, xm wp hp -Wrap vRepL Hwndid, % Lang["RepL"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutL Hwndid, % Lang["CutL"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutL3 Hwndid, % Lang["CutL3"]
    %Gui_G%()
    Gui, Add, Button, x+15 w%pW% hp -Wrap vAuto Hwndid, % Lang["Auto"]
    %Gui_G%()
    Gui, Add, Button, x+15 w%w% hp -Wrap vRepR Hwndid, % Lang["RepR"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutR Hwndid, % Lang["CutR"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutR3 Hwndid, % Lang["CutR3"]
    %Gui_G%()
    Gui, Add, Button, xm+%i% wp hp -Wrap vRepD Hwndid, % Lang["RepD"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutD Hwndid, % Lang["CutD"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutD3 Hwndid, % Lang["CutD3"]
    %Gui_G%()
    ;--------------
    Gui, Add, Text, x+80 ys+3 Section, % Lang["SelGray"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelGray ReadOnly
    Gui, Add, Text, x+15 ys, % Lang["SelColor"]
    Gui, Add, Edit, x+3 yp-3 w120 vSelColor ReadOnly
    Gui, Add, Text, x+15 ys, % Lang["SelR"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelR ReadOnly
    Gui, Add, Text, x+5 ys, % Lang["SelG"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelG ReadOnly
    Gui, Add, Text, x+5 ys, % Lang["SelB"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelB ReadOnly
    ;--------------
    x:=w*6+pW+15*4
    Gui, Add, Tab3, x%x% y+15 -Wrap, % Lang["s2"]
    Gui, Tab, 1
    Gui, Add, Text, x+15 y+15, % Lang["Threshold"]
    Gui, Add, Edit, x+15 w100 vThreshold
    Gui, Add, Button, x+15 yp-3 vGray2Two Hwndid, % Lang["Gray2Two"]
    %Gui_G%()
    Gui, Tab, 2
    Gui, Add, Text, x+15 y+15, % Lang["GrayDiff"]
    Gui, Add, Edit, x+15 w100 vGrayDiff, 50
    Gui, Add, Button, x+15 yp-3 vGrayDiff2Two Hwndid, % Lang["GrayDiff2Two"]
    %Gui_G%()
    Gui, Tab, 3
    Gui, Add, Text, x+15 y+15, % Lang["Similar1"] " 0"
    Gui, Add, Slider, x+0 w120 vSimilar1 Hwndid
      +Center Page1 NoTicks ToolTip, 100
    %Gui_G%()
    Gui, Add, Text, x+0, 100
    Gui, Add, Button, x+15 yp-3 vColor2Two Hwndid, % Lang["Color2Two"]
    %Gui_G%()
    Gui, Tab, 4
    Gui, Add, Text, x+15 y+15, % Lang["Similar2"] " 0"
    Gui, Add, Slider, x+0 w120 vSimilar2 Hwndid
      +Center Page1 NoTicks ToolTip, 100
    %Gui_G%()
    Gui, Add, Text, x+0, 100
    Gui, Add, Button, x+15 yp-3 vColorPos2Two Hwndid, % Lang["ColorPos2Two"]
    %Gui_G%()
    Gui, Tab, 5
    Gui, Add, Text, x+10 y+15, % Lang["DiffR"]
    Gui, Add, Edit, x+5 w80 vDiffR Limit3
    Gui, Add, UpDown, vdR Range0-255 Wrap
    Gui, Add, Text, x+5, % Lang["DiffG"]
    Gui, Add, Edit, x+5 w80 vDiffG Limit3
    Gui, Add, UpDown, vdG Range0-255 Wrap
    Gui, Add, Text, x+5, % Lang["DiffB"]
    Gui, Add, Edit, x+5 w80 vDiffB Limit3
    Gui, Add, UpDown, vdB Range0-255 Wrap
    Gui, Add, Button, x+15 yp-3 vColorDiff2Two Hwndid, % Lang["ColorDiff2Two"]
    %Gui_G%()
    Gui, Tab, 6
    Gui, Add, Text, x+10 y+15, % Lang["DiffRGB"]
    Gui, Add, Edit, x+5 w80 vDiffRGB Limit3
    Gui, Add, UpDown, vdRGB Range0-255 Wrap
    Gui, Add, Checkbox, x+15 yp+5 vMultiColor Hwndid, % Lang["MultiColor"]
    %Gui_G%()
    Gui, Add, Button, x+15 yp-5 vUndo Hwndid, % Lang["Undo"]
    %Gui_G%()
    Gui, Tab
    ;--------------
    Gui, Add, Button, xm vReset Hwndid, % Lang["Reset"]
    %Gui_G%()
    Gui, Add, Checkbox, x+15 yp+5 vModify Hwndid, % Lang["Modify"]
    %Gui_G%()
    Gui, Add, Text, x+30, % Lang["Comment"]
    Gui, Add, Edit, x+5 yp-2 w150 vComment
    Gui, Add, Button, x+30 yp-3 vSplitAdd Hwndid, % Lang["SplitAdd"]
    %Gui_G%()
    Gui, Add, Button, x+10 vAllAdd Hwndid, % Lang["AllAdd"]
    %Gui_G%()
    Gui, Add, Button, x+10 wp vOK Hwndid, % Lang["OK"]
    %Gui_G%()
    Gui, Add, Button, x+10 wp vCancel gCancel, % Lang["Cancel"]
    Gui, Add, Button, xm vBind0 Hwndid, % Lang["Bind0"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind1 Hwndid, % Lang["Bind1"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind2 Hwndid, % Lang["Bind2"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind3 Hwndid, % Lang["Bind3"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind4 Hwndid, % Lang["Bind4"]
    %Gui_G%()
    Gui, Add, Button, x+30 vSave Hwndid, % Lang["Save"]
    %Gui_G%()
    Gui, Show, Hide, % Lang["s3"]
    return
  Case "MakeMainWindow":
    Gui, FindText_Main: New
    Gui, +AlwaysOnTop -DPIScale
    Gui, Margin, 15, 10
    Gui, Color, %WindowColor%
    Gui, Font, s12, Verdana
    Gui, Add, Text, xm, % Lang["NowHotkey"]
    Gui, Add, Edit, x+5 w200 vNowHotkey ReadOnly
    Gui, Add, Hotkey, x+5 w200 vSetHotkey1
    Gui, Add, DDL, x+5 w180 vSetHotkey2
      , % "||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|LWin|MButton"
      . "|ScrollLock|CapsLock|Ins|Esc|BS|Del|Tab|Home|End|PgUp|PgDn"
      . "|NumpadDot|NumpadSub|NumpadAdd|NumpadDiv|NumpadMult"
    Gui, Add, GroupBox, xm y+0 w280 h55 vMyGroup cBlack
    Gui, Add, Text, xp+15 yp+20 Section, % Lang["Myww"] ": "
    Gui, Add, Text, x+0 w60, %ww%
    Gui, Add, UpDown, vMyww Range1-100, %ww%
    Gui, Add, Text, x+15 ys, % Lang["Myhh"] ": "
    Gui, Add, Text, x+0 w60, %hh%
    Gui, Add, UpDown, vMyhh Hwndid Range1-100, %hh%
    GuiControlGet, p, Pos, %id%
    GuiControl, Move, MyGroup, % "w" (pX+pW) " h" (pH+30)
    x:=pX+pW+15*2
    Gui, Add, Button, x%x% ys-8 w150 vApply Hwndid, % Lang["Apply"]
    %Gui_G%()
    Gui, Add, Checkbox, x+30 ys vAddFunc, % Lang["AddFunc"] " FindText()"
    Gui, Add, Button, xm y+18 w144 vCutL2 Hwndid, % Lang["CutL2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutR2 Hwndid, % Lang["CutR2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutU2 Hwndid, % Lang["CutU2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutD2 Hwndid, % Lang["CutD2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vUpdate Hwndid, % Lang["Update"]
    %Gui_G%()
    Gui, Font, s6 bold, Verdana
    Gui, Add, Edit, xm y+10 w720 r20 vMyPic -Wrap
    Gui, Font, s12 norm, Verdana
    Gui, Add, Button, xm w240 vCapture Hwndid, % Lang["Capture"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vTest Hwndid, % Lang["Test"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCopy Hwndid, % Lang["Copy"]
    %Gui_G%()
    Gui, Add, Button, xm y+0 wp vCaptureS Hwndid, % Lang["CaptureS"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vGetRange Hwndid, % Lang["GetRange"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vGetOffset Hwndid, % Lang["GetOffset"]
    %Gui_G%()
    Gui, Add, Edit, xm y+10 w180 hp vClipText
    Gui, Add, Button, x+0 vPaste Hwndid, % " " Lang["Paste"] " "
    %Gui_G%()
    Gui, Add, Button, x+0 vTestClip Hwndid, % " " Lang["TestClip"] " "
    %Gui_G%()
    Gui, Add, Button, x+0 vGetClipOffset Hwndid, % " " Lang["GetClipOffset"] " "
    %Gui_G%()
    Gui, Add, Edit, x+0 hp w150 hp vOffset Hwndid
    GuiControlGet, p, Pos, %id%
    w:=720+15-(pX+pW)
    Gui, Add, Button, x+0 w%w% hp vCopyOffset Hwndid, % Lang["CopyOffset"]
    %Gui_G%()
    Gui, Font, s12 cBlue, Verdana
    Gui, Add, Edit, xm w720 h300 vscr Hwndhscr -Wrap HScroll
    Gui, Show, Hide, % Lang["s4"]
    %Gui_%("LoadScr")
    OnExit(Gui_SaveScr)
    return
  Case "LoadScr":
    f:=A_Temp "\~scr1.tmp"
    FileRead, s, %f%
    GuiControl, FindText_Main:, scr, %s%
    return
  Case "SaveScr":
    f:=A_Temp "\~scr1.tmp"
    GuiControlGet, s, FindText_Main:, scr
    FileDelete, %f%
    FileAppend, %s%, %f%
    return
  Case "Capture","CaptureS":
    Gui, FindText_Main: +Hwndid
    if (show_gui:=(WinExist()=id))
    {
      WinMinimize
      Gui, FindText_Main: Hide
    }
    ShowScreenShot:=InStr(cmd,"CaptureS")
    if (ShowScreenShot)
    {
      this.ScreenShot(), f:=%Gui_%("SelectPic")
      if (f="") or !FileExist(f)
      {
        if (show_gui)
        {
          Gui, FindText_Main: Show
          GuiControl, FindText_Main: Focus, scr
        }
        Exit
      }
      this.ShowPic(f)
    }
    ;----------------------
    if GetKeyState("Ctrl")
      Send {Ctrl Up}
    Gui, FindText_HotkeyIf: New, -Caption +ToolWindow +E0x80000
    Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
    Hotkey, IfWinExist, FindText_HotkeyIf
    For k,v in StrSplit("RButton|Up|Down|Left|Right","|")
    {
      if GetKeyState(%v%)
        Send {%v% Up}
      Hotkey, *%v%, %Gui_Off%, On UseErrorLevel
    }
    CoordMode, Mouse
    GuiControlGet, w, FindText_Main:, Myww
    GuiControlGet, h, FindText_Main:, Myhh
    oldx:=oldy:="", r:=StrSplit(Lang["s5"],"|")
    if (!show_gui)
      w:=20, h:=8
    Critical, Off
    hk:="", State:=%Gui_%("State")
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y, Bind_ID
      if GetKeyState("Up","P") || (hk="Up")
        (h>1 && h--), hk:=""
      else if GetKeyState("Down","P") || (hk="Down")
        h++, hk:=""
      else if GetKeyState("Left","P") || (hk="Left")
        (w>1 && w--), hk:=""
      else if GetKeyState("Right","P") || (hk="Right")
        w++, hk:=""
      %Gui_%("Mini_Show")
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ToolTip, % r[1] " : " x "," y "`n" r[2]
    }
    Until (hk="RButton") or (State!=%Gui_%("State"))
    timeout:=A_TickCount+3000
    While (A_TickCount<timeout) and (State!=%Gui_%("State"))
      Sleep, 50
    hk:="", px:=x, py:=y, oldx:=oldy:=""
    Loop
    {
      Sleep, 50
      if GetKeyState("Up","P") || (hk="Up")
        (h>1 && h--), hk:=""
      else if GetKeyState("Down","P") || (hk="Down")
        h++, hk:=""
      else if GetKeyState("Left","P") || (hk="Left")
        (w>1 && w--), hk:=""
      else if GetKeyState("Right","P") || (hk="Right")
        w++, hk:=""
      %Gui_%("Mini_Show")
      MouseGetPos, x1, y1
      if (oldx=x1 and oldy=y1)
        Continue
      oldx:=x1, oldy:=y1
      ToolTip, % r[1] " : " x "," y "`n" r[2]
    }
    Until (hk="RButton") or (State!=%Gui_%("State"))
    timeout:=A_TickCount+3000
    While (A_TickCount<timeout) and (State!=%Gui_%("State"))
      Sleep, 50
    ToolTip
    Critical
    %Gui_%("Mini_Hide")
    For k,v in StrSplit("RButton|Up|Down|Left|Right","|")
      Hotkey, *%v%, %Gui_Off%, Off UseErrorLevel
    Hotkey, IfWinExist
    Gui, FindText_HotkeyIf: Destroy
    if (ShowScreenShot)
      this.ShowPic()
    if (!show_gui)
      return [px-w, py-h, px+w, py+h]
    ;-----------------------
    nW:=71, nH:=25, dx:=dy:=0, c:=WindowColor
    c:=((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
    Loop % nW*(nH+1)
      SendMessage, 0x2001, 0, (A_Index>nW*nH ? 0xAAFFFF:c)
        ,, % "ahk_id " C_[A_Index]
    ww:=w, hh:=h, nW:=2*ww+1, nH:=2*hh+1
    i:=nW>71, j:=nH>25
    Gui, FindText_Capture: Default
    GuiControl, Enable%i%, MySlider1
    GuiControl, Enable%j%, MySlider2
    GuiControl,, MySlider1, % MySlider1:=0
    GuiControl,, MySlider2, % MySlider2:=0
    ;------------------------
    %Gui_%("getcors", !ShowScreenShot)
    %Gui_%("Reset")
    Loop 6
      GuiControl,, Edit%A_Index%
    GuiControl,, Modify, % Modify:=0
    GuiControl,, MultiColor, % MultiColor:=0
    GuiControl,, GrayDiff, 50
    GuiControl, Focus, Gray2Two
    GuiControl, +Default, Gray2Two
    Gui, Show, Center
    Event:=Result:=""
    DetectHiddenWindows, Off
    Critical, Off
    Gui, +LastFound
    WinWaitClose, % "ahk_id " WinExist()
    Critical
    ToolTip
    Gui, FindText_Main: Default
    ;--------------------------------
    if (cors.bind!="")
    {
      WinGetTitle, tt, ahk_id %Bind_ID%
      WinGetClass, tc, ahk_id %Bind_ID%
      tt:=Trim(SubStr(tt,1,30) (tc ? " ahk_class " tc:""))
      tt:=StrReplace(RegExReplace(tt,"[;``]","``$0"),"""","""""")
      Result:="`nSetTitleMatchMode, 2`nid:=WinExist(""" tt """)"
        . "`nFindText().BindWindow(id" (cors.bind=0 ? "":"," cors.bind)
        . ")  `; " Lang["s6"] " this.BindWindow(0)`n`n" Result
    }
    if (Event="OK")
    {
      if (!A_IsCompiled)
      {
        FileRead, s, %A_LineFile%
        s:=SubStr(s, s~="i)\n[;=]+ Copy The")
      }
      else s:=""
      GuiControl,, scr, % Result "`n" s
      if !InStr(Result,"##")
        GuiControl,, MyPic, % Trim(this.ASCII(Result),"`n")
      Result:=s:=""
    }
    else if (Event="SplitAdd") or (Event="AllAdd")
    {
      GuiControlGet, s,, scr
      i:=j:=0, r:="<[^>\n]*>[^$\n]+\$[\w+/,.\-]+"
      While j:=RegExMatch(s,r,"",j+1)
        i:=InStr(s,"`n",0,j)
      GuiControl,, scr, % SubStr(s,1,i) . Result . SubStr(s,i+1)
      if !InStr(Result,"##")
        GuiControl,, MyPic, % Trim(this.ASCII(Result),"`n")
      Result:=s:=""
    }
    ;----------------------
    Gui, Show
    GuiControl, Focus, scr
    return
  Case "State":
    return GetKeyState((arg1?"LButton":"RButton"),"P")
      . "|" GetKeyState((arg1?"LButton":"RButton"))
      . "|" GetKeyState("Ctrl","P")
      . "|" GetKeyState("Ctrl")
  Case "SelectPic":
    Gui, FindText_SelectPic: +LastFoundExist
    IfWinExist
      return
    Pics:=[], Names:=[], s:=""
    Loop Files, % A_Temp "\Ahk_ScreenShot\*.bmp"
      Pics.Push(LoadPicture(v:=A_LoopFileFullPath))
      , Names.Push(v), s.="|" RegExReplace(v,"i)^.*\\|\.bmp$")
    Gui, FindText_SelectPic: New
    Gui, +LastFound +AlwaysOnTop -DPIScale
    Gui, Margin, 15, 15
    Gui, Font, s12, Verdana
    Gui, Add, Pic, HwndhPic w800 h500 +Border
    Gui, Add, ListBox, % "x+15 w120 hp vSelectBox Hwndid"
      . " AltSubmit 0x100 Choose1", % Trim(s,"|")
    %Gui_G%()
    Gui, Add, Button, xm w170 vOK2 Hwndid Default, % Lang["OK2"]
    %Gui_G%()
    Gui, Add, Button, x+15 wp vCancel2 gCancel, % Lang["Cancel2"]
    Gui, Add, Button, x+15 wp vClearAll Hwndid, % Lang["ClearAll"]
    %Gui_G%()
    Gui, Add, Button, x+15 wp vOpenDir Hwndid, % Lang["OpenDir"]
    %Gui_G%()
    Gui, Add, Button, x+15 wp vSavePic Hwndid, % Lang["SavePic"]
    %Gui_G%()
    GuiControl, Focus, SelectBox
    %Gui_%("SelectBox")
    Gui, Show,, Select ScreenShot
    ;-----------------------
    DetectHiddenWindows, Off
    Critical, Off
    file:=""
    WinWaitClose, % "ahk_id " WinExist()
    Critical
    Gui, Destroy
    Loop % Pics.Length()
      DllCall("DeleteObject", "Ptr",Pics[A_Index])
    Pics:="", Names:=""
    return file
  Case "SavePic":
    GuiControlGet, SelectBox
    f:=Names[SelectBox]
    Gui, Destroy
    Loop % Pics.Length()
      DllCall("DeleteObject", "Ptr",Pics[A_Index])
    Pics:="", Names:="", show_gui_bak:=show_gui
    this.ShowPic(f)
    Gui, FindText_Screen: +OwnDialogs
    Loop
    {
      pos:=%Gui_%("GetRange")
      MsgBox, 4100, Tip, % Lang["s15"] " !"
      IfMsgBox, Yes
        Break
    }
    %Gui_%("ScreenShot", pos[1] "|" pos[2] "|" pos[3] "|" pos[4] "|0")
    this.ShowPic()
    if (show_gui_bak)
    {
      GuiControl, FindText_Main: Focus, scr
      Gui, FindText_Main: Show
    }
    Exit
  Case "SelectBox":
    GuiControlGet, SelectBox
    if (hBM:=Pics[SelectBox])
    {
      this.GetBitmapWH(hBM, w, h)
      GuiControl,, %hPic%, % "*W" (w<800?0:800)
        . " *H" (h<500?0:500) " HBITMAP:*" hBM
    }
    return
  Case "OK2":
    GuiControlGet, SelectBox
    file:=Names[SelectBox]
    Gui, Hide
    return
  Case "ClearAll":
    FileDelete, % A_Temp "\Ahk_ScreenShot\*.bmp"
    Gui, Hide
    return
  Case "OpenDir":
    Run, % A_Temp "\Ahk_ScreenShot\"
    return
  Case "Mini_Show":
    Gui, FindText_Mini_4: +LastFoundExist
    IfWinNotExist
    {
      Loop 4
      {
        i:=A_Index
        Gui, FindText_Mini_%i%: +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000
        Gui, FindText_Mini_%i%: Show, Hide, Mini
      }
    }
    d:=2, w:=w<0 ? 0:w, h:=h<0 ? 0:h, c:=A_MSec<500 ? "Red":"Blue"
    Loop 4
    {
      i:=A_Index
      x1:=Floor(i=3 ? x+w+1 : x-w-d)
      y1:=Floor(i=4 ? y+h+1 : y-h-d)
      w1:=Floor(i=1 or i=3 ? d : 2*(w+d)+1)
      h1:=Floor(i=2 or i=4 ? d : 2*(h+d)+1)
      Gui, FindText_Mini_%i%: Color, %c%
      Gui, FindText_Mini_%i%: Show, NA x%x1% y%y1% w%w1% h%h1%
    }
    return
  Case "Mini_Hide":
    Gui, FindText_Mini_4: +Hwndid
    Loop 4
      Gui, FindText_Mini_%A_Index%: Destroy
    WinWaitClose, ahk_id %id%,, 3
    return
  Case "getcors":
    this.xywh2xywh(px-ww,py-hh,2*ww+1,2*hh+1,x,y,w,h)
    if (w<1 or h<1)
      return
    SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
    if (arg1)
      this.ScreenShot()
    cors:=[], gray:=[], k:=0
    Loop %nH%
    {
      j:=py-hh+A_Index-1, i:=px-ww
      Loop %nW%
        cors[++k]:=c:=this.GetColor(i++,j,0)
        , gray[k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
    }
    cors.CutLeft:=Abs(px-ww-x)
    cors.CutRight:=Abs(px+ww-(x+w-1))
    cors.CutUp:=Abs(py-hh-y)
    cors.CutDown:=Abs(py+hh-(y+h-1))
    SetBatchLines, %bch%
    return
  Case "GetRange":
    Gui, FindText_Main: +Hwndid
    if (show_gui:=(WinExist()=id))
      Gui, FindText_Main: Hide
    ;---------------------
    Gui, FindText_GetRange: New
    Gui, +LastFound +AlWaysOnTop +ToolWindow -Caption -DPIScale +E0x08000000
    Gui, Color, White
    WinSet, Transparent, 10
    this.xywh2xywh(0,0,0,0,0,0,0,0,x,y,w,h)
    Gui, Show, NA x%x% y%y% w%w% h%h%, GetRange
    ;---------------------
    if GetKeyState("LButton")
      Send {LButton Up}
    if GetKeyState("Ctrl")
      Send {Ctrl Up}
    hk:="", State:=%Gui_%("State",1)
    Gui, FindText_HotkeyIf: New, -Caption +ToolWindow +E0x80000
    Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
    Hotkey, IfWinExist, FindText_HotkeyIf
    Hotkey, *LButton, %Gui_Off%, On UseErrorLevel
    Hotkey, *LButton Up, %Gui_Off%, On UseErrorLevel
    CoordMode, Mouse
    oldx:=oldy:="", r:=Lang["s7"]
    Critical, Off
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ToolTip, %r%
    }
    Until (hk!="") or (State!=%Gui_%("State",1))
    hk:="", State:=%Gui_%("State",1)
    px:=x, py:=y, oldx:=oldy:=""
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y
      w:=Abs(px-x)//2, h:=Abs(py-y)//2, x:=(px+x)//2, y:=(py+y)//2
      %Gui_%("Mini_Show")
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ToolTip, %r%
    }
    Until (hk!="") or (State!=%Gui_%("State",1))
    timeout:=A_TickCount+3000
    While (A_TickCount<timeout) and (State=%Gui_%("State",1))
      Sleep, 50
    ToolTip
    Critical
    %Gui_%("Mini_Hide")
    Hotkey, *LButton, %Gui_Off%, Off UseErrorLevel
    Hotkey, *LButton Up, %Gui_Off%, Off UseErrorLevel
    Hotkey, IfWinExist
    Gui, FindText_HotkeyIf: Destroy
    Gui, FindText_GetRange: Destroy
    Clipboard:=p:=(x-w) ", " (y-h) ", " (x+w) ", " (y+h)
    if (!show_gui)
      return StrSplit(p, ",", " ")
    ;---------------------
    Gui, FindText_Main: Default
    GuiControlGet, s,, scr
    re:="i)(FindText\(\s*X\d*\s*,\s*Y\d*\s*,)([\d\s+\-]*,){4}"
    if RegExMatch(s, re, r)
    {
      s:=StrReplace(s, r, r1 " " p ",", 0, 1)
      GuiControl,, scr, %s%
    }
    Gui, Show
    return
  Case "Test","TestClip":
    Gui, FindText_Main: Default
    Gui, +LastFound
    WinMinimize
    Gui, Hide
    DetectHiddenWindows, Off
    WinWaitClose, % "ahk_id " WinExist()
    Sleep, 100
    ;----------------------
    if (cmd="Test")
      GuiControlGet, s,, scr
    else
      GuiControlGet, s,, ClipText
    if (!A_IsCompiled) and InStr(s,"MCode(") and (cmd="Test")
    {
      s:="`n#NoEnv`nMenu, Tray, Click, 1`n" s "`nExitApp`n"
      Thread:= new this.Thread(s)
      DetectHiddenWindows, On
      WinWait, % "ahk_class AutoHotkey ahk_pid " Thread.pid,, 3
      if (!ErrorLevel)
        WinWaitClose,,, 30
      Thread:=""  ; kill the Thread
    }
    else
    {
      Gui, +OwnDialogs
      t:=A_TickCount, n:=150000, X:=Y:=""
      , RegExMatch(s,"<[^>\n]*>[^$\n]+\$[\w+/,.\-]+",r)
      , v:=this.FindText(X, Y, -n, -n, n, n, 0, 0, r)
      r:=StrSplit(Lang["s8"],"|")
      MsgBox, 4096, Tip, % r[1] ":`t" Round(v.Length()) "`n`n"
        . r[2] ":`t" (A_TickCount-t) " " r[3] "`n`n"
        . r[4] ":`t" X ", " Y "`n`n"
        . r[5] ":`t<" (Comment:=v[1].id) ">", 3
      for i,j in v
        if (i<=2)
          this.MouseTip(j.x, j.y)
      v:="", Clipboard:=X "," Y
    }
    ;----------------------
    Gui, Show
    GuiControl, Focus, scr
    return
  Case "GetOffset","GetClipOffset":
    Gui, FindText_Main: Hide
    Gui, FindText_Capture: +LastFound
    %Gui_%("Capture")
    Gui, FindText_Main: Default
    if (cmd="GetOffset")
      GuiControlGet, s,, scr
    else
      GuiControlGet, s,, ClipText
    RegExMatch(s, "<[^>\n]*>[^$\n]+\$[\w+/,.\-]+", r)
    n:=150000, v:=this.FindText(X, Y, -n, -n, n, n, 0, 0, r)
    r:=StrReplace("X+" (px-X) ", Y+" (py-Y), "+-", "-")
    if (cmd="GetOffset")
    {
      s:=RegExReplace(s, "i)(\.Click\()[^,\n""]*,[^,)\n]*"
        , "$1" r, 0, 1)
      GuiControl,, scr, %s%
    }
    else
      GuiControl,, Offset, % v ? r:""
    Gui, Show
    GuiControl, Focus, scr
    s:=v:=""
    return
  Case "Paste":
    if RegExMatch(Clipboard, "\|?<[^>\n]*>[^$\n]+\$[\w+/,.\-]+", r)
    {
      GuiControl,, ClipText, %r%
      GuiControl,, MyPic, % Trim(this.ASCII(r),"`n")
    }
    return
  Case "CopyOffset":
    GuiControlGet, s,, Offset
    Clipboard:=s
    return
  Case "Copy":
    Gui, FindText_Main: Default
    ControlGet, s, Selected,,, ahk_id %hscr%
    if (s="")
    {
      GuiControlGet, s,, scr
      GuiControlGet, r,, AddFunc
      if (r != 1)
        s:=RegExReplace(s,"\n\K[\s;=]+ Copy The[\s\S]*")
    }
    Clipboard:=RegExReplace(s,"\R","`r`n")
    GuiControl, Focus, scr
    return
  Case "Apply":
    Gui, FindText_Main: Default
    GuiControlGet, NowHotkey
    GuiControlGet, SetHotkey1
    GuiControlGet, SetHotkey2
    if (NowHotkey!="")
      Hotkey, *%NowHotkey%,, Off UseErrorLevel
    k:=SetHotkey1!="" ? SetHotkey1 : SetHotkey2
    if (k!="")
      Hotkey, *%k%, %Gui_ScreenShot%, On UseErrorLevel
    GuiControl,, NowHotkey, %k%
    GuiControl,, SetHotkey1
    GuiControl, Choose, SetHotkey2, 0
    return
  Case "ScreenShot":
    Critical
    f:=A_Temp "\Ahk_ScreenShot"
    if !InStr(r:=FileExist(f), "D")
    {
      if (r)
      {
        FileSetAttrib, -R, %f%
        FileDelete, %f%
      }
      FileCreateDir, %f%
    }
    Loop
      f:=A_Temp "\Ahk_ScreenShot\" Format("{:03d}",A_Index) ".bmp"
    Until !FileExist(f)
    this.SavePic(f, StrSplit(arg1,"|")*)
    Gui, FindText_Tip: New
    ; WS_EX_NOACTIVATE:=0x08000000, WS_EX_TRANSPARENT:=0x20
    Gui, +LastFound +AlwaysOnTop +ToolWindow -Caption -DPIScale +E0x08000020
    Gui, Color, Yellow
    Gui, Font, cRed s48 bold
    Gui, Add, Text,, % Lang["s9"]
    WinSet, Transparent, 200
    Gui, Show, NA y0, ScreenShot Tip
    Sleep, 100
    Gui, Destroy
    return
  Case "Bind0","Bind1","Bind2","Bind3","Bind4":
    this.BindWindow(Bind_ID, bind_mode:=SubStr(cmd,5))
    if GetKeyState("RButton")
      Send {RButton Up}
    if GetKeyState("Ctrl")
      Send {Ctrl Up}
    hk:="", State:=%Gui_%("State")
    Gui, FindText_HotkeyIf: New, -Caption +ToolWindow +E0x80000
    Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
    Hotkey, IfWinExist, FindText_HotkeyIf
    Hotkey, *RButton, %Gui_Off%, On UseErrorLevel
    CoordMode, Mouse
    oldx:=oldy:=""
    Critical, Off
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ;---------------
      px:=x, py:=y, %Gui_%("getcors",1)
      %Gui_%("Reset"), r:=StrSplit(Lang["s10"],"|")
      ToolTip, % r[1] " : " x "," y "`n" r[2]
    }
    Until (hk!="") or (State!=%Gui_%("State"))
    timeout:=A_TickCount+3000
    While (A_TickCount<timeout) and (State!=%Gui_%("State"))
      Sleep, 50
    ToolTip
    Critical
    Hotkey, *RButton, %Gui_Off%, Off UseErrorLevel
    Hotkey, IfWinExist
    Gui, FindText_HotkeyIf: Destroy
    this.BindWindow(0), cors.bind:=bind_mode
    return
  Case "MySlider1","MySlider2":
    SetTimer, %Gui_Slider%, -10
    return
  Case "Slider":
    Critical
    dx:=nW>71 ? Round((nW-71)*MySlider1/100) : 0
    dy:=nH>25 ? Round((nH-25)*MySlider2/100) : 0
    if (oldx=dx and oldy=dy)
      return
    oldy:=dy, k:=0
    Loop % nW*nH
      c:=(!show[++k] ? WindowColor
      : bg="" ? cors[k] : ascii[k]
      ? "Black":"White"), %Gui_%("SetColor")
    Loop % nW*(oldx!=dx)
    {
      i:=A_Index-dx
      if (i>=1 && i<=71)
      {
        c:=show[nW*nH+A_Index] ? 0x0000FF : 0xAAFFFF
        SendMessage, 0x2001, 0, c,, % "ahk_id " C_[71*25+i]
      }
    }
    oldx:=dx
    return
  Case "Reset":
    show:=[], ascii:=[], bg:=""
    CutLeft:=CutRight:=CutUp:=CutDown:=k:=0
    Loop % nW*nH
      show[++k]:=1, c:=cors[k], %Gui_%("SetColor")
    Loop % cors.CutLeft
      %Gui_%("CutL")
    Loop % cors.CutRight
      %Gui_%("CutR")
    Loop % cors.CutUp
      %Gui_%("CutU")
    Loop % cors.CutDown
      %Gui_%("CutD")
    return
  Case "SetColor":
    if (nW=71 && nH=25)
      tk:=k
    else
    {
      tx:=Mod(k-1,nW)-dx, ty:=(k-1)//nW-dy
      if (tx<0 || tx>=71 || ty<0 || ty>=25)
        return
      tk:=ty*71+tx+1
    }
    c:=c="Black" ? 0x000000 : c="White" ? 0xFFFFFF
      : ((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
    SendMessage, 0x2001, 0, c,, % "ahk_id " . C_[tk]
    return
  Case "RepColor":
    show[k]:=1, c:=(bg="" ? cors[k] : ascii[k]
      ? "Black":"White"), %Gui_%("SetColor")
    return
  Case "CutColor":
    show[k]:=0, c:=WindowColor, %Gui_%("SetColor")
    return
  Case "RepL":
    if (CutLeft<=cors.CutLeft)
    or (bg!="" and InStr(color,"**")
    and CutLeft=cors.CutLeft+1)
      return
    k:=CutLeft-nW, CutLeft--
    Loop %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("RepColor") : "")
    return
  Case "CutL":
    if (CutLeft+CutRight>=nW)
      return
    CutLeft++, k:=CutLeft-nW
    Loop %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("CutColor") : "")
    return
  Case "CutL3":
    Loop 3
      %Gui_%("CutL")
    return
  Case "RepR":
    if (CutRight<=cors.CutRight)
    or (bg!="" and InStr(color,"**")
    and CutRight=cors.CutRight+1)
      return
    k:=1-CutRight, CutRight--
    Loop %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("RepColor") : "")
    return
  Case "CutR":
    if (CutLeft+CutRight>=nW)
      return
    CutRight++, k:=1-CutRight
    Loop %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("CutColor") : "")
    return
  Case "CutR3":
    Loop 3
      %Gui_%("CutR")
    return
  Case "RepU":
    if (CutUp<=cors.CutUp)
    or (bg!="" and InStr(color,"**")
    and CutUp=cors.CutUp+1)
      return
    k:=(CutUp-1)*nW, CutUp--
    Loop %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("RepColor") : "")
    return
  Case "CutU":
    if (CutUp+CutDown>=nH)
      return
    CutUp++, k:=(CutUp-1)*nW
    Loop %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("CutColor") : "")
    return
  Case "CutU3":
    Loop 3
      %Gui_%("CutU")
    return
  Case "RepD":
    if (CutDown<=cors.CutDown)
    or (bg!="" and InStr(color,"**")
    and CutDown=cors.CutDown+1)
      return
    k:=(nH-CutDown)*nW, CutDown--
    Loop %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("RepColor") : "")
    return
  Case "CutD":
    if (CutUp+CutDown>=nH)
      return
    CutDown++, k:=(nH-CutDown)*nW
    Loop %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("CutColor") : "")
    return
  Case "CutD3":
    Loop 3
      %Gui_%("CutD")
    return
  Case "Gray2Two":
    Gui, FindText_Capture: Default
    GuiControl, Focus, Threshold
    GuiControlGet, Threshold
    if (Threshold="")
    {
      pp:=[]
      Loop 256
        pp[A_Index-1]:=0
      Loop % nW*nH
        if (show[A_Index])
          pp[gray[A_Index]]++
      IP0:=IS0:=0
      Loop 256
        k:=A_Index-1, IP0+=k*pp[k], IS0+=pp[k]
      Threshold:=Floor(IP0/IS0)
      Loop 20
      {
        LastThreshold:=Threshold
        IP1:=IS1:=0
        Loop % LastThreshold+1
          k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
        IP2:=IP0-IP1, IS2:=IS0-IS1
        if (IS1!=0 and IS2!=0)
          Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
        if (Threshold=LastThreshold)
          Break
      }
      GuiControl,, Threshold, %Threshold%
    }
    Threshold:=Round(Threshold)
    color:="*" Threshold, k:=i:=0
    Loop % nW*nH
    {
      ascii[++k]:=v:=(gray[k]<=Threshold)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "GrayDiff2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, GrayDiff
    if (GrayDiff="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s11"] " !", 1
      return
    }
    if (CutLeft=cors.CutLeft)
      %Gui_%("CutL")
    if (CutRight=cors.CutRight)
      %Gui_%("CutR")
    if (CutUp=cors.CutUp)
      %Gui_%("CutU")
    if (CutDown=cors.CutDown)
      %Gui_%("CutD")
    GrayDiff:=Round(GrayDiff)
    color:="**" GrayDiff, k:=i:=0
    Loop % nW*nH
    {
      j:=gray[++k]+GrayDiff
      , ascii[k]:=v:=( gray[k-1]>j or gray[k+1]>j
      or gray[k-nW]>j or gray[k+nW]>j
      or gray[k-nW-1]>j or gray[k-nW+1]>j
      or gray[k+nW-1]>j or gray[k+nW+1]>j )
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "Color2Two","ColorPos2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, c,, SelColor
    if (c="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s12"] " !", 1
      return
    }
    UsePos:=(cmd="ColorPos2Two") ? 1:0
    GuiControlGet, n,, Similar1
    n:=Round(n/100,2), color:=c "@" n
    , n:=Floor(512*9*255*255*(1-n)*(1-n)), k:=i:=0
    , rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
    Loop % nW*nH
    {
      c:=cors[++k], r:=((c>>16)&0xFF)-rr
      , g:=((c>>8)&0xFF)-gg, b:=(c&0xFF)-bb, j:=r+rr+rr
      , ascii[k]:=v:=((1024+j)*r*r+2048*g*g+(1534-j)*b*b<=n)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "ColorDiff2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, c,, SelColor
    if (c="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s12"] " !", 1
      return
    }
    GuiControlGet, dR
    GuiControlGet, dG
    GuiControlGet, dB
    rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
    , n:=Format("{:06X}",(dR<<16)|(dG<<8)|dB)
    , color:=StrReplace(c "-" n,"0x"), k:=i:=0
    Loop % nW*nH
    {
      c:=cors[++k], r:=(c>>16)&0xFF, g:=(c>>8)&0xFF
      , b:=c&0xFF, ascii[k]:=v:=(Abs(r-rr)<=dR
      and Abs(g-gg)<=dG and Abs(b-bb)<=dB)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "Modify":
    GuiControlGet, Modify
    return
  Case "MultiColor":
    GuiControlGet, MultiColor
    Result:=""
    ToolTip
    return
  Case "Undo":
    Result:=RegExReplace(Result,",[^/]+/[^/]+/[^/]+$")
    ToolTip, % Trim(Result,"/,")
    return
  Case "Similar1":
    GuiControl,, Similar2, %Similar1%
    return
  Case "Similar2":
    GuiControl,, Similar1, %Similar2%
    return
  Case "GetTxt":
    txt:=""
    if (bg="")
      return
    k:=0
    Loop %nH%
    {
      v:=""
      Loop %nW%
        v.=!show[++k] ? "" : ascii[k] ? "1":"0"
      txt.=v="" ? "" : v "`n"
    }
    return
  Case "Auto":
    %Gui_%("GetTxt")
    if (txt="")
    {
      Gui, FindText_Capture: +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s13"] " !", 1
      return
    }
    While InStr(txt,bg)
    {
      if (txt~="^" bg "+\n")
        txt:=RegExReplace(txt,"^" bg "+\n"), %Gui_%("CutU")
      else if !(txt~="m`n)[^\n" bg "]$")
        txt:=RegExReplace(txt,"m`n)" bg "$"), %Gui_%("CutR")
      else if (txt~="\n" bg "+\n$")
        txt:=RegExReplace(txt,"\n\K" bg "+\n$"), %Gui_%("CutD")
      else if !(txt~="m`n)^[^\n" bg "]")
        txt:=RegExReplace(txt,"m`n)^" bg), %Gui_%("CutL")
      else Break
    }
    txt:=""
    return
  Case "OK","SplitAdd","AllAdd":
    Gui, FindText_Capture: Default
    Gui, +OwnDialogs
    %Gui_%("GetTxt")
    if (txt="") and (!MultiColor)
    {
      MsgBox, 4096, Tip, % Lang["s13"] " !", 1
      return
    }
    if InStr(color,"@") and (UsePos) and (!MultiColor)
    {
      r:=StrSplit(color,"@")
      k:=i:=j:=0
      Loop % nW*nH
      {
        if (!show[++k])
          Continue
        i++
        if (k=cors.SelPos)
        {
          j:=i
          Break
        }
      }
      if (j=0)
      {
        MsgBox, 4096, Tip, % Lang["s12"] " !", 1
        return
      }
      color:="#" j "@" r[2]
    }
    GuiControlGet, Comment
    if (cmd="SplitAdd") and (!MultiColor)
    {
      if InStr(color,"#")
      {
        MsgBox, 4096, Tip, % Lang["s14"], 3
        return
      }
      bg:=StrLen(StrReplace(txt,"0"))
        > StrLen(StrReplace(txt,"1")) ? "1":"0"
      s:="", i:=0, k:=nW*nH+1+CutLeft
      Loop % w:=nW-CutLeft-CutRight
      {
        i++
        if (!show[k++] and A_Index<w)
          Continue
        i:=Format("{:d}",i)
        v:=RegExReplace(txt,"m`n)^(.{" i "}).*","$1")
        txt:=RegExReplace(txt,"m`n)^.{" i "}"), i:=0
        While InStr(v,bg)
        {
          if (v~="^" bg "+\n")
            v:=RegExReplace(v,"^" bg "+\n")
          else if !(v~="m`n)[^\n" bg "]$")
            v:=RegExReplace(v,"m`n)" bg "$")
          else if (v~="\n" bg "+\n$")
            v:=RegExReplace(v,"\n\K" bg "+\n$")
          else if !(v~="m`n)^[^\n" bg "]")
            v:=RegExReplace(v,"m`n)^" bg)
          else Break
        }
        if (v!="")
        {
          v:=Format("{:d}",InStr(v,"`n")-1) "." this.bit2base64(v)
          s.="`nText.=""|<" SubStr(Comment,1,1) ">" color "$" v """`n"
          Comment:=SubStr(Comment, 2)
        }
      }
      Event:=cmd, Result:=s
      Gui, Hide
      return
    }
    if (!MultiColor)
      txt:=Format("{:d}",InStr(txt,"`n")-1) "." this.bit2base64(txt)
    else
    {
      GuiControlGet, dRGB
      r:=StrSplit(Trim(StrReplace(Result,",","/"),"/"),"/")
      , x:=r[1], y:=r[2], s:="", i:=1
      Loop % r.Length()//3
        s.="," (r[i++]-x) "/" (r[i++]-y) "/" r[i++]
      txt:=SubStr(s,2), color:="##" dRGB
    }
    s:="`nText.=""|<" Comment ">" color "$" txt """`n"
    if (cmd="AllAdd")
    {
      Event:=cmd, Result:=s
      Gui, Hide
      return
    }
    x:=px-ww+CutLeft+(nW-CutLeft-CutRight)//2
    y:=py-hh+CutUp+(nH-CutUp-CutDown)//2
    s:=StrReplace(s, "Text.=", "Text:="), r:=StrSplit(Lang["s8"],"|")
    s:="`; #Include <FindText>`n"
    . "`nt1:=A_TickCount, X:=Y:=""""`n" s
    . "`nif (ok:=FindText(X, Y, " x "-150000, "
    . y "-150000, " x "+150000, " y "+150000, 0, 0, Text))"
    . "`n{"
    . "`n  `; FindText().Click(" . "X, Y, ""L"")"
    . "`n}`n"
    . "`n`; ok:=FindText(X:=""wait"", Y:=3, 0,0,0,0,0,0,Text)    `; Wait 3 seconds for appear"
    . "`n`; ok:=FindText(X:=""wait0"", Y:=-1, 0,0,0,0,0,0,Text)  `; Wait indefinitely for disappear`n"
    . "`nMsgBox, 4096, Tip, `% """ r[1] ":``t"" Round(ok.Length())"
    . "`n  . ""``n``n" r[2] ":``t"" (A_TickCount-t1) "" " r[3] """"
    . "`n  . ""``n``n" r[4] ":``t"" X "", "" Y"
    . "`n  . ""``n``n" r[5] ":``t<"" (Comment:=ok[1].id) "">""`n"
    . "`nfor i,v in ok  `; ok value can be get from ok:=FindText().ok"
    . "`n  if (i<=2)"
    . "`n    FindText().MouseTip(ok[i].x, ok[i].y)`n"
    Event:=cmd, Result:=s
    Gui, Hide
    return
  Case "Save":
    x:=px-ww+CutLeft, w:=nW-CutLeft-CutRight
    y:=py-hh+CutUp, h:=nH-CutUp-CutDown
    %Gui_%("ScreenShot"
      , x "|" y "|" (x+w-1) "|" (y+h-1) "|0")
    return
  Case "KeyDown":
    Critical
    if (A_Gui!="FindText_Main")
      return
    if (A_GuiControl="scr")
      SetTimer, %Gui_ShowPic%, -150
    else if (A_GuiControl="ClipText")
    {
      GuiControlGet, s, FindText_Main:, ClipText
      GuiControl, FindText_Main:, MyPic, % Trim(this.ASCII(s),"`n")
    }
    return
  Case "ShowPic":
    ControlGet, i, CurrentLine,,, ahk_id %hscr%
    ControlGet, s, Line, %i%,, ahk_id %hscr%
    GuiControl, FindText_Main:, MyPic, % Trim(this.ASCII(s),"`n")
    return
  Case "LButtonDown":
    Critical
    if (A_Gui!="FindText_Capture")
      return %Gui_%("KeyDown")
    MouseGetPos,,,, k2, 2
    if (k1:=Round(Cid_[k2]))<1
      return
    Gui, FindText_Capture: Default
    if (k1>71*25)
    {
      k3:=nW*nH+(k1-71*25)+dx
      k1:=(show[k3]:=!show[k3]) ? 0x0000FF : 0xAAFFFF
      SendMessage, 0x2001, 0, k1,, % "ahk_id " k2
      return
    }
    k2:=Mod(k1-1,71)+dx, k3:=(k1-1)//71+dy
    if (k2>=nW || k3>=nH)
      return
    k1:=k, k:=k3*nW+k2+1, k2:=c
    if (MultiColor and show[k])
    {
      c:="," Mod(k-1,nW) "/" k3 "/"
      . Format("{:06X}",cors[k]&0xFFFFFF)
      , Result.=InStr(Result,c) ? "":c
      ToolTip, % Trim(Result,"/,")
    }
    else if (Modify and bg!="" and show[k])
    {
      c:=((ascii[k]:=!ascii[k]) ? "Black":"White")
      , %Gui_%("SetColor")
    }
    else
    {
      c:=cors[k], cors.SelPos:=k
      GuiControl,, SelGray, % gray[k]
      GuiControl,, SelColor, % Format("0x{:06X}",c&0xFFFFFF)
      GuiControl,, SelR, % (c>>16)&0xFF
      GuiControl,, SelG, % (c>>8)&0xFF
      GuiControl,, SelB, % c&0xFF
    }
    k:=k1, c:=k2
    return
  Case "MouseMove":
    static PrevControl:=""
    if (PrevControl!=A_GuiControl)
    {
      PrevControl:=A_GuiControl
      SetTimer, %Gui_ToolTip%, % PrevControl ? -500 : "Off"
      SetTimer, %Gui_ToolTipOff%, % PrevControl ? -5500 : "Off"
      ToolTip
    }
    return
  Case "ToolTip":
    MouseGetPos,,, _TT
    IfWinExist, ahk_id %_TT% ahk_class AutoHotkeyGUI
      ToolTip, % Tip_Text[PrevControl]
    return
  Case "ToolTipOff":
    ToolTip
    return
  Case "CutL2","CutR2","CutU2","CutD2":
    Gui, FindText_Main: Default
    GuiControlGet, s,, MyPic
    s:=Trim(s,"`n") . "`n", v:=SubStr(cmd,4,1)
    if (v="U")
      s:=RegExReplace(s,"^[^\n]+\n")
    else if (v="D")
      s:=RegExReplace(s,"[^\n]+\n$")
    else if (v="L")
      s:=RegExReplace(s,"m`n)^[^\n]")
    else if (v="R")
      s:=RegExReplace(s,"m`n)[^\n]$")
    GuiControl,, MyPic, % Trim(s,"`n")
    return
  Case "Update":
    Gui, FindText_Main: Default
    GuiControl, Focus, scr
    ControlGet, i, CurrentLine,,, ahk_id %hscr%
    ControlGet, s, Line, %i%,, ahk_id %hscr%
    if !RegExMatch(s,"(<[^>\n]*>[^$\n]+\$)\d+\.[\w+/]+",r)
      return
    GuiControlGet, v,, MyPic
    v:=Trim(v,"`n") . "`n", w:=Format("{:d}",InStr(v,"`n")-1)
    v:=StrReplace(StrReplace(v,"0","1"),"_","0")
    s:=StrReplace(s,r,r1 . w "." this.bit2base64(v))
    v:="{End}{Shift Down}{Home}{Shift Up}{Del}"
    ControlSend,, %v%, ahk_id %hscr%
    Control, EditPaste, %s%,, ahk_id %hscr%
    ControlSend,, {Home}, ahk_id %hscr%
    return
  Case "Load_Language_Text":
    s:="
    (
Myww       = Width = Adjust the width of the capture range
Myhh       = Height = Adjust the height of the capture range
AddFunc    = Add = Additional FindText() in Copy
NowHotkey  = Hotkey = Current screenshot hotkey
SetHotkey1 = = First sequence Screenshot hotkey
SetHotkey2 = = Second sequence Screenshot hotkey
Apply      = Apply = Apply new screenshot hotkey
CutU2      = CutU = Cut the Upper Edge of the text in the edit box below
CutL2      = CutL = Cut the Left Edge of the text in the edit box below
CutR2      = CutR = Cut the Right Edge of the text in the edit box below
CutD2      = CutD = Cut the Lower Edge of the text in the edit box below
Update     = Update = Update the text in the edit box below to the line of Code
GetRange   = GetRange = Get screen range to clipboard and update the search range of the Code
GetOffset  = GetOffset = Get position offset relative to the Text from the Code and update FindText().Click()
GetClipOffset  = GetOffset2 = Get position offset relative to the Text from the Left Box
Capture    = Capture = Initiate Image Capture Sequence
CaptureS   = CaptureS = Restore the Saved ScreenShot by Hotkey and then start capturing
Test       = Test = Test the Text from the Code to see if it can be found on the screen
TestClip   = Test2 = Test the Text from the Left Box and copy the result to Clipboard
Paste      = Paste = Paste the Text from Clipboard to the Left Box
CopyOffset = Copy2 = Copy the Offset to Clipboard
Copy       = Copy = Copy the selected or all of the code to the clipboard
Reset      = Reset = Reset to Original Captured Image
SplitAdd   = SplitAdd = Using Markup Segmentation to Generate Text Library
AllAdd     = AllAdd = Append Another FindText Search Text into Previously Generated Code
OK         = OK = Create New FindText Code for Testing
Cancel     = Cancel = Close the Window Don't Do Anything
Save       = SavePic = Save the trimmed original image to the default directory
Gray2Two      = Gray2Two = Converts Image Pixels from Gray Threshold to Black or White
GrayDiff2Two  = GrayDiff2Two = Converts Image Pixels from Gray Difference to Black or White
Color2Two     = Color2Two = Converts Image Pixels from Color Similar to Black or White
ColorPos2Two  = ColorPos2Two = Converts Image Pixels from Color Position to Black or White
ColorDiff2Two = ColorDiff2Two = Converts Image Pixels from Color Difference to Black or White
SelGray    = Gray = Gray value of the selected color
SelColor   = Color = The selected color
SelR       = R = Red component of the selected color
SelG       = G = Green component of the selected color
SelB       = B = Blue component of the selected color
RepU       = -U = Undo Cut the Upper Edge by 1
CutU       = U = Cut the Upper Edge by 1
CutU3      = U3 = Cut the Upper Edge by 3
RepL       = -L = Undo Cut the Left Edge by 1
CutL       = L = Cut the Left Edge by 1
CutL3      = L3 = Cut the Left Edge by 3
Auto       = Auto = Automatic Cut Edge after image has been converted to black and white
RepR       = -R = Undo Cut the Right Edge by 1
CutR       = R = Cut the Right Edge by 1
CutR3      = R3 = Cut the Right Edge by 3
RepD       = -D = Undo Cut the Lower Edge by 1
CutD       = D = Cut the Lower Edge by 1
CutD3      = D3 = Cut the Lower Edge by 3
Modify     = Modify = Allows Modify the Black and White Image
MultiColor = FindMultiColor = Click multiple colors with the mouse, then Click OK button
Undo       = Undo = Undo the last selected color
Comment    = Comment = Optional Comment used to Label Code ( Within <> )
Threshold  = Gray Threshold = Gray Threshold which Determines Black or White Pixel Conversion (0-255)
GrayDiff   = Gray Difference = Gray Difference which Determines Black or White Pixel Conversion (0-255)
Similar1   = Similarity = Adjust color similarity as Equivalent to The Selected Color
Similar2   = Similarity = Adjust color similarity as Equivalent to The Selected Color
DiffR      = R = Red Difference which Determines Black or White Pixel Conversion (0-255)
DiffG      = G = Green Difference which Determines Black or White Pixel Conversion (0-255)
DiffB      = B = Blue Difference which Determines Black or White Pixel Conversion (0-255)
DiffRGB    = R/G/B = Determine the allowed R/G/B Error (0-255) when Find MultiColor
Bind0      = BindWin1 = Bind the window and Use GetDCEx() to get the image of background window
Bind1      = BindWin1+ = Bind the window Use GetDCEx() and Modify the window to support transparency
Bind2      = BindWin2 = Bind the window and Use PrintWindow() to get the image of background window
Bind3      = BindWin2+ = Bind the window Use PrintWindow() and Modify the window to support transparency
Bind4      = BindWin3 = Bind the window and Use PrintWindow(,,3) to get the image of background window
OK2        = OK = Restore this ScreenShot
Cancel2    = Cancel = Close the Window Don't Do Anything
ClearAll   = ClearAll = Clean up all saved ScreenShots
OpenDir    = OpenDir = Open the saved screenshots directory
SavePic    = SavePic = Select a range and save as a picture
ClipText   = = Displays the Text data from clipboard
Offset     = = Displays the results of GetOffset2
s1  = FindText
s2  = Gray|GrayDiff|Color|ColorPos|ColorDiff|MultiColor
s3  = Capture Image To Text
s4  = Capture Image To Text And Find Text Tool
s5  = Position|First click RButton\nMove the mouse away\nSecond click RButton
s6  = Unbind Window using
s7  = Please drag a range with the LButton\nCoordinates are copied to clipboard
s8  = Found|Time|ms|Pos|Result
s9  = Success
s10 = The Capture Position|Perspective binding window\nRight click to finish capture
s11 = Please Set Gray Difference First
s12 = Please select the core color first
s13 = Please convert the image to black or white first
s14 = Can't be used in ColorPos mode, because it can cause position errors
s15 = Are you sure about the scope of your choice?\n\nIf not, you can choose again
    )"
    Lang:=[], Tip_Text:=[]
    Loop Parse, s, `n, `r
      if InStr(v:=A_LoopField, "=")
        r:=StrSplit(StrReplace(v,"\n","`n"), "=", "`t ")
        , Lang[r[1]]:=r[2], Tip_Text[r[1]]:=r[3]
    return
  }
}

}  ;// Class End

;================= The End =================

;
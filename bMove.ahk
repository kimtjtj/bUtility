#include bMove_Functions.ahk

ConfigFile = bMove.ini
goto INILoad

INILoad:
InitConfigKey("", SendPreMove, "SendPreMove")
InitConfigKey("", SendPostMove, "SendPostMove")

x = 4
y = 6

f1::
Move:
map := GetMap()
nextDAT := GetDATFromMap(map)
if(currentDAT != nextDAT)
{
	FileDelete, %currentDAT%
	currentDAT = %nextDAT%
}

GetCurrentPosition(x, y)
runwait, bFindPath.exe %x% %y% %currentDAT% 1, , UseErrorLevel
direction = %ErrorLevel%

if(ErrorLevel <= 0)
{
	v := GetValueFromDAT("Tile", "Pass", currentDAT)
	if(v != "")
		SetValueToDAT("Tile", "Pass", "", currentDAT)
	else
	{
		FileDelete, %currentDAT%
		currentDAT := GetDATFromMap(map)
		msgbox, %currentDAT%
	}
}
else
{
	v := GetValueFromDAT("Tile", "Tile_" . x . "_" . y, currentDAT)
	ResetDirection(direction, v, x, y, currentDAT)
	SendMove(direction, x, y, SendPreMove, SendPostMove)
}
	
return


!f10::
exitapp


; 어느맵인지 검사
; dat 파일 있는지 검사 (없으면 복사, 기존맵과 다르면 기존dat 삭제)
; 현재 좌표 검사
; direction := RunWait bFindPath
; if(direction <= 0)
;   if(Pass) removePass
;   else ResetDAT
; else
;   removeDirectionFromDAT()
;   PreMove()
;   move(direction)
;   PostMove()


; 왕복? 순환?
; bMove.ini, premove, postmove

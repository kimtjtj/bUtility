#include bMove_Functions.ahk
#include libArus.ahk

ConfigFile = bMove.ini
goto INILoad

INILoad:
InitConfigKey("", SendPreMove, "SendPreMove")
InitConfigKey("", SendPostMove, "SendPostMove")

x = 4
y = 6

filedelete, copy*.dat

f1::
Move:
map := GetMap()
nextDAT := GetDATFromMap(map)
if(currentDAT != nextDAT)
{
	FileDelete, %currentDAT%
	currentDAT = %nextDAT%
}

; result = GetCurrentPosition(x, y)
result := GetCurrentPosition_ActiveWindow(x, y)
if(result = -1)
{
	msgbox Cannot Find Position
	return
}
; msgbox %x% %y%

runwait, bFindPath.exe %x% %y% %currentDAT%, , UseErrorLevel|Hide
; runwait, bFindPath.exe %x% %y% %currentDAT% 1, , UseErrorLevel
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

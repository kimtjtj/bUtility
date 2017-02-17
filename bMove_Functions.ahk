#include gdip.ahk
#include ImageSearch_inactive.ahk

InitConfigKey(value, ByRef globalVariable, key)
{
	global ConfigFile
	iniread, globalVariable, %ConfigFile%, bMove, %key%
	if(globalVariable = "ERROR")
	{
		iniwrite, %value%, %ConfigFile%, bMove, %key%
		globalVariable = %value%
	}
}

GetMap()
{
	return "Test"
}

GetDATFromMap(mapName)
{
	fileOriginal = %A_WorkingDir%\dat\%mapName%.dat
	fileTemp = %A_WorkingDir%\copy%mapName%.dat
	file := FileExist(fileTemp)
	if(file = "") ; 파일 없음. 맵 이동한 상태로 가정
	{
		FileCopy, %fileOriginal%, %fileTemp%
	}
	
	return fileTemp
}

GetCurrentPosition(ByRef x, ByRef y)
{
	return 0
}

GetCurrentPosition_InActiveWindow(ByRef x, ByRef y, window)
{
	
	return 0
}

GetValueFromDAT(section, key, fileDAT)
{
	iniread, v, %fileDAT%, %section%, %key%, ""
	return %v%
}

SetValueToDAT(section, key, value, fileDAT)
{
	iniwrite, %value%, %fileDAT%, %section%, %key%
}

ResetDirection(direction, movable, x, y, fileDAT)
{
	east := SubStr(movable, 1, 1)
	west := SubStr(movable, 2, 1)
	south := SubStr(movable, 3, 1)
	north := SubStr(movable, 4, 1)
	
	key = Tile_%x%_%y%

	if(direction = 1)
	{
		east = 0
	}
	else if(direction = 2)
	{
		west = 0
	}
	else if(direction = 3)
	{
		south = 0
	}
	else if(direction = 4)
	{
		north = 0
	}
	
	movable = %east%%west%%south%%north%
	SetValueToDAT("Tile", key, movable, fileDAT)
}

SendMove(direction, ByRef x, ByRef y, SendPreMove, SendPostMove)
{
	; controlsend, sendpremove
	local moveKey

	if(direction = 1)
	{
		x++
		moveKey = {Right}
	}
	else if(direction = 2)
	{
		x--
		moveKey = {Left}
	}
	else if(direction = 3)
	{
		y++
		moveKey = {Down}
	}
	else if(direction = 4)
	{
		y--
		moveKey = {Up}
	}
	Send, %moveKey%
	; controlsend, moveKey
	; controlsend, SendPostMove
	
}

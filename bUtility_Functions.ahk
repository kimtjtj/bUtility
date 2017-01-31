bTabbing = 

InitConfigKey(value, ByRef globalVariable, key)
{
	global ConfigFile
	iniread, globalVariable, %ConfigFile%, bUtility, %key%
	if(globalVariable = "ERROR")
	{
		iniwrite, %value%, %ConfigFile%, bUtility, %key%
		globalVariable = %value%
	}
}

HealerHealSelf(nHealSelf, keyHeal, windowHealer, windowOtherHealer)
{
	ControlSend, , {esc}1{Home}{enter}, ahk_id %windowHealer%
	SendToOtherHealer("{esc}1{Home}{enter}", windowOtherHealer)
	loop %nHealSelf%
	{
		Sleep 50
		ControlSend, , %keyHeal%{enter}, ahk_id %windowHealer%
		SendToOtherHealer(keyHeal . "{enter}", windowOtherHealer)
	}
	Sleep 50
	global bTabbing
	bTabbing = true
	ControlSend, , {tab 2}, ahk_id %windowHealer%
	SendToOtherHealer("{tab 2}", windowOtherHealer)
	bTabbing =
}

HealerMeditation(keyBakho, keyMeditation, windowHealer, windowOtherHealer)
{
	global bTabbing
	bTabbing = true
	ControlSend, , %keyBakho%, ahk_id %windowHealer%
	SendToOtherHealer(keyBakho, windowOtherHealer)

	sleep 500
	ControlSend, , %keyMeditation%, ahk_id %windowHealer%
	SendToOtherHealer(keyMeditation, windowOtherHealer)
	Sleep 1200
	bTabbing =
}

SendToOtherHealer(keys, windowOtherHealer)
{
	for idx, window in windowOtherHealer
		ControlSend, , %keys%, ahk_id %window%
}

SendArrowAllBaram( keyArrow, windowAttacker, windowHealer )
{
	if( GetKeyState("CapsLock", "T") = 0 )
	{
		Send, {%keyArrow%}
		return
	}
	else
	{
		SendArrowBaram(keyArrow, windowAttacker)
		SendArrowHealer(keyArrow, windowHealer)
	}
}

SendArrowBaram(keyArrow, windowBaram)
{
	if( windowBaram <> "" )
	{
		ControlSend, , {%keyArrow%}, ahk_id %windowBaram%
	}
}

SendArrowHealer(keyArrow, windowHealer)
{
	global bTabbing
	if( windowHealer <> "" && bTabbing = "" )
	{
		ControlSend, , {%keyArrow%}, ahk_id %windowHealer%
	}
}

HealerMagic(inputMagic, windowHealer)
{
	msg := "`n`n사용할 마법을 입력`nesc : 종료`n`n "
	ToolTip, %msg%
	Input, inputMagic, L1, {esc}
	
	if(ErrorLevel = "EndKey:Escape")
	{
		return
	}
	
	SendMagic(inputMagic, windowHealer)
}

SendMagic(inputMagic, window)
{
	if inputMagic is number
	{
		ControlSend, , %inputMagic%{enter}, ahk_id %window%
		return
	}
	
	if inputMagic is upper
	{
		StringUpper, inputMagic, inputMagic
		inputMagic := "{shift down}" . inputMagic . "{shift up}"
	}
	global bTabbing
	bTabbing = true
	ControlSend, , {shift down}Z{shift up}, ahk_id %window%
	Sleep, 100
	ControlSend, , %inputMagic%, ahk_id %window%
	bTabbing =
}

HealerBuff(strHealerBuff, window)
{
	StringSplit, text, strHealerBuff, |
	i = 1
	Loop, %text0%
	{
		str = % text%i%
		if(1 = InStr(str, "{") )
			ControlSend, , %str%, ahk_id %window%
		else
			SendMagic(str, window)
		i++
	}

}

GetIsTabbing()
{
	global bTabbing
	return bTabbing
}

ToggleKeySendWindow(windowHealer)
{
	msg := "`n`n" . windowHealer . " 전송중(esc : 종료)`n`n "
	ToolTip, %msg%
	Loop
	{
		Input, keyControlSend, L1 M, {esc}{Up}{Down}{Left}{Right}{Home}{Tab}
		IfInString, ErrorLevel, EndKey:
		{
			if(ErrorLevel = "EndKey:Escape")
				break
			if(ErrorLevel = "EndKey:Up")
				ControlSend, , {Up}, ahk_id %windowHealer%
			if(ErrorLevel = "EndKey:Down")
				ControlSend, , {Down}, ahk_id %windowHealer%
			if(ErrorLevel = "EndKey:Left")
				ControlSend, , {Left}, ahk_id %windowHealer%
			if(ErrorLevel = "EndKey:Right")
				ControlSend, , {Right}, ahk_id %windowHealer%
			if(ErrorLevel = "EndKey:Home")
				ControlSend, , {Home}, ahk_id %windowHealer%
			if(ErrorLevel = "EndKey:Tab")
				ControlSend, , {Tab}, ahk_id %windowHealer%
			
			continue
		}
		ControlSend, , %keyControlSend%, ahk_id %windowHealer%
	}
}
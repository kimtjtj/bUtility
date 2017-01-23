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

HealerHealSelf(nHealSelf, keyHeal, windowHealer)
{
	ControlSend, , {esc}1{Home}{enter}, ahk_id %windowHealer%
	loop %nHealSelf%
	{
		Sleep 50
		ControlSend, , %keyHeal%{enter}, ahk_id %windowHealer%
	}
	Sleep 50
	global bTabbing
	bTabbing = true
	ControlSend, , {tab 2}, ahk_id %windowHealer%
	bTabbing =
}

HealerMeditation(keyBakho, keyMeditation, windowHealer)
{
	global bTabbing
	bTabbing = true
	ControlSend, , %keyBakho%, ahk_id %windowHealer%
	sleep 500
	ControlSend, , %keyMeditation%, ahk_id %windowHealer%
	Sleep 1200
	bTabbing =
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
		SetCapsLockState, AlwaysOn
		SendArrowBaram(keyArrow, windowAttacker)
		SendArrowHealer(keyArrow, windowHealer)
		SetCapsLockState, On
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
	
	stringupper, inputMagicUpper, inputMagic
	if( inputMagicUpper == inputMagic )
	{
		inputMagic := "{Shift down}" . inputMagic . "{Shift Up}"
	}
	ControlSend, , {shift Down}z{Shift Up}, ahk_id %window%
	Sleep, 100
	ControlSend, , %inputMagic%, ahk_id %window%
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
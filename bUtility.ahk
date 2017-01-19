
ConfigFile = bUtility.ini

InitConfigKey(1, KeyHeal, "KeyHeal")
InitConfigKey(2, keyBakho, "keyBakho")
InitConfigKey(4, keyKumkang, "keyKumkang")
InitConfigKey(6, keyMeditation, "keyMeditation")
InitConfigKey(7, keyMankong, "keyMankong")
InitConfigKey("", keyKwangpok, "keyKwangpok")
InitConfigKey(333, nHealInterval, "nHealInterval")

windowKeySend = 
bRepeatHeal =
windowAttacker =
windowHealer =

tooltip, Press ScrollLock On Attacker Window

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

#ifwinactive 바람의나라

ScrollLock::
if(windowAttacker = "")
{
	windowAttacker := WinExist("A")
	tooltip, Press ScrollLock On Healer Window
	return
}
if(windowHealer = "")
{
	windowHealer := WinExist("A")
	tooltip
	return
}
return

`::
macroText := "tab : 키전송 창 전환|1 : 체밀기|2 : 자힐,명상|3 : 만공|4 : 도사 마법|F9 : 매크로종료" ; |로 구분. 10개까지 가능
StringSplit, text, macroText, |
tooltiptext = esc : cancel
i = 1
Loop, %text0%
{
	tooltiptext = % tooltiptext . "`n" . text%i%
	i++
}
ToolTip %tooltiptext%
Input, inputKey, L1, {Tab}{f9}
IfInString, ErrorLevel, EndKey:
{
	if(ErrorLevel = "EndKey:Tab")
		gosub ToggleKeySendWindow
	if(ErrorLevel = "EndKey:F9")
		ExitApp
}
if(inputKey = 1)
{
	if(bRepeatHeal = "")
	{
		bRepeatHeal = true

		if(windowHealer = "")
			return
			
		SetTimer, RepeatHeal, -0
	}
	else
		bRepeatHeal =
}
else if(inputKey = 2)
{
	if(bRepeatHeal = "")
	{
		ControlSend, , %keyMeditation%, ahk_id %windowHealer%
		Sleep 1200
		ControlSend, , {esc}1{Home}{enter}, ahk_id %windowHealer%
		loop 5
		{
			Sleep 50
			ControlSend, , %keyheal%, ahk_id %windowHealer%
			Sleep 50
			ControlSend, , {enter}, ahk_id %windowHealer%
		}
		Sleep 50
		ControlSend, , {tab}, ahk_id %windowHealer%
		Sleep 50
		ControlSend, , {tab}, ahk_id %windowHealer%
	}
	else
	{
		nHealerHeal = 5
		nMeditation := nHealingCount + 1 ; 명상을 하기 위한 flag
	}
}
else if(inputKey = 3) ; 만공
{
	ControlSend, , %keyMankong%, ahk_id %windowHealer%
}
else if(inputKey = 4) ; 도사 마법
{
	gosub, HealerMagic
}
macroTextEnd:
tooltip
return

RepeatHeal:
nMeditation = 0
nMeditationCoolTime = 16000
nHealingCount := nMeditationCoolTime / nHealInterval
While 1
{
	if(bRepeatHeal = "")
		break
	
	ControlSend, , %keyHeal%%keyKumkang%%keyKwangpok%, ahk_id %windowHealer%
	Sleep %nHealInterval%
	nMeditation++
	
	if(nMeditation > nHealingCount)
	{
		nMeditation = 0
		ControlSend, , %keyBakho%%keyMeditation%, ahk_id %windowHealer%
		Sleep 1200
		if(nHealerHeal = "")
			nHealerHeal = 1
	}
	
	if(nHealerHeal <> "")
	{
		ControlSend, , {esc}%keyHeal%{Home}{enter}, ahk_id %windowHealer%
		loop %nHealerHeal%
		{
			Sleep 50
			ControlSend, , %keyheal%, ahk_id %windowHealer%
			Sleep 50
			ControlSend, , {enter}, ahk_id %windowHealer%
		}
		Sleep 50
		ControlSend, , {tab}, ahk_id %windowHealer%
		Sleep 50
		ControlSend, , {tab}, ahk_id %windowHealer%

		nHealerHeal = 
	}
}
return

ToggleKeySendWindow:
windowKeySend = %windowHealer%
msg := "`n`n" . windowKeySend . " 전송중(esc : 종료)`n`n "
ToolTip, %msg%
Loop
{
	Input, keyControlSend, L1 M, {esc}{Up}{Down}{Left}{Right}{Home}{Tab}
	IfInString, ErrorLevel, EndKey:
	{
		if(ErrorLevel = "EndKey:Escape")
			break
		if(ErrorLevel = "EndKey:Up")
			ControlSend, , {Up}, ahk_id %windowKeySend%
		if(ErrorLevel = "EndKey:Down")
			ControlSend, , {Down}, ahk_id %windowKeySend%
		if(ErrorLevel = "EndKey:Left")
			ControlSend, , {Left}, ahk_id %windowKeySend%
		if(ErrorLevel = "EndKey:Right")
			ControlSend, , {Right}, ahk_id %windowKeySend%
		if(ErrorLevel = "EndKey:Home")
			ControlSend, , {Home}, ahk_id %windowKeySend%
		if(ErrorLevel = "EndKey:Tab")
			ControlSend, , {Tab}, ahk_id %windowKeySend%
		
		continue
	}
	ControlSend, , %keyControlSend%, ahk_id %windowKeySend%
}
windowKeySend=
return

KeySendBaram:
if( windowAttacker <> "")
{
	ControlSend, , %keyArrow%, ahk_id %windowAttacker%
}
if( windowHealer <> "")
{
	ControlSend, , %keyArrow%, ahk_id %windowHealer%
}
return

SendHotkey( keySend )
{
	if( GetKeyState("CapsLock", "T") = 0 )
	{
		Send, {%keySend%}
		return
	}
	else
	{
		global keyArrow
		keyArrow = {%keySend%}
		SetCapsLockState, AlwaysOn
		gosub KeySendBaram
		SetCapsLockState, On
	}
}

HealerMagic:
msg := "`n`n사용할 마법을 입력`n`n "
ToolTip, %msg%
Input, inputMagic, L1, {esc}
if inputMagic is number
{
	ControlSend, , %inputMagic%{enter}, ahk_id %windowHealer%
	return
}
if( GetKeyState("Shift", "P") = 1 )
{
	inputMagic := "{Shift down}" . inputMagic . "{Shift Up}"
}
ControlSend, , {shift Down}z{Shift Up}, ahk_id %windowHealer%
Sleep, 100
ControlSend, , %inputMagic%, ahk_id %windowHealer%
return

Up::
SendHotkey("Up")
return

Down::
SendHotkey("Down")
return

Left::
SendHotkey("Left")
return

Right::
SendHotkey("Right")
return

!Up::
ControlSend, , {Up}, ahk_id %windowHealer%
return

!Down::
ControlSend, , {Down}, ahk_id %windowHealer%
return

!Left::
ControlSend, , {Left}, ahk_id %windowHealer%
return

!Right::
ControlSend, , {Right}, ahk_id %windowHealer%
return

#ifwinactive


!f9::
exitapp


; FindAnotherWindow:
; WinGet windows, List
; Loop %windows%
; {
	; winid := windows%A_Index%
	; WinGetTitle, title, ahk_id %winid%
	; current := WinExist("A")
	; if( windowBaram = title && winid != current)
	; {
		; windowKeySend = %winid%
		; break
	; }
; }
; return

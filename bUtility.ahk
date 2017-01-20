#include butility_Functions.ahk

windowAttacker =
windowHealer =

tooltip, Press ScrollLock On Attacker Window

ConfigFile = bUtility.ini
goto INILoad

INILoad:
InitConfigKey(1, KeyHeal, "KeyHeal")
InitConfigKey(2, keyBakho, "keyBakho")
InitConfigKey(4, keyKumkang, "keyKumkang")
InitConfigKey(6, keyMeditation, "keyMeditation")
InitConfigKey(7, keyMankong, "keyMankong")
InitConfigKey("", keyKwangpok, "keyKwangpok")
InitConfigKey(333, nHealInterval, "nHealInterval")
InitConfigKey(3, nHealSelf, "nHealSelf")

bRepeatHeal =

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
macroText := "tab : 키전송 창 전환|1 : 체밀기|2 : 자힐,명상|3 : 만공|4 : 도사 마법|F5 : INI 파일 다시 로드|F9 : 매크로종료" ; |로 구분. 10개까지 가능
StringSplit, text, macroText, |
tooltiptext = esc : cancel
i = 1
Loop, %text0%
{
	tooltiptext = % tooltiptext . "`n" . text%i%
	i++
}
ToolTip %tooltiptext%
Input, inputKey, L1, {Tab}{f5}{f9}
IfInString, ErrorLevel, EndKey:
{
	if(ErrorLevel = "EndKey:Tab")
		ToggleKeySendWindow(windowHealer)
	if(ErrorLevel = "EndKey:F5")
		gosub INILoad
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
		HealerHealSelf(nHealSelf, keyHeal, windowHealer)
		HealerMeditation(keyBakho, keyMeditation, windowHealer)
	}
	else
	{
		nHealerHeal = %nHealSelf%
		nMeditation := nHealingCount + 1 ; 명상을 하기 위한 flag
	}
}
else if(inputKey = 3) ; 만공
{
	ControlSend, , %keyMankong%, ahk_id %windowHealer%
}
else if(inputKey = 4) ; 도사 마법
{
	HealerMagic(inputMagic, windowHealer)
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
		HealerMeditation(keyBakho, keyMeditation, windowHealer)
	}
	
	if(nHealerHeal <> "")
	{
		HealerHealSelf(nHealSelf, keyHeal, windowHealer)
		nHealerHeal = 
	}
}
return

Up::
SendArrowAllBaram("Up", windowAttacker, windowHealer)
return

Down::
SendArrowAllBaram("Down", windowAttacker, windowHealer)
return

Left::
SendArrowAllBaram("Left", windowAttacker, windowHealer)
return

Right::
SendArrowAllBaram("Right", windowAttacker, windowHealer)
return

!Up::
SendArrowHealer("Up", windowHealer)
return

!Down::
SendArrowHealer("Down", windowHealer)
return

!Left::
SendArrowHealer("Left", windowHealer)
return

!Right::
SendArrowHealer("Right", windowHealer)
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

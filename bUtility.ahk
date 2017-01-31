#include butility_Functions.ahk

windowAttacker =
windowHealer =
nCurOtherHealer = 0
listOtherHealer := Object()

SetStoreCapslockMode, Off

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
InitConfigKey(0, nOtherHealer, "nOtherHealer")
InitConfigKey("", strHealerBuff, "strHealerBuff")

bRepeatHeal =

#ifwinactive �ٶ��ǳ���

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
	if(nOtherHealer = 0)
		tooltip
	else
		tooltip, Press ScrollLock On Other Healer Window 0
	return
}

if(nOtherHealer <= nCurOtherHealer)
	return

listOtherHealer.insert(WinExist("A"))
nCurOtherHealer++
if(nOtherHealer = nCurOtherHealer)
	tooltip
else
	tooltip, % "Press ScrollLock On Other Healer Window" . nCurOtherHealer

return

`::
macroText := "tab : Ű���� â ��ȯ|1 : ü�б�|2 : ����,���|3 : ����|4 : ���� ����|5 : ����|F5 : INI ���� �ٽ� �ε�|F9 : ��ũ������" ; |�� ����. 10������ ����
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
		HealerHealSelf(nHealSelf, keyHeal, windowHealer, listOtherHealer)
		HealerMeditation(keyBakho, keyMeditation, windowHealer, listOtherHealer)
	}
	else
	{
		nHealerHeal = %nHealSelf%
		nMeditation := nHealingCount + 1 ; ����� �ϱ� ���� flag
	}
}
else if(inputKey = 3) ; ����
{
	ControlSend, , %keyMankong%, ahk_id %windowHealer%
}
else if(inputKey = 4) ; ���� ����
{
	HealerMagic(inputMagic, windowHealer)
}
else if(inputKey = 5) ; ����
{
	HealerBuff(strHealerBuff, windowHealer)
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
	
	if( GetIsTabbing() <> "")
		continue
	
	keySend = {%keyHeal% DOWN}%keyKumkang%%keyKwangpok%
	SendToOtherHealer(keySend, listOtherHealer)
		
	ControlSend, , {%keyHeal% DOWN}%keyKumkang%%keyKwangpok%, ahk_id %windowHealer%
	Sleep %nHealInterval%
	nMeditation++
	
	if(nMeditation > nHealingCount)
	{
		nMeditation = 0
		HealerMeditation(keyBakho, keyMeditation, windowHealer, listOtherHealer)
		nHealerHeal = %nHealSelf%
	}
	
	if(nHealerHeal > 0)
	{
		HealerHealSelf(nHealSelf, keyHeal, windowHealer, listOtherHealer)
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

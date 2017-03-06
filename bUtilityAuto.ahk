; 이미지인식(명상, 격수좌표 옆으로 이동, 격수와 맵이 다르면 Goal로 이동? 명령시 이동?), 이미지 리소스 생성하는 exe


#include butility_Functions.ahk
; #include bUtilityAuth_Functions.ahk

windowAttacker =
windowHealer =

SetStoreCapslockMode, Off

tooltip, Press ScrollLock On Attacker Window

ConfigFile = bUtilityAuto.ini
goto INILoad

INILoad:
InitConfigKey(1, KeyHeal, "KeyHeal")
InitConfigKey(333, nHealInterval, "nHealInterval")

InitConfigKey(4, keyKumkang, "keyKumkang")
InitConfigKey(1000, nKumkangInterval, "nKumkangInterval")

InitConfigKey(5, keyDebuff, "keyDebuff")
InitConfigKey(6, keyMeditation, "keyMeditation")

InitConfigKey("", keyBuffMagic, "keyBuffMagic") ; 버프 키
InitConfigKey("", strBuffMagicImage, "strBuffMagicImage") ; 버프 이미지 파일

InitConfigKey(1000, nCaptureInterval, "nCaptureInterval")

bRepeatHeal =

#ifwinactive 바람의나라

ScrollLock::
if(windowAttacker = "")
{
	windowAttacker := WinExist("A")
	tooltip, Press ScrollLock On Healer Window
	return
}

windowHealer := WinExist("A")
tooltip
return

`::
macroText := "tab : 키전송 창 전환|1 : 자동힐|2 : 혼|z : 격수 마법 사용|F5 : INI 파일 다시 로드|F9 : 매크로종료" ; |로 구분. 10개까지 가능
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
	{
		if(bRepeatHeal = "true")
			ControlSend, , {esc}, ahk_id %windowHealer%
		ToggleKeySendWindow(windowHealer)
		if(bRepeatHeal = "true")
			ControlSend, , {tab 2}, ahk_id %windowHealer%
	}
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
	if(bRepeatHeal = "true")
	{
		ControlSend, , {esc}%keyDebuff%{home}{esc}, ahk_id %windowHealer%
	}
		
	while 1
	{
		tooltip, press ARROW/ESC to Debuff/cancel
		Input, inputKey, L1, {Up}{Down}{Left}{Right}{esc}
		
		if(ErrorLevel = "EndKey:Escape")
		{
			break
		}
		else
		{
			keySend := keyDebuff "{" SubStr(ErrorLevel, 8) "}{Enter}"
			ControlSend, , %keySend%, ahk_id %windowHealer%
		}
	}
	
	if(bRepeatHeal = "true")
	{
		ControlSend, , {tab 2}, ahk_id %windowHealer%
	}
}
else if(inputKey = "z")
{
	tooltip press magicbutton to use On Attacker
	Input, inputKey, L1, {esc}
	Send, {shift down}z{shift up}%inputKey%
}

macroTextEnd:
tooltip
return

RepeatHeal:
nLastCapture := A_TickCount
nLastKumkang := A_TickCount + 500
nLastMeditation = 0

; 주기마다 반복
; 격수 이미지 캡쳐(맵, 좌표)
; 도사 이미지 캡쳐(맵, 좌표, 버프)
; 격수맵 == 도사맵?
; 같은맵이면 이동 시간 확인, 한칸 이동(절대값 차이로 두칸 이내, Pass 이용)
; 다른맵이면 Goal로 이동
; 버프 확인, 걸기
; 시전시간 있으면?

; 주기마다 반복
; 금강

; 주기마다 반복
; 힐

while 1
{
	if(bRepeatHeal = "")
		break
	
	if( GetIsTabbing() <> "")
		continue

	nTickCount = %A_TickCount%
	if(nLastCapture + nCaptureInterval <= A_TickCount)
	{
		nLastCapture = %A_TickCount%
	}

	if(nLastKumkang + nKumkangInterval <= A_TickCount)
	{
		keySend = %keyKumkang%
		ControlSend, , %keySend%, ahk_id %windowHealer%

		nLastKumkang = %A_TickCount%
	}

	if(nLastHeal + nHealInterval <= A_TickCount)
	{
		keySend = %keyHeal%
		ControlSend, , %keySend%, ahk_id %windowHealer%

		nLastHeal = %A_TickCount%
	}
	
	; Temp
	if(nLastSelfHeal + 5000 <= A_TickCount)
	{
		nHealSelf = 1
		HealerHealSelf(nHealSelf, keyHeal, windowHealer, listOtherHealer)

		nLastSelfHeal = %A_TickCount%
	}
	
	if(nLastMeditation + 31000 <= A_TickCount)
	{
		HealerMeditation("", keyMeditation, windowHealer, listOtherHealer)

		nLastMeditation = %A_TickCount%
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

^!+Up::
ControlAltShiftUp(windowHealer)
SendMagic("q4{enter}", windowHealer)
Send {shift down}z{shift up}q4{enter}
return

^!+Left::
ControlAltShiftUp(windowHealer)
SendMagic("q2{enter}", windowHealer)
Send {shift down}z{shift up}q2{enter}
return

^!+Right::
ControlAltShiftUp(windowHealer)
SendMagic("q1{enter}", windowHealer)
Send {shift down}z{shift up}q1{enter}
return

^!+Down::
ControlAltShiftUp(windowHealer)
SendMagic("q3{enter}", windowHealer)
Send {shift down}z{shift up}q3{enter}
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

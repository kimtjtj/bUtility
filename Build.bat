goto ExecuteRoutine

@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리 권한을 요청 ...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    rem del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
pushd "%CD%"
    CD /D "%~dp0"

:ExecuteRoutine

taskkill /f /im bUtility.exe

"c:\program files (x86)\autohotkey\compiler\ahk2exe" /in "bUtility.ahk"

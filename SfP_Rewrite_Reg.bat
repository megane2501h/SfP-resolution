@echo off
set "Height_Default=Screenmanager Resolution Height Default_h1380706816"
set "Height=Screenmanager Resolution Height_h2627697771"
set "Width_Default=Screenmanager Resolution Width Default_h680557497"
set "Width=Screenmanager Resolution Width_h182942802"

set "reg_keyname=HKEY_CURRENT_USER\Software\BNE\imasscprism"

set "User_Width=1920"
set "User_Height=1080"

set "Detection_Interval=10"



::============================================
set "first_run_flag=true"

tasklist /FI "IMAGENAME eq imasscprism.exe" | find "imasscprism.exe">NUL
if "%errorlevel%"=="0" set "first_run_flag=false"


:loop_start
set "WH_Change_Detected=false"

::reg_exist_check
reg query "%reg_keyname%" /v "%Width_Default%" >NUL
if not "%errorlevel%"=="0" goto Stop_Bat
reg query "%reg_keyname%" /v "%Width%" >NUL
if not "%errorlevel%"=="0" goto Stop_Bat
reg query "%reg_keyname%" /v "%Height_Default%" >NUL
if not "%errorlevel%"=="0" goto Stop_Bat
reg query "%reg_keyname%" /v "%Height%" >NUL
if not "%errorlevel%"=="0" goto Stop_Bat

::reg_check
echo %date% %time% Check...
reg query "%reg_keyname%" /v "%Width_Default%" | find "0x500" >NUL
if "%errorlevel%"=="0" set "WH_Change_Detected=true"
reg query "%reg_keyname%" /v "%Width%" | find "0x500" >NUL
if "%errorlevel%"=="0" set "WH_Change_Detected=true"
reg query "%reg_keyname%" /v "%Height_Default%" | find "0x2d0" >NUL
if "%errorlevel%"=="0" set "WH_Change_Detected=true"
reg query "%reg_keyname%" /v "%Height%" | find "0x2d0" >NUL
if "%errorlevel%"=="0" set "WH_Change_Detected=true"

if "%WH_Change_Detected%"=="true" echo %date% %time% Resolution change detected. Rewrite to user settings. %User_Width%x%User_Height%
if "%WH_Change_Detected%"=="false" goto run_check

::reg_change
reg add "%reg_keyname%" /v "%Width_Default%" /t REG_DWORD /d "%User_Width%" /f >NUL
if not "%errorlevel%"=="0" goto Stop_Bat
reg add "%reg_keyname%" /v "%Width%" /t REG_DWORD /d "%User_Width%" /f >NUL
if not "%errorlevel%"=="0" goto Stop_Bat
reg add "%reg_keyname%" /v "%Height_Default%" /t REG_DWORD /d "%User_Height%" /f >NUL
if not "%errorlevel%"=="0" goto Stop_Bat
reg add "%reg_keyname%" /v "%Height%" /t REG_DWORD /d "%User_Height%" /f >NUL
if not "%errorlevel%"=="0" goto Stop_Bat


:run_check
if "%first_run_flag%"=="true" goto loop_check
tasklist /FI "IMAGENAME eq imasscprism.exe" | find "imasscprism.exe">NUL
if not "%errorlevel%"=="0" exit

:loop_check
if "%first_run_flag%"=="false" (    
    ping -n %Detection_Interval% 127.0.0.1 >NUL
    goto loop_start
)

echo Complete. Start SfP
start "" "dmmgameplayer://play/GCL/prism/cl/win"
set "first_run_flag=false"

:fist_run_wait
tasklist /FI "IMAGENAME eq imasscprism.exe" | find "imasscprism.exe">NUL
if not "%errorlevel%"=="0" goto fist_run_wait

goto loop_start


:Stop_Bat
echo Error!!!!!!
pause
exit
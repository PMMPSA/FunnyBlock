@echo off
::
:: If you are reading this, then you have managed to get into the main cmd/batch file.
:: This is a message saying that this code license shared with PocketMine-MP Licence.
:: This can be found on https://raw.githubusercontent.com/PocketMine/PocketMine-MP/master/LICENSE
::
:: This has been made by TheDeibo, based on
:: https://forums.pocketmine.net/plugins/automatic-server-restarter.903/field?field=documentation
::
cls
:start
if exist server.properties (
@call:ini server-port gameport
 )
TITLE Pocketmine-MP: Auto-Restart - Port %gameport%
cd /D %~dp0

:loop
If NOT exist server.properties (
goto start1pm
)
set hour=%time:~0,2%
set min=%time:~3,2%
set sec=%time:~6,2%
powershell write-host ^[%hour%:%min%:%sec%^] ^[Auto-Restart^] - Checking if server is active... -foreground "Cyan"
PING 127.0.0.1 -n 10 >NUL
netstat -o -n -a | findstr 0.0:%gameport%>nul
if %ERRORLEVEL% equ 0 (
    powershell write-host ^[Auto-Restart^] Server is Running. -foreground "RED"
    ECHO.
    goto :loop
) ELSE (
    call :StartPM
    goto :Exit
)
goto :EOF

:StartPM
powershell write-host ^[Auto-Restart^] Starting Server... -foreground "GREEN"
ECHO.
call :start1pm
goto :loop

::server.properties
:ini
@for /f "tokens=2 delims==" %%a in ('find "%~1=" server.properties') do @set %~2=%%a
goto :eof

:start1pm
If NOT exist server.properties (
powershell write-host PocketMine-MP First-Time-Start -foreground "Cyan"
echo This is simply a first time start. After you set up your server, the Auto-Restart should then start working!
echo.
echo.
echo Press any key to start the First Time Start for the Server...
pause>nul
)
if exist bin\php\php.exe (
    set PHP_BINARY=bin\php\php.exe
) else (
    set PHP_BINARY=php
)
if exist PocketMine-MP.phar (
    set POCKETMINE_FILE=PocketMine-MP.phar
) else (
    if exist src\pocketmine\PocketMine.php (
        set POCKETMINE_FILE=src\pocketmine\PocketMine.php
    ) else (
        echo Couldn't find a valid PocketMine-MP installation.
        echo.
        pause
exit
    )
)
if exist bin\php\php_wxwidgets.dll (
   %PHP_BINARY% %POCKETMINE_FILE% --enable-gui %*
) else (
    if exist bin\mintty.exe (
        start "" bin\mintty.exe -o Columns=88 -o Rows=32 -o AllowBlinking=0 -o FontQuality=3 -o Font="Consolas" -o FontHeight=10 -o CursorType=0 -o CursorBlinks=1 -h error -t "GenisysPro" -w max %PHP_BINARY% %POCKETMINE_FILE% --enable-ansi %*
    ) else (
        %PHP_BINARY% -c bin\php %POCKETMINE_FILE% %*
exit
    )
)
goto :EOF

:Exit
exit

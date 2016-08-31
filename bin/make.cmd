@echo off
setlocal enableextensions
set start=%time%

set MAKE="%~dp0gmake.exe"
if exist %MAKE% GOTO MAKEFOUND
set MAKE="c:\bin\make.exe"
if exist %MAKE% GOTO MAKEFOUND
set MAKE="%~dp0ext\make.exe"
if exist %MAKE% GOTO MAKEFOUND

echo Can not find a valid make.
exit /b 1

:MAKEFOUND
set BASE=%~dp0

:: Actually call make on the makefile.
%MAKE% %*

set ERROR=%ERRORLEVEL%

set end=%time%
set options="tokens=1-4 delims=:."
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %hours% lss 0 set /a hours = 24%hours%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%

:: mission accomplished
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs% 
echo Make spent %hours%:%mins%:%secs% (%totalsecs%s total), return code %ERROR%

set ALL=%*
set COMMANDS=%ALL: =+%

exit /b %ERROR%

endlocal

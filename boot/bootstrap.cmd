rem @echo off
setlocal

:: Allow for user to set the installation root directory somewhere.
:: This is where we find all the binary distributions.
if exist \\diskstation2\software\python (
  set INSTALL_ROOT=\\diskstation2\software
)
if "%1_" neq "_" set INSTALL_ROOT=%1
echo # Install root: %INSTALL_ROOT%

:: Install chocoloatery
if exist C:\ProgramData\chocolatey\bin\choco.exe goto :SKIP_CHOCO
echo Installing chocolatery
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" > nul
SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

:SKIP_CHOCO

set PATH=%PATH%;c:\bin

echo # Copying minimal environment
if not exist c:\temp mkdir c:\temp
if not exist c:\bin mkdir c:\bin
if not exist c:\bin\7za.exe copy /y %INSTALL_ROOT%\bin\7za.exe c:\bin\7za.exe > nul
if not exist c:\bin\make.cmd (
	copy /y %INSTALL_ROOT%\bin\make.cmd c:\bin\make.cmd > nul
	copy /y %INSTALL_ROOT%\bin\make.exe c:\bin\make.exe > nul
	copy /y %INSTALL_ROOT%\bin\libiconv2.dll c:\bin\libiconv2.dll > nul
	copy /y %INSTALL_ROOT%\bin\libintl3.dll c:\bin\libintl3.dll > nul
)

:: Some privacy stuff
echo # Killing diagnostic tracking
sc delete DiagTrack > nul
sc delete dmwappushservice > nul

:: Kill windows search (this also disables the search in the start menu)
:: echo # Killing windows search
:: sc config wsearch start= disabled > nul
:: net stop wsearch > nul 2>&1

:: Kill onedrive
if not exist C:\Users\%USERNAME%\AppData\Local\Microsoft\OneDrive\OneDrive.exe goto :SKIP_ONEDRIVE
echo # Removing onedrive.
taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
:SKIP_ONEDRIVE

:: goto :SKIP_PACKAGES
echo # Removing some of the stock bloatware
powershell.exe -noprofile -command "Get-AppxPackage *3dbuilder* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *windowsalarms* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *windowscamera* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *officehub* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *skypeapp* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *getstarted* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *zunemusic* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *windowsmaps* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *bingfinance* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *onenote* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *people* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *windowsphone* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *photos* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *bingsports* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *soundrecorder* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
powershell.exe -noprofile -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"

:: Some common packages to install
echo # Installing packages from chocolatery
choco install -y vcredist2005 > nul
choco install -y vcredist2008 > nul
choco install -y vcredist2010 > nul
choco install -y vcredist2012 > nul
choco install -y vcredist2013 > nul
choco install -y vcredist2015 > nul
choco install -y googlechrome > nul
choco install -y notepad2 > nul
choco install -y dotnet3.5 > nul
choco install -y dotnet4.5.2 > nul
choco install -y dotnet4.6.1 > nul
choco install -y sublimetext3 > nul
choco install -y sublimetext3.packagecontrol > nul
choco install -y sumatrapdf > nul
choco install -y totalcommander > nul
choco install -y 7zip.commandline > nul
choco install -y curl > nul
choco install -y git > nul
choco install -y hg > nul
choco install -y python2 > nul
choco install -y vlc > nul
choco install -y sysinternals > nul
choco install -y putty > nul
choco install -y wget > nul
choco install -y winscp > nul
choco install -y paint.net > nul
choco install -y cygwin > nul
choco install -y sourcetree > nul
choco install -y greenshot > nul
choco install -y beyondcompare > nul
choco install -y cpu-z > nul
choco install -y gpu-z > nul
choco install -y speedfan > nul
if not exist C:\ProgramData\chocolatey\bin\cygwin.exe choco install -y cygwin > nul
choco install -y visualstudio2015community  -packageParameters "--AdminFile %~dp0AdminDeployment.xml" > nul
choco install -y blender > nul
choco install -y lastpass > nul
choco install -y virtualbox > nul
choco install -y docker > nul
choco install -y docker-compose > nul
choco install -y docker-machine > nul
choco install -y unxutils > nul
choco install -y windows-sdk-8.1 > nul
choco install -y windows-sdk-10.1 > nul
choco install -y windbg > nul
choco install -y xbox360-controller > nul
choco install -y windows-performance-toolkit > nul
choco install -y crashplan > nul
choco install -y firefox > nul
choco install -y mobaxterm > nul
choco install -y visualstudiocode > nul
:SKIP_PACKAGES

:: Fix python installation
set PYTHON_HOME=c:\tools\python2
echo # Updating pip
set PATH=%PATH%;%PYTHON_HOME%\scripts;%PYTHON_HOME%
python -m pip install --upgrade pip > nul

if not exist %PYTHON_HOME%\scons.bat %PYTHON_HOME%\scripts\pip install --egg SCons

:: Install some licenses if we find them
if exist "c:\program files\totalcmd\totalcmd.exe" (
  if exist %INSTALL_ROOT%\licenses\wincmd.key (
    if not exist "c:\program files\totalcmd\wincmd.key" (
      echo # Installing license key for total commander
      copy %INSTALL_ROOT%\licenses\wincmd.key "c:\program files\totalcmd\wincmd.key" > nul
    )
  )
)

endlocal

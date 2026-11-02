@echo off
setlocal
set "LOG=C:\OEM\chrome-install.log"
set "CHROME_INSTALLER=%TEMP%\ChromeSetup.exe"
echo Starting Chrome 109 installation > "%LOG%"
echo Downloading Chrome 109.0.5414.120 >> "%LOG%"
bitsadmin /transfer ChromeDownload /download /priority normal "https://archive.org/download/google-chrome-109.0.5414.120_202601/109.0.5414.168_chrome_installer_x86.exe" "%CHROME_INSTALLER%" >> "%LOG%" 2>&1
if not exist "%CHROME_INSTALLER%" (
	echo Chrome download failed >> "%LOG%"
	exit /b 1
)
echo Installing Chrome >> "%LOG%"
start /wait "" "%CHROME_INSTALLER%" /silent /install >> "%LOG%" 2>&1
echo Chrome installer exit code: %ERRORLEVEL% >> "%LOG%"
del /q "%CHROME_INSTALLER%"
endlocal

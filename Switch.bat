::https://github.com/Zarpyk/GraphicTabletDriverSwitcher
@echo off

::Set path to current folder
set "currentPath=%~dp0"
::Set driver folder names
set "driver1Name=Parblo"
set "driver2Name=Wacom"

::Set Parblo App location
set "parbloApp=C:\Program Files (x86)\Parblo"

::Set driver path
set "driver1=%currentPath%%driver1Name%"
set "driver2=%currentPath%%driver2Name%"

::Set variable save file name
set "lastDriverFileName=lastDriver"
::Get the last driver used
set /p lastDriver=<"%lastDriverFileName%"
::Trim the lastDriver string
set "lastDriver=%lastDriver:~0,-1%"
::Set location of the drivers
set "driverLocation=C:\Windows\System32"
set "driverLocation2=C:\Windows\SysWOW64"

::Kill Parblo apps
taskkill /f /im "parbloDriver.exe"

::Kill Wacom apps
taskkill /f /im "WacomCenterUI.exe"
taskkill /f /im "WacomHost.exe"
taskkill /f /im "Wacom_UpdateUtil.exe"
taskkill /f /im "Wacom_TouchUser.exe"
taskkill /f /im "Wacom_TabletUser.exe"
taskkill /f /im "Wacom_Tablet.exe"
taskkill /f /im "WTabletServicePro.exe"


if "%lastDriver%" == "%driver1%" (
::If last driver is driver1 go to driver2
	goto driver2
) else if "%lastDriver%" == "%driver2%" (
::If last driver is driver2 go to driver1
	goto driver1
) else (
::If is first time, go to driver1
	set "lastDriver = %driver1%"
	goto driver1
)

::Tag for "goto"
:driver1
::Copy all drivers to driver location
xcopy /s /y /q "%driver1%\System32" "%driverLocation%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
xcopy /s /y /q "%driver1%\SysWOW64" "%driverLocation2%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
::Change last driver to driver 1
echo %driver1% > "%lastDriverFileName%"
::Show what driver is using after change
echo "Driver changed to %driver1Name% driver"
::Parblo need this app to work
start "" /D "%parbloApp%" "parbloDriver.exe"
::Skip to final
goto final

::Tag for "goto"
:driver2
::Copy all drivers to driver location
xcopy /s /y /q "%driver2%\System32" "%driverLocation%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
xcopy /s /y /q "%driver2%\SysWOW64" "%driverLocation2%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
::Change last driver to driver 2
echo %driver2% > "%lastDriverFileName%"
::Show what driver is using after change
echo "Driver changed to %driver2Name% driver"
::Wacom need this service to work
net start WTabletServicePro
::Skip to final
goto final

::Tag for "goto"
:errorfinal
echo "Failed changing drivers, check that all art programs are closed."
::Tag for "goto"
:final
pause
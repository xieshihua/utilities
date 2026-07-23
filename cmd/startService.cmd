echo off
setlocal enabledelayedexpansion

set BlockDivider="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
set Name="startService.cmd"
set Purpose="Start a Windows service if it is not running."
set Usage="startService.cmd [/?] [/t or T] service_name"
set Usage1="       Optional: /? - Help"
set Usage2="       Optional: /t or /T - Test run or dry run."
set Example="startService.cmd AppReadiness /t"
rem set Remark="Set the EffArg_Required to the number of mandatory arguments."
rem set Reference="A thorough reference to Windows CMD commends: https://ss64.com/nt/"

echo %BlockDivider:"=%
echo %Purpose:"=%
echo %BlockDivider:"=%

REM 'shift' will process all the arguments.
set /A Arg_Count=0
set /A Effective_Args=0
set /A EffArg_Required=1
set Is_Test=FALSE
set Is_Help=FALSE
rem set delimiter=""
rem set unexpected_args=""

:arg_loop
if "%~1"=="" goto end_arg_loop
	set /a Arg_Count+=1
	set Is_Effective=TRUE
	if /I "%~1" == "/t" (
		set Is_Test=TRUE
		set Is_Effective=FALSE
	)
	if "%~1" == "/?" (
		set Is_Help=TRUE
		set Is_Effective=FALSE
	)
	
	if %Is_Effective% == TRUE (
		set /A Effective_Args+=1
		rem echo Effective Args: !Effective_Args!
		if !Effective_Args! == 1 (
			set Eff_Arg1=%~1
			set service_name=%~1
		)
		if !Effective_Args! GTR %EffArg_Required% (
			if "!unexpected_args!" GTR "" (
				set delimiter=;
			)
			set unexpected_args=!unexpected_args!!delimiter!%~1
		)
	)
shift
goto arg_loop
:end_arg_loop

if !Effective_Args! lss %EffArg_Required% (
	set Is_Help=TRUE
	call :MSG_EffectiveArgs Error
)

if !Effective_Args! gtr %EffArg_Required% (
	call :MSG_EffectiveArgs Warning
	echo The following arguments are ignored: !unexpected_args!
)

if !Is_Help!==TRUE (
	call :MSG_Help
	exit /b 0
)

if !Is_Test!==TRUE (
	echo.
	sc query %service_name% | findstr RUNNING && (
		echo.
		echo The %service_name% service is already RUNNING.
	) || (
		echo.
		echo The service is not running.
		echo You may run the following command to start the %service_name% service:
		echo.
		echo sc start %service_name%
	)
	echo.
) else (
	echo.
	sc query %service_name% | findstr RUNNING && (
		echo.
		echo The %service_name% service is already RUNNING.
	) || (
		echo.
		echo The service is not running. Start the %service_name% service:
		sc start %service_name%
	)
	echo.
)

if !Is_Help!==TRUE (
	echo.
	echo Name: !Name:"=! 
	echo Purpose: !Purpose:"=!
	echo Usage: !Usage:"=!
	set Usage="       Optional: /? - Help"
	echo !Usage:"=!
	set Usage="       Optional: /t or /T - Test run or dry run."
	echo !Usage:"=!
)

Exit /B 0

:MSG_EffectiveArgs
	echo.
	echo %~1:
	echo Effective Arguments expected: %EffArg_Required%
	echo Actual Effective Arguments received: !Effective_Args!
Exit /B 0

:MSG_Help
	echo.
	echo %BlockDivider:"=%
	echo Name: %Name:"=% 
	echo Purpose: %Purpose:"=%
	echo Usage: %Usage:"=%
	if defined Usage1 (
		echo %Usage1:"=%
	)
	if defined Usage2 (
		echo %Usage2:"=%
	)
	if defined Example (
		echo Example: %Example:"=%
	)
	if defined Remark (
		echo Remark: %Remark:"=%
	)
	if defined Reference (
		echo Reference: %Reference:"=%
	)
	echo %BlockDivider:"=%
Exit /B 0

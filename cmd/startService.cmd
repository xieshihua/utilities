echo off
setlocal enabledelayedexpansion

set Name="startService.cmd"
set Purpose="Start a service if not running."
set Usage="startService.cmd [/?] [/t|T] service_name"

REM 'shift' will process all the arguments.
set /A Arg_Count=0
set /A Effective_Args=0
set /A EffArg_Required=3
set Is_Test=FALSE
set Is_Help=FALSE
rem set delimiter=""
rem set unexpected_args=""

REM Check if at least one argument is passed
if "%~1"=="" (
    echo No argument provided.
	set Is_Help=TRUE
) else (
	echo.
	echo arguments: %*
	echo.
)

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

if "!unexpected_args!" GTR "" (
	echo.
	echo The following arguments are ignored: !unexpected_args!
)

if !Is_Test!==TRUE (
	sc query %service_name% | findstr RUNNING && (
		echo The %service_name% service is already RUNNING.
	) || (
		echo The service is not running. Start the %service_name% service:
		echo sc start %service_name%
	)
	echo.
) else (
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

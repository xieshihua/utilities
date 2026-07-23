echo off
setlocal enabledelayedexpansion

set BlockDivider="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
set Name="testArguments.cmd"
set Purpose="A template to process Windows CMD batch commends arguments."
set Usage="testArguments.cmd [/?] [/t or /T] arg1 arg2 arg3 ..."
set Usage1="       Optional: /? - Help"
set Usage2="       Optional: /t or /T - Test run or dry run."
set Example="testArguments.cmd arg1 arg2 arg3 arg4 arg5 /t"
set Remark="Set the EffArg_Required to the number of mandatory arguments."
set Reference="A thorough reference to Windows CMD commends: https://ss64.com/nt/"

echo %BlockDivider:"=%
echo %Purpose:"=%
echo %BlockDivider:"=%

REM 'shift' will process all the argument.
set /A Arg_Count=0
set /A Effective_Args=0
set /A EffArg_Required=3
set Is_Test=FALSE
set Is_Help=FALSE
rem set delimiter=""
rem set unexpected_args=""

REM Check if at least one argument is passed
REM if "%~1"=="" (
    REM echo No argument is provided.
	REM set Is_Help=TRUE
REM ) else (
	REM echo.
	REM echo arguments: %*
REM )

:arg_loop
if "%~1"=="" goto end_arg_loop
	set /a Arg_Count+=1
	set Is_Effective=TRUE
	rem echo argument !Arg_Count!: %~1
	rem /I          Do a case Insensitive string comparison.
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
			echo Arg1: %~1
		)
		if !Effective_Args! == 2 (
			set Eff_Arg2=%~1
			echo Arg2: %~1
		)
		if !Effective_Args! == 3 (
			set Eff_Arg3=%~1
			echo Arg3: %~1
		)
		if !Effective_Args! GTR %EffArg_Required% (
			if "!unexpected_args!" GTR "" (
				set delimiter=;
				rem echo delimiter: !delimiter!
			)
			set unexpected_args=!unexpected_args!!delimiter!%~1
			rem echo !unexpected_args!
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
	echo Running mode [Active/Test]: Test.
	echo.
) else (
	echo.
	echo Running mode [Active/Test]: Active.
	echo.
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
	echo %Usage1:"=%
	echo %Usage2:"=%
	echo Example: %Example:"=%
	echo Remark: %Remark:"=%
	echo Reference: %Reference:"=%
	echo %BlockDivider:"=%
Exit /B 0

echo off
setlocal enabledelayedexpansion

set BlockDivider0="*********************************************************************"
set BlockDivider1="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
set Name="cmdTemplate.cmd"
set Purpose0="A template to process Windows CMD batch commends arguments."
rem Below are optional Help items. Delete or comment out any item that you do not use.
set Purpose1="         * Please replace head sections with your own notes."
rem use "." to insert a blank line.
set Purpose2="."
set Usage0="cmdTemplate.cmd [/?] [/t or /T] [/p or /P:Path] arg1 arg2 arg3 ..."
set Usage1="       Optional: /? - Help, defaults to FALSE"
set Usage2="       Optional: /t or /T - Test run or dry run, defaults to FALSE"
set Usage3="       Optional: /p or /P - Path to a directory. e.g. /P:C:\dvlp\temp. Defaults to [Path_to_Check] if [/P:Path] is not set."
set Usage4="       [arg1]: The first argument."
set Usage5="       [arg2]: The second argument."
set Usage6="       [arg3]: The third argument." 
set Usage7="."
set Example0=" "
set Example1="- The following command demos a [Test] run with 5 auguments, and to show the command of listing the content of the default folder set by [Path_to_Check]."
set Example2="."
set Example3="    C:\dvlp>cmdTemplate.cmd arg1 arg2 arg3 arg4 arg5 /t"
set Example4="."
set Example5="- The following command demos an [Active] run with 3 auguments, and to list the content of [C:\Program Files] specified by the [/P] optional argument."
set Example6="."
set Example7="    C:\dvlp>cmdTemplate.cmd arg1 arg2 arg3 '/P:C:\Program Files'"
set Example8="."
set Remark0="- Set the EffArg_Required to the number of mandatory arguments."
set Remark1="        - Set Max_Help_Items to the maximun items in the head sections."
set Remark2="."
set Reference0="- A thorough reference to Windows CMD commands can be found at: https://ss64.com/nt/"
set Reference1="           - https://ss64.com/ also provides references of Linux, macOS, PowerShell, ASCII, VBScript, Tools, and Passwords."
set Head_Sections=Purpose,Usage,Example,Remark,Reference
set Max_Help_Items=0,1,2,3,4,5,6,7,8

echo %BlockDivider0:"=%
echo %Name:"=%: %Purpose0:"=%
echo %BlockDivider0:"=%

set Path_to_Check="C:\dvlp"

REM 'shift' will process all the argument.
set /A Arg_Count=0
set /A Effective_Args=0
set /A EffArg_Required=3
set Is_Test=FALSE
set Is_Help=FALSE
rem set delimiter=""
rem set unexpected_args=""

rem This block is for your reference only.
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
	set tmp_arg=%~1
	rem echo tmp_arg: !tmp_arg!
	if "!tmp_arg!" == "/?" (
		set Is_Help=TRUE
		set Is_Effective=FALSE
	)
	if /I "!tmp_arg:~0,2!" == "/p" (
		set Path_to_Check=!tmp_arg:~3!
		set Is_Effective=FALSE
	)
	if /I "!tmp_arg!" == "/t" (
		set Is_Test=TRUE
		set Is_Effective=FALSE
	)
	
	if %Is_Effective% == TRUE (
		set /A Effective_Args+=1
		rem echo Effective Args: !Effective_Args!
		if !Effective_Args! GTR %EffArg_Required% (
			if "!unexpected_args!" GTR "" (
				set delimiter=;
				rem echo delimiter: !delimiter!
			)
			set unexpected_args=!unexpected_args!!delimiter!!tmp_arg!
			rem echo !unexpected_args!
		)
	)
shift
goto arg_loop
:end_arg_loop

if not !Is_Help!==TRUE (
	if !Effective_Args! lss %EffArg_Required% (
		set Is_Help=TRUE
		call :MSG_EffectiveArgs Error
	)

	if !Effective_Args! gtr %EffArg_Required% (
		call :MSG_EffectiveArgs Warning
		echo The following arguments are ignored: !unexpected_args!
	)
)

if !Is_Help!==TRUE (
	call :MSG_Help
	goto The_Exit
)

if !Is_Test!==TRUE (
	echo.
	echo Running mode [Active/Test]: Test.
	echo DIR "!Path_to_Check:"=!"
	echo.
) else (
	echo.
	echo Running mode [Active/Test]: Active.
	DIR "!Path_to_Check:"=!"
	echo.
)

:The_Exit
endlocal
echo on
Exit /B 0

:MSG_EffectiveArgs
	echo.
	echo %~1:
	echo Effective Arguments expected: %EffArg_Required%
	echo Actual Effective Arguments received: !Effective_Args!
Exit /B 0

:MSG_Help
	echo.
	echo %BlockDivider1:"=%
	echo Name: %Name:"=% 
	for %%a in (%Head_Sections%) do (
		for %%i in (%Max_Help_Items%) do (
			if defined %%~a%%i (
				set msg=!%%~a%%i!
				if !msg! equ "." (
					echo.
				) else (
					set msg=!msg:"=!
					set msg=!msg:'="!
					if %%i==0 (
						echo %%~a: !msg!
					) else (
						echo !msg!
					)
				)
			)
		)
	)
	echo %BlockDivider1:"=%
Exit /B 0

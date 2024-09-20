#!/bin/bash
# Usage: ./replaceStrings.sh [Options] [input.txt]
# [input.txt]: text file with "[operation type]~[old string]~[new string]~[optional begin string]~[optional end string]" per line
# Replace [old string] with [new string] in all file with extension [.file_extension]
# in a directory and its sub directories

iOpt=$#
stInputFile=${!iOpt}
fileExt="\.html"
stDir="./"
stDelimiter="~"
stMsg=""

function _usage()
{
	### Usage ###
	cat <<EOF
		Usage: replaceStrings.sh [Options] [Input File]
		Search through a directory supplied (defaults to current directory) and its sub directories,
		find file with the extension supplied (defaults to .html),
		replace [old string] with [new string] listed in [Input File].
		[Input File] contains a list of "[operation type]~[old string]~[new string]" per line,
		where '~' is the default delimiter. You may specify your own delimiter by using the -l option.
		[operation type]:
			'e' single line replacing with exception,
			'm' multipleline replacing,
			'n' multipleline replacing with exception,
			'p' pass in your command,
			's' single line replacing,
			'#' skip the line.
		
		
		Options:
			-d [Search Directory], optional. Defaults to the current directory.
			-e [File Extension], such as \.html, \.py, etc. optional. defaults to '.html'.
			-l [delimiter], optional. Defaults to '~'
EOF
}

# Fetch arguments
while getopts ":d:e:l:-:" chOpt; do
	case $chOpt in
	d)
		stDir=$OPTARG
		;;
	e)
		fileExt=$OPTARG
		;;
	l)
		stDelimiter=$OPTARG
		;;
	*)
		echo "Unhandled argument -$chOpt with parameter $OPTARG" >&2
		_usage
		echo
		;;
	esac
done

# Apply changes from the input file to all files with the specified extension in the directory.
while IFS="$stDelimiter" read -r chOperation stOld stNew stBegin stEnd;do
	if [ $chOperation == "e" ]; then
		stMsg="($chOperation) Single line with exception operation:\n Replacing '$stOld' with '$stNew', except between '$stBegin' and '$stEnd'."
		sed -i "/$stBegin/,/$stEnd/!s/$stOld/$stNew/g" `tree -fi $stDir | grep $fileExt`
	elif [ $chOperation == "m" ]; then
		stMsg="($chOperation) Multi-line operation:\n Replacing \n'$stOld' \n with \n'$stNew'."
		sed -i "{N; s/$stOld/$stNew/g; P; D}" `tree -fi $stDir | grep $fileExt`
	elif [ $chOperation == "p" ]; then
		stMsg="($chOperation) Pass in command:\n '$stOld'."
		sed -i "$stOld" `tree -fi $stDir | grep $fileExt`
	elif [ $chOperation == "n" ]; then
		stMsg="($chOperation) Multi-line with exception operation:\n Replacing \n'$stOld' \n with \n'$stNew', except between '$stBegin' and '$stEnd'."
		sed -i "{N; /$stBegin/,/$stEnd/!s/$stOld/$stNew/g; P; D}" `tree -fi $stDir | grep $fileExt`
	elif [ $chOperation == "s" ]; then
		stMsg="($chOperation) Single line operation:\n Replacing '$stOld' with '$stNew'."
		sed -i "s/$stOld/$stNew/g" `tree -fi $stDir | grep $fileExt`
	else
		stMsg="($chOperation) Comment: $chOperation~$stOld~$stNew~$stBegin~$stEnd."
	fi
	echo -e "$stMsg"
	
done < "$stInputFile"

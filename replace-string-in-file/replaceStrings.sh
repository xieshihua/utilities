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
stCommand=""
bIsCommand=1
iCounter=0

function _usage()
{
	### Usage ###
	cat <<EOF
		Usage: replaceStrings.sh <[Options]> [Input File]
		Search through a directory supplied (defaults to current directory) and its sub directories,
		find file with the extension supplied (defaults to .html),
		replace [old string] with [new string] listed in [Input File].
		
		[Input File] contains a list of:
		"[operation type]~[old string]~[new string]<~[optional begin string]~[optional end string]>"
		per line,
		where '~' is the default delimiter (you may specify your own delimiter through the -l option),
		[optional begin string] and [optional end string] are used with the 'e' or 'n' operation type.
		
		[operation type]:
			'e' single line replacing with exception,
			'm' multipleline replacing,
			'n' multipleline replacing with exception,
			'p' pass in your command,
			's' single line replacing,
			'#' Comment line.
		
		Options:
			-d [Search Directory], optional. Defaults to the current directory.
			-e [File Extension], such as \.html, \.py, etc. optional. defaults to '.html'.
			-l [delimiter], optional. Defaults to '~'
		
		Example entries of an [Input File]:
		#~Comment
		#~Insert a new line 'import fme' and insert 'from myPackage ' in front of 'import myModule'.
		#~
		#~FME file format 1, string based new line, single line operation:
		s~\"import\&lt;space\&gt;myModule\&lt;~\"import\&lt;space\&gt;fme\&lt;lf\&gt;from\&lt;space\&gt;myPackage\&lt;space\&gt;import\&lt;space\&gt;myModule\&lt;
		#~FME file format 2, new line based, multiple line operation:
		m~Func():\n  import myModule~Func():\\n  import fme\n  from myPackage import myModule
		#~
		#~Insert a new line 'import fme', if it is missing.
		#~FME file format 1, string based new line, single line operation:
		e~\(\"import\)~\1\&lt;space\&gt;fme\&lt;lf\&gt;import~import~fme&lt;
		#~FME file format 2, new line based, multiple line operation:
		n~\(Func():\\n\)\([ ]*\)import~\1\2import fme\\n\2import~Func():\\n~import fme
		#~where \1 is 'Func():\\n', and \2 is [ ]* or any spaces before 'import'.
		
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
	let "iCounter += 2"
done

if [ $iOpt -eq 0 ] || [ $iCounter -eq $iOpt ]; then
	_usage
	exit 0
fi

# Apply changes from the input file to all files with the specified extension in the directory.
while IFS="$stDelimiter" read -r chOperation stOld stNew stBegin stEnd;do
	if [ $chOperation == "e" ]; then
		stMsg="($chOperation) Single line with exception operation:\n Replacing '$stOld' with '$stNew', except having '$stBegin...$stEnd'."
		stCommand="/$stBegin/,/$stEnd/!s/$stOld/$stNew/g"
	elif [ $chOperation == "m" ]; then
		stMsg="($chOperation) Multi-line operation:\n Replacing \n'$stOld' \n with \n'$stNew'."
		stCommand="{N; s/$stOld/$stNew/g; P; D}"
	elif [ $chOperation == "p" ]; then
		stMsg="($chOperation) Pass in command:\n '$stOld'."
		stCommand="$stOld"
	elif [ $chOperation == "n" ]; then
		stMsg="($chOperation) Multi-line with exception operation:\n Replacing \n'$stOld' \n with \n'$stNew', except having '$stBegin...$stEnd'."
		stCommand="{N; /$stBegin/,/$stEnd/!s/$stOld/$stNew/g; P; D}"
	elif [ $chOperation == "s" ]; then
		stMsg="($chOperation) Single line operation:\n Replacing '$stOld' with '$stNew'."
		stCommand="s/$stOld/$stNew/g"
	else
		stMsg="($chOperation) Comment: $chOperation~$stOld~$stNew~$stBegin~$stEnd."
		bIsCommand=0
	fi
	
	echo -e "$stMsg"
	if [ $bIsCommand -eq 1 ]; then
		sed -i "$stCommand" `tree -fi $stDir | grep $fileExt`
	fi
	
	bIsCommand=1
	
done < "$stInputFile"

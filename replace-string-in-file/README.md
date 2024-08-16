Usage: replaceStrings.sh [Options] [Input File]
Search through a directory supplied (defaults to current directory) and its sub directories,
find file with the extension supplied (defaults to .html),
replace oldString with newString listed in [Input File].
[Input File] contains a list of multilineIndicator~oldString~newString per line,
where '~' is the default delimiter. You may specify your own delimiter by using the -l option.
multilineIndicator:
'm' for multipleline replacing,
's' for single line replacing,
'#' skip the line.
		
		
Options:
	-d [Search Directory], optional. Defaults to the current directory.
	-e [File Extension], such as \.html, \.py, etc. optional. defaults to '.html'.
	-l [delimiter], optional. Defaults to '~'

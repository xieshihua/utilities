#!/bin/bash
# Usage: ./replaceStrings.sh [.file_extension] [input.txt]
# [.file_extension]: such as .py
# [input.txt]: text file with oldString~newString per line
# Replace oldString with newString in all file with extension [.file_extension]
# in current directory and all sub directories
while IFS='~' read -r oldString newString;do sed -i "s/$oldString/$newString/g" `tree -fi | grep "$1"`; done < "$2"
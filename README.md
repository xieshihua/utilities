# A collection of scripts to make everyday life eazier.
## chmod of a directory and its subdirectories
>chmod g-w,g+xs,o+rx \`tree -dfi --noreport jdk-11.0.22`
## Kill a process by searching string
>kill -9 \`ps aux | grep "process name" | awk '{print $2}'`
## Replace stings in all files with the same extension in a directory and subdirectories
This script reads from a text file with a list of old string and new string, and applies the replacement to all files with the specific extension in current folder and all its subfolders:
[replaceStrings.sh](https://github.com/xieshihua/utilities/blob/main/replaceStrings.sh)

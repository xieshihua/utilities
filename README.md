## A collection of scripts to make everyday life eazier.
### chmod of a directory and its subdirectories
>chmod g-w,g+xs,o+rx \`tree -dfi --noreport jdk-11.0.22`
### Gitea to GitHub Migration
Scripts for batch migrating Gitea repos to GitHub, or download Gitea repos to your local drive:
[gitea-to-github-migration](https://github.com/xieshihua/utilities/tree/main/gitea-to-github-migration)
### Kill a process by searching string
>kill -9 \`ps aux | grep "process name" | awk '{print $2}'`
### Replace stings in all files with the same extension in a directory and subdirectories
The scripts read from a text file with a list of old string and new string, and applies the replacement to all files with the specific extension in specified folder and all its subfolders:
[replace-string-in-file](https://github.com/xieshihua/utilities/tree/main/replace-string-in-file)

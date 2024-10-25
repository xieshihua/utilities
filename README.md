## A collection of scripts to make everyday life easier.
### chmod of a directory and its subdirectories
>chmod g-w,g+xs,o+rx \`tree -dfi --noreport jdk-11.0.22`
### Gitea to GitHub Migration
Scripts for batch migrating Gitea repos to GitHub, or download Gitea repos to your local drive:
[gitea-to-github-migration](gitea-to-github-migration)
### Kill a process by searching string
>kill -9 \`ps aux | grep "process name" | awk '{print $2}'`
### Net Tools
A PowerShell script to get IP Addresses based on a list of servers:
[Get_ServerIP.ps1](net-tools/Get_ServerIP.ps1)<br>
A PowerShell script to query port's accessibility based on a list of ports and servers:
[Query_Ports.ps1](net-tools/Query_Ports.ps1)
### Replace strings in all files with the same extension in a directory and subdirectories
The scripts read from a text file with a list of old string and new string (including conditional removal of blank lines or insertion of new lines of text), and applies the replacement to all files with the specific extension in specified folder and all its subfolders:
[replace-string-in-file](replace-string-in-file)

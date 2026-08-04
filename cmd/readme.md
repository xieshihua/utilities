## CMD - Windows CMD batch scripts
### `cmdTemplate.cmd` A template to process Windows CMD batch commends arguments.
<pre>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name: cmdTemplate.cmd
Purpose: A template to process Windows CMD batch commends arguments.
         * Please replace head sections with your own notes.

Usage: cmdTemplate.cmd [/?] [/t or /T] arg1 arg2 arg3 ...
       Optional: /? - Help
       Optional: /t or /T - Test run or dry run.

Example: The following command demos a test run with five auguments.

  C:\dvlp>cmdTemplate.cmd arg1 arg2 arg3 arg4 arg5 /t

Remark: - Set the EffArg_Required to the number of mandatory arguments.
        - Set Max_Help_Items to the maximun items in the head sections.

Reference: - A thorough reference to Windows CMD commands can be found at: https://ss64.com/nt/
           - https://ss64.com/ also provides references of Linux, macOS, PowerShell, ASCII, VBScript, Tools, and Passwords.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
</pre>
### `startService.cmd` Start a Windows service if it is not running.
<pre>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name: startService.cmd
Purpose: Start a Windows service if it is not running.

Usage: startService.cmd [/?] [/t or T] service_name
       Optional: /? - Help
       Optional: /t or /T - Test run or dry run.

Example: The following command shows the status of AppReadiness.
If the service is not running, it shows the command to start the service:

  C:\dvlp>startService.cmd AppReadiness /t
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
</pre>

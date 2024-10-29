# Name: Query_Ports.ps1
# Purpose: Query ports for accessibility.
# Usage: Query_Ports.ps1 -ConfigFile [configfile] -LogFile [logFile]
# Comments:
# - ConfigFile: Optional, defaults to config.json, but you may specify a different config file by -ConfigFile parameter.
#   Please update the info in the config file before running the script.
# - LogFile: Optional, defaults to the Logs folder. The Logs folder is created if it is missing.
# Content of config.json:
<#
{   
    "ports": ["1002", "1005", "1100-1113", "1521"],
    "servers": ["server_1",
        "server_2",
        "server_3"
    ]
}
#>

# Set the policy to enable PS Scripts:
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

param (
    $ConfigFile = (Get-Location).Path + "\config.json",
    $LogFile = "defaultLog.log"
)

$wkPath=(Get-Location).Path
if ($LogFile -eq "defaultLog.log") {
    $logPath="$wkPath\Logs"
    if (-not(Test-Path -Path $logPath)) {$null = New-Item -ItemType Directory -Path $logPath -Force}
    $LogFile="$logPath\Query_Ports_" + (Get-Date -Format "yyyy-MM-dd-HHmm") + ".log"
}

Start-Transcript -Path $LogFile -Append
Write-Host "**********************`n"
Write-Host "`n"

$QueryConfig=Get-Content -Path $ConfigFile | ConvertFrom-json
$ports=$QueryConfig.ports
$servers=$QueryConfig.servers

for ($i=0; $i -lt $servers.Count; $i++) {
    for ($j=0; $j -lt $ports.Count; $j++) {
        # Option 1. Use portqry.exe
        #$cmd=".\portqry.exe"
        #& $cmd -n $servers[$i] -e $ports[$j]
        # Option 2. telnet is not supported in Powershell. telnet syntax: telnet computerName port
        # Option 3. Use Test-NetConnection
        $arPorts = $ports[$j].Split("-")
        Write-Host "ports[$j]: $ports[$j]"
        Write-Host "arPorts[0]: " + $arPorts[0]
        Write-Host "arPorts[1]: " + $arPorts[1]
        for ($k=[int]$arPorts[0]; $k -lt [int]$arPorts[$arPorts.Count - 1]+1; $k++) {
            Write-Host "k: $k"
            Test-NetConnection -ComputerName $servers[$i] -Port $k
        }
    }
}

Stop-Transcript

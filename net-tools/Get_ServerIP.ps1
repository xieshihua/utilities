# Name: Get_ServerIP.ps1
# Purpose: Get the IP address for servers listed in a json file.
# Usage: Get_ServerIP.ps1 -ConfigFile [serverList]
# Comments:
# - The ConfigFile defaults to serverList.json, but you may specify a different config file by -ConfigFile parameter.
#   Please update the info in the config file before running the script.
# - It creates a Log folder if it does not exist and put a log file there.
# Content of serverList.json:
<#
{   
    "servers": ["server_1",
        "server_2",
        "server_3"
    ]
}
#>
 
# Set the policy to enable PS Scripts:
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

param (
    $ConfigFile = (Get-Location).Path + "\serverList.json"
)

$wkPath=(Get-Location).Path
$logPath="$wkPath\Logs"
if (-not(Test-Path -Path $logPath)) {$null = New-Item -ItemType Directory -Path $logPath -Force}
$logFile="$logPath\Get_ServerIP_" + (Get-Date -Format "yyyy-MM-dd-HHmm") + ".log"
Start-Transcript -Path $logFile -Append
Write-Host "**********************`n"
Write-Host "`n"

$QueryConfig=Get-Content -Path $ConfigFile | ConvertFrom-json
$servers=$QueryConfig.servers

for ($i=0; $i -lt $servers.Count; $i++) {
        Resolve-DnsName $servers[$i] | Format-Table Name, IPAddress -HideTableHeaders 
}

Stop-Transcript

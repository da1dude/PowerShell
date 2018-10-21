 #  - This script should be ran in a powershell window that is logged into the appropriate domain
 #    that the server is in. (JDNET, JDPublic and JDTal)
 #  - Script is written using WMI and PowerShell commands.
 #  - This script was created by Paul Kerschieter.



function Service_Restart_FullList
{
    Get-Service -ComputerName $serverName | Format-Table
    Write-Host "Would you like to restart a service? (y/n) (y - to restart service) (n - to start over)" -ForeGroundColor Yellow
    $yesNo = Read-Host
        If ($yesNo -eq "y") {Write-Host "Service Name:" -ForeGroundColor Yellow
                                $serviceName = Read-Host
                                Get-Service -ComputerName $serverName -Name $serviceName | Restart-Service -Force -Verbose
                                Write-Host "`nChecking the status of the service before finishing:`n" -ForeGroundColor Yellow
                                Get-Service -ComputerName $serverName -Name $serviceName | Format-Table
                                }                      
        ElseIf ($yesNo -eq "n") {Write-Host "Returning to main menue...`n" -ForeGroundColor Yellow}
        Else {'exit'}
}

function Service_Restart_Stopped
{
    Get-Service -ComputerName $serverName | Where-Object {$_.Status -ne "Running"}
    Write-Host "Would you like to restart a service? (y/n) (y - to restart service) (n - to start over)" -ForeGroundColor Yellow
    $yesNo = Read-Host
        If ($yesNo -eq "y") {Write-Host "Service Name:" -ForeGroundColor Yellow
                                $serviceName = Read-Host
                                Get-Service -ComputerName $serverName -Name $serviceName | Restart-Service -Force -Verbose
                                Write-Host "`nChecking the status of the service before finishing:`n" -ForeGroundColor Yellow
                                Get-Service -ComputerName $serverName -Name $serviceName | Format-Table
                                }                      
        ElseIf ($yesNo -eq "n") {Write-Host "Returning to main menue...`n" -ForeGroundColor Yellow}
        Else {'exit'}
}

function Service_Restart_Running
{
    Get-Service -ComputerName $serverName | Where-Object {$_.Status -eq "Running"} | Format-Table
    Write-Host "Would you like to restart a service? (y/n) (y - to restart service) (n - to start over)" -ForeGroundColor Yellow
    $yesNo = Read-Host
        If ($yesNo -eq "y") {Write-Host "Service Name:" -ForeGroundColor Yellow
                                $serviceName = Read-Host
                                Get-Service -ComputerName $serverName -Name $serviceName | Restart-Service -Force -Verbose
                                Write-Host "`nChecking the status of the service before finishing:`n" -ForeGroundColor Yellow
                                Get-Service -ComputerName $serverName -Name $serviceName | Format-Table
                                }
        ElseIf ($yesNo -eq "n") {Write-Host "Returning to main menue...`n" -ForeGroundColor Yellow}
        Else {'exit'}                              
}

function Service_Stop_FullList 
{ 
    Get-Service -ComputerName $serverName | Format-Table
    Write-Host "Would you like to stop a service? (y/n) (y - to stop service) (n - to start over)" -ForeGroundColor Yellow
    $yesNo = Read-Host
        If ($yesNo -eq "y") {Write-Host "Service Name:" -ForeGroundColor Yellow
                                $serviceName = Read-Host
                                Get-Service -ComputerName $serverName -Name $serviceName | Stop-Service -Force -Verbose
                                Write-Host "`nChecking the status of the service before finishing:`n" -ForeGroundColor Yellow
                                Get-Service -ComputerName $serverName -Name $serviceName | Format-Table
                                }                      
        ElseIf ($yesNo -eq "n") {Write-Host "Returning to main menue...`n" -ForeGroundColor Yellow}
        Else {'exit'}
}

function Service_Status
{
    Get-Service -ComputerName $serverName
    Write-Host "Check Status of which Service:" -ForeGroundColor Yellow
    $serviceName = Read-Host
    Get-Service -ComputerName $serverName -Name $serviceName | Format-Table                   
}

function Check_CPU
{
    $NumberOf = Read-Host -Prompt "Enter number of times to pull CPU Load: Recomend (3 or 5)" 
    for ($i=1; $i -le $NumberOf; $i++) {
    Get-WmiObject -ComputerName $serverName win32_processor | select DeviceID, LoadPercentage | Format-Table}
}

function High_Processes
{
    gwmi –ComputerName $serverName Win32_PerfFormattedData_PerfProc_Process | Where PercentProcessorTime -gt 0 | Where Name -ne '_Total' | Where Name -ne 'Idle' | Sort PercentProcessorTime -desc | Select Name, PercentProcessorTime | Format-Table -AutoSize
}

function Disk_Space
{
    gwmi –ComputerName $serverName win32_logicaldisk | Where DeviceID -ne 'A:' | Where DeviceID -ne 'D:' | Format-Table -AutoSize DeviceID,
    @{Name="Size (GB)"; Expression={[math]::round($_.Size/1GB, 2)}},
    @{Name="FreeSpace (GB)"; Expression={[math]::round($_.FreeSpace/1GB, 2)}},
    @{Name="%Free (GB)"; Expression={[math]::round($_.FreeSpace/$_.Size*100, 2)}}
}

function OptionsMenu
{
    Write-Host "This script can be used to manage and review serveral aspects of the Windows Operating system.`n

        Use the following Options:`n
        1 - SET SERVER - Only needs to be set once
        2 - Show All Services - Optional Restart
        3 - Show All Stopped Services - Optional Restart
        4 - Show All Running Services - Optional Restart
        5 - Stop Service
        6 - Check a Service Status
        7 - Check CPU Usage
        8 - Check High Running Processes
        9 - Check Disk Space
        0 - Quit`n" -ForeGroundColor Yellow
    Write-Host "`nChoice" -ForeGroundColor Yellow
    $Script:choice = Read-Host
}

function OptionsMenu_serverName
{
    Write-Host "ServerName" -ForeGroundColor Yellow
    $Script:serverName = Read-Host
    Write-Host "Server Name has been set!`n" -ForeGroundColor Yellow
}

function Quit
{
    Write-Host "Quiting...!" -ForeGroundColor Yellow
    {'exit'}
}

function ServiceMenu
{ 
    Write-Host "This script can be used to manage and review serveral aspects of the Windows Operating system.`n

        Use the following Options:`n
        1 - Show All Services - Optional Restart
        2 - Show All Stopped Services - Optional Restart
        3 - Show All Running Services - Optional Restart
        4 - Stop Service
        5 - Check a Service Status`n" -ForeGroundColor Yellow
    Write-Host "`nChoice" -ForeGroundColor Yellow
    $Script:choice2 = Read-Host
} 





#############################################################################################
########################### Main body below is executed! ####################################
#############################################################################################

Do 
{

OptionsMenu


    If ($choice -eq '1')     {
                              OptionsMenu_serverName
                              }     
    ElseIf ($choice -eq '2') {
                              Service_Restart_FullList
                              }
    ElseIf ($choice -eq '3') {
                              Service_Restart_Stopped
                              }
    ElseIf ($choice -eq '4') {
                              Service_Restart_Running
                              }
    ElseIf ($choice -eq '5') {
                              Service_Stop_FullList
                              }
    ElseIf ($choice -eq '6') {
                              Service_Status                
                              }                   
    ElseIf ($choice -eq '3') {
                              Check_CPU
                              }
    ElseIf ($choice -eq '4') {
                              High_Processes
                              }                          
    ElseIf ($choice -eq '5') {
                              Disk_Space
                              }
    ElseIf ($choice -eq '0') {
                              Quit
                              }
    Else{'exit'}

} until ($choice -eq '0')
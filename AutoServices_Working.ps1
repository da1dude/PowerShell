
Write-Host "This script can be used to manage and review serveral aspects of the Windows Operating system.`n
            - This script should be ran in a powershell window that is logged into the appropriate domain
              that the server is in. (JDNET, JDPublic and JDTal)
            - Script is written using WMI and PowerShell commands.
            - This script was created by Paul Kerschieter." -ForeGroundColor Yellow


Write-Host "ServerName" -ForeGroundColor Yellow
$serverName = Read-Host


Write-Host "`nUse the following Options:`n
            1 - Show All Services
            2 - Check Service Status
            3 - Start Service
            4 - Stop Service
            5 - Restart Service
            6 - Check CPU Usage
            7 - Check High Running Processess
            8 - Check Disk Space" -ForeGroundColor Yellow
Write-Host "`nChoice" -ForeGroundColor Yellow
$choice = Read-Host 
    If     ($choice -eq '1') {Get-Service -ComputerName $serverName
                              }
    ElseIf ($choice -eq '2') {Write-Host "Service Name" -ForeGroundColor Yellow
                              $serviceName = Read-Host
                              Get-Service -ComputerName $serverName -Name $serviceName | Format-Table
                              }
    ElseIf ($choice -eq '3') {Write-Host "Service Name" -ForeGroundColor Yellow
                              $serviceName = Read-Host
                              Get-Service -ComputerName $serverName -Name $serviceName | Start-Service -Verbose
                              Write-Host "`nChecking the status of the service before finishing:`n"
                              Get-Service -ComputerName $serverName -Name $serviceName | Format-Table  
                              }
    ElseIf ($choice -eq '4') {Write-Host "Service Name" -ForeGroundColor Yellow
                              $serviceName = Read-Host
                              Get-Service -ComputerName $serverName -Name $serviceName | Stop-Service -Force -Verbose
                              Write-Host "`nChecking the status of the service before finishing:`n"
                              Get-Service -ComputerName $serverName -Name $serviceName | Format-Table
                              }
    ElseIf ($choice -eq '5') {Write-Host "Service Name" -ForeGroundColor Yellow
                              $serviceName = Read-Host 
                              Get-Service -ComputerName $serverName -Name $serviceName | Restart-Service -Force -Verbose
                              Write-Host "`nChecking the status of the service before finishing:`n"
                              Get-Service -ComputerName $serverName -Name $serviceName | Format-Table
                              }                                                     
    ElseIf ($choice -eq '6') {$NumberOf = Read-Host -Prompt "Enter number of times to pull CPU Load: Recomend (3 or 5)" 
                             for ($i=1; $i -le $NumberOf; $i++) {
                                Get-WmiObject -ComputerName $serverName win32_processor | select DeviceID, LoadPercentage
                              }}                                                  
    ElseIf ($choice -eq '7') {gwmi –ComputerName $serverName Win32_PerfFormattedData_PerfProc_Process | Where PercentProcessorTime -gt 0 | Where Name -ne '_Total' | Where Name -ne 'Idle' | Sort PercentProcessorTime -desc | Select Name, PercentProcessorTime | Format-Table -AutoSize}

    ElseIf ($choice -eq '8') {gwmi –ComputerName $serverName win32_logicaldisk | Where DeviceID -ne 'A:' | Where DeviceID -ne 'D:' | Format-Table -AutoSize DeviceID,
                                 @{Name="Size (GB)"; Expression={[math]::round($_.Size/1GB, 2)}},
                                 @{Name="FreeSpace (GB)"; Expression={[math]::round($_.FreeSpace/1GB, 2)}},
                                 @{Name="%Free"; Expression={[math]::round($_.FreeSpace/$_.Size*100, 2)}} 
                              }
    
    Else {'exit'}

Write-Host "`nWould you like to start the script again (y/n)?" -ForeGroundColor Yellow
$yesNo = Read-Host
    If ($yesNo -eq "y") {C:\AutoServices_Working.ps1}
    ElseIf ($yesNo -eq "n") {'exit'}
    Else {'exit'}


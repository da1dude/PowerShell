

$ScriptBlock = {  

    $CPUPercent = @{
      Label = 'CPUUsed'
      Expression = {
        $SecsUsed = (New-Timespan -Start $_.StartTime).TotalSeconds
        [Math]::Round($_.CPU * 10 / $SecsUsed)
      }
    }  

    Get-Process | 
      Select-Object -Property Name, CPU, $CPUPercent, Description | 
      Sort-Object -Property CPUUsed -Descending | 
      Select-Object -First 15  
}

Enter-PSSession -ComputerName localhost $ScriptBlock

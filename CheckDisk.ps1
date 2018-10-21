gwmi –ComputerName fdxx90app299 win32_logicaldisk | Format-Table -AutoSize DeviceID,
    @{Name="FreeSpace"; Expression={[math]::round($_.FreeSpace/1GB, 2)}},
    @{Name="Size"; Expression={[math]::round($_.Size/1GB, 2)}},
    @{Name="%Free"; Expression={[math]::round($_.FreeSpace/$_.Size*100, 2)}}





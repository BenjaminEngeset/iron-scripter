$Measurement = Get-ChildItem -Path 'C:\Temp' -Recurse -File | Measure-Object -Property Length -Sum -Average
[PSCustomObject]@{
    Name         = Value
    Count        = $Measurement.Count
    Average      = $Measurement.Average
    Sum          = $Measurement.Sum
    Date         = Get-Date
    ComputerName = $env:Computername 
}
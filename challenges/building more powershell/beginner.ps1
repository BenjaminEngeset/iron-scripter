function BeginnerGetFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )
    $Measurement = gci -Path $Path -File -Force -Recurse | Measure-Object -Property Length -Sum -Average
    [PSCustomObject]@{
        Count    = $Measurement.Count
        Average  = $Measurement.Average
        Sum      = ($Measurement.Sum)/1KB
        Date     = Get-Date
        Computer = $env:Computername     
    }
}

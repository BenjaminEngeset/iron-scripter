function BeginnerGetFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )
    $Measurement = Get-ChildItem -Path $Path -File -Recurse -ErrorAction Stop | Measure-Object -Property Length -Sum -Average
    [PSCustomObject]@{
        Count    = $Measurement.Count
        Average  = $Measurement.Average
        Sum      = $Measurement.Sum
        Date     = Get-Date
        Computer = $env:Computername     
    }
}

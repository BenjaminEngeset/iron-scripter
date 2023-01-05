<#
.SYNOPSIS
    Gets the files from path specified.
.DESCRIPTION
    Gets the files from the path specified including subfolders and displays a result that show the total number of files,
    the total size of all files, the average file size, the computer name, the date the command was ran and the path that was specified.

.PARAMETER Path
    The path to specify such as 'C:\Temp'.
#>
function BeginnerGetFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path -PathType Container -Path $_
                [IO.Path]::Exists((Convert-Path -LiteralPath $_)) } )]
        [string]$Path
    )
    process {
        try {
            $Measurement = gci -Path $Path -File -Force -Recurse | Measure-Object -Property Length -Sum -Average
            $MeasurementHidden = gci -Path $Path -File -Attributes h -Recurse | Measure-Object -Property Length -Sum -Average
            [PSCustomObject]@{
                Count         = $Measurement.Count
                Average       = [Math]::Round(($Measurement.Average), 2)
                Sum           = ($Measurement.Sum) / 1KB
                CountHidden   = $MeasurementHidden.Count
                AverageHidden = [Math]::Round(($MeasurementHidden.Average), 2)
                SumHidden     = ($Measurement.Sum) / 1KB
                Date          = Get-Date
                Computer      = $env:Computername
                Path          = $Path
            }
        }
        catch {
            Write-Error $_
        }
    }
}
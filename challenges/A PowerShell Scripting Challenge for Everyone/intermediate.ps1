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
        [ValidateScript( { Test-Path -PathType Container $_ } )]
        [string]$Path
    )
    process {
        try {
            $Measurement = Get-ChildItem -Path $Path -File -Recurse -ErrorAction Stop | Measure-Object -Property Length -Sum -Average
            [PSCustomObject]@{
                Count    = $Measurement.Count
                Average  = $Measurement.Average
                Sum      = $Measurement.Sum
                Date     = Get-Date
                Computer = $env:Computername
                Path     = $Path
            }
        }
        catch {
            Write-Error $_
        }
    }
}

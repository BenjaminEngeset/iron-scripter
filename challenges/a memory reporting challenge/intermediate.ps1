Get-CimInstance -ClassName Win32_Process -Filter "Name like 'Spotify'"

function Get-ProcessMemory {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Position = 0)]
        [Alias('cn')]
        [string]$ComputerName
    )
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing on $ComputerName"
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -Property TotalVisibleMemorySize, FreePhysicalMemory -ComputerName $ComputerName
        $inUseMemory = ($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) * 1KB
        $grouped = Get-CimInstance -ClassName Win32_Process -ComputerName $computername -Filter "Name<>'systemidleprocess'" | 
        Group-Object -Property Name

        $results = ForEach ($item in $grouped) {
            $stat = $item.Group | Measure-Object -Property WorkingSetSize -Sum
            [PSCustomObject]@{
                PSTypeName    = 'ProcessWSPercent'
                Name          = $item.Name 
                Count         = $item.Count
                TotalWS       = $stat.Sum
                PctUSedMemory = [math]::Round(($stat.Sum / $inUseMemory) * 100, 2)
            }
        }

        $results | Sort-Object -Property PctUsedMemory -Descending |
        Select-Object -First 10
    }
    
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END] Ending $($MyInvocation.MyCommand)"
    }
}
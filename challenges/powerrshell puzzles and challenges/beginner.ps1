# Task 1
# How many stopped services are on your computer?
function Get-StoppedService {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Position = 0)]
        [Alias('cn')]
        [string]$ComputerName = $env:COMPUTERNAME
    )
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($Myinvocation.MyCommand)"
    }
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing services on $ComputerName"
        $servicestopped = (Get-CimInstance -ClassName Win32_Service -Filter "State like 'Stopped'" -Property State -ComputerName $ComputerName |
            Measure-Object).Count
        [PSCustomObject]@{
            ServicesStopped = $servicestopped
        }
    }
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END] Ending $($Myinvocation.MyCommand)"
    }
}

# Task 2 
# List services set to autostart but are NOT running?
Get-CimInstance -ClassName Win32_Service -Filter "StartMode = 'Auto' and State <> 'Running'" |
Select-Object -Property Name, StartMode, State, ProcessId

# Task 3
# List ONLY the property names of the Win32_BIOS WMI class.
Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty CimInstanceProperties | Select-Object -Property Name

# Task 4
# List all loaded functions displaying the name, number of parameters sets, and total number of lines in the function.
# Option 1
Get-Command -CommandType Function -ListImported | Select-Object -Property Name, @{ n = 'ParameterSetCount'; e = { $_.ParameterSets.Count } },
@{ n = 'Lines'; e = { ($_.ScriptBlock | Measure-Object -Line).Lines } }

# Option 2
Get-Command -CommandType Function -ListImported | Sort-Object Source, Name |
Format-Table -GroupBy Source -Property Name,
@{ n = 'ParameterSetCount'; e = { $_.ParameterSetCount.Count } },
@{ n = 'Lines'; e = { ($_.ScriptBlock | Measure-Object -Line).Lines } }

# Option 3 
$functions = Get-Command -CommandType Function -ListImported | Where-Object CommandType -EQ 'Function'
$results = foreach ($function in $functions) {
    [PSCustomObject]@{
        PSTypeName        = 'PSFunctionInfo'
        Name              = $function.Name
        ParameterSetCount = $function.ParameterSets.Count
        Lines             = ($function.ScriptBlock | Measure-Object -Line).Lines
        Source            = $function.Source
    }
}

$results | Sort-Object -Property Lines, Name -Descending | Select-Object -First 5

$results | Where-Object Name -NotMatch '^[A-Z]:' |
Sort-Object Source, Name |
Format-Table -GroupBy Source -Property Name, ParameterSetCount, Lines
# Also created custom formatting for the type.

# Task 5 
# Create a formatted report of Processes grouped by UserName. Skip processes with no user name.
# Option 1
Get-Process -IncludeUserName | Where-Object { $_.UserName } |
Sort-Object -Property UserName, ProcessName |
Format-Table -GroupBy UserName -Property Handles, WS, CPU, ID, ProcessName

# Option 2
Get-CimInstance -ClassName Win32_Process | Select-Object -First 10 |
Add-Member -MemberType Scriptproperty -Name Owner -Value {
    $user = Invoke-CimMethod -InputObject $this -MethodName GetOwner
    if ($user.returnValue -eq 0) {
        "$($user.Domain)\$($user.User)"
    }
} -PassThru -Force -OutVariable a | Where-Object Owner |
Sort-Object -Property Owner, Name |
Format-Table -GroupBy Owner -Property ProcessID, Name, HandleCount, WorkingSetSize, VirtualSize

# Task 6
# Using your previous code, display the username, the number of processes, the total workingset size. Set no username to NONE.
$grouped = Get-Process -IncludeUserName | Group-Object -Property UserName

foreach ($item in $grouped) {
    if ($item.Name) {
        $Name = $item.Name
    }
    else {
        $Name = 'NONE'
    }
    [PSCustomObject]@{
        Computername = [System.Environment]::MachineName
        Username     = $Name
        Count        = $item.Count
        TotalWS      = [math]::Round(($item.Group | Measure-Object -Property WS -Sum).Sum / 1MB, 2)
    }
}

# Task 7
# Create a report that shows files in %TEMP% by extension. Include Count,total size, % of total directory size.
$files = Get-ChildItem $env:Temp -File -Recurse
$totalSize = ($files | Measure-Object -Property Length -Sum).Sum
$grouped = $files | Group-Object -Property Extension

$results = foreach ($item in $grouped) {
    $size = $item.Group | Measure-Object -Property Length -Sum
    $pctSize = ($size.Sum / $totalSize) * 100
    [PSCustomObject]@{
        Extension = $item.Name
        Count     = $item.Count
        Size      = $size.Sum
        PctTotal  = [math]::Round($pctSize, 4)
    }
}
$results | Sort-Object -Property PctTotal -Descending

# Task 8
# Find the total % of WS memory a process is using. Show top 10 processes,count,total workingset and PctUsedMemory.
# Get the in use memory value.
$computername = $env:Computername
$os = Get-CimInstance -ClassName Win32_OperatingSystem -Property TotalVisibleMemorySize, FreePhysicalMemory -ComputerName $computername
$inUseMemory = ($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) * 1KB

Get-CimInstance -ClassName Win32_Process -Filter "Name <> 'System Idle Process'" -ComputerName $computername | 
Group-Object -Property Name |
ForEach-Object {
    $stat = $_.Group | Measure-Object -Property WorkingSetSize -Sum
    $_ | Select-Object -Property Name, Count, @{ Name = 'TotalWS'; Expression = { $stat.Sum } },
    @{ Name = 'PctUsedMemory'; Expression = { [math]::Round(($stat.Sum / $inUseMemory) * 100, 2) } }
} | Sort-Object PctUsedMemory -Descending | Select-Object -First 10
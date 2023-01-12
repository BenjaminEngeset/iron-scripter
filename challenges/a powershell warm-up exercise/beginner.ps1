# Task:
# Write PowerShell code to take a string like ‘PowerShell’ and display it in reverse. Your solution can be a simple script or function.

# Solution 1
function ConvertTo-ReverseString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string]$String
    )
    
    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        $charArray = $String.ToCharArray()
        [array]::Reverse($charArray)
        -join $charArray | ForEach-Object {
            [PSCustomObject]@{
                PSTypeName     = 'ReversedString'
                OrginialString = $String
                ReversedString = $_
            }
        }
    }
    end {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}

# Solution 2
function ConvertTo-ReverseString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string]$String
    )
    
    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        $reversedString = $String[-1..-($String.Length)] -join ''
        [PSCustomObject]@{
            PSTypeName     = 'ReversedString'
            OrginialString = $String
            ReversedString = $reversedString
        }
    }
    end {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}
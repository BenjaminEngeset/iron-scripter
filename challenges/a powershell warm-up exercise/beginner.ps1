# Task:
# Write PowerShell code to take a string like ‘PowerShell’ and display it in reverse. Your solution can be a simple script or function.

# Solution 1
function ConvertTo-ReverseWord {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline, 
            Position = 0,
            HelpMessage = 'Enter a word.'
        )]
        [string]$Word
    )
    
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $Word"
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Word length is $($Word.Length)"
        $charArray = $Word.ToCharArray()
        [array]::Reverse($charArray)
        $reversedWord = -join $charArray
        [PSCustomObject]@{
            PSTypeName   = 'ReversedWord'
            OrginialWord = $Word
            ReversedWord = $reversedWord
        }
    }
    end {
        Write-Verbose "[$((Get-Date).TimeofDay) END] Ending $($myinvocation.MyCommand)"
    }
}

# Solution 2
function ConvertTo-ReverseWord {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline, 
            Position = 0,
            HelpMessage = 'Enter a word.'
        )]
        [string]$Word
    )
    
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $Word"
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Word length is $($Word.Length)"
        $reversedWord = ($Word[-1.. - ($Word.Length)]) -join ''
        [PSCustomObject]@{
            PSTypeName   = 'ReversedWord'
            OrginialWord = $Word
            ReversedWord = $reversedWord
        }
    }
    end {
        Write-Verbose "[$((Get-Date).TimeofDay) END] Ending $($myinvocation.MyCommand)"
    }
}

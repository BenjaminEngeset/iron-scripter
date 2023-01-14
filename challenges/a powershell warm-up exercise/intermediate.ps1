# Task:
# Take a sentence like, “This is how you can improve your PowerShell skills,”
# and write PowerShell code to display the entire sentence in reverse with each word reversed. 
# You should be able to encode and decode text. Ideally, your functions should take pipeline input.

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
        ($Word[-1.. - ($Word.Length)]) -join ''
    
    }
    end {
        Write-Verbose "[$((Get-Date).TimeofDay) END] Ending $($myinvocation.MyCommand)"
    }
}

function ConvertTo-ReverseSentence {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            Position = 0,
            HelpMessage = 'Enter a sentence.'
        )]
        [string]$Sentence
    )
    
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $Sentence"
        $words = $Sentence.Split() | ConvertTo-ReverseWord
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Reversed $($words.Count) words"
        ($words[-1.. - $($words.Count)]) -join ' '
    }
    
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END] Ending $($myinvocation.MyCommand)" 
    }
}
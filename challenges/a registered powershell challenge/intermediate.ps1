function Get-RegisteredUser {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline)]
        [Alias('cn')]
        [string[]]$Computername = $env:Computername,
        [pscredential]$Credential,
        [Int32]$ThrottleLimit,
        [switch]$UseSSL
    )
    
    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $scriptblock = {
            $path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
            $registry = Get-ItemProperty -Path $path

            [PSCustomObject]@{
                PSTypeName             = 'PSRegisteredUser'
                RegisteredUser         = $registry.RegisteredOwner
                RegisteredOrganization = $registry.RegisteredOrganization
                Computername           = $env:Computername
            }
        }

        $PSBoundParameters.Add('Scriptblock', $scriptblock)
        $PSBoundParameters.Add('HideComputername', $True)
    }
    
    process {
        if (!$PSBoundParameters.ContainsKey('Computername')) {
            Write-Verbose 'Querying localhost'
            $PSBoundParameters.Computername = $Computername
        }
        Invoke-Command @PSBoundParameters | ForEach-Object {
            [PSCustomObject]@{
                PSTypeName   = 'psRegisteredUser'
                Computername = $_.Computername
                User         = $_.RegisteredUser
                Organization = $_.RegisteredOrganization
                Date         = (Get-Date)
            }
        }
    }
    end {
       Write-Verbose "Endting $($MyInvocation.MyCommand)" 
    }
}
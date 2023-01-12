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
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}

function Set-RegisteredUser {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter()]
        [Alias('user')]
        [ValidateNotNullOrEmpty()]
        [string]$RegisteredUser,

        [Parameter()]
        [alias('org')]
        [ValidateNotNullOrEmpty()]
        [string]$RegisteredOrganization, 

        [Parameter(ValueFromPipeline)]
        [Alias('cn')]
        [string[]]$Computername = $env:Computername, 

        [pscredential]$Credential, 

        [switch]$Passthru
    )
    
    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

        $scriptblock = {
            [CmdletBinding()]
            param (
                [string]$RegisteredUser,
                [string]$RegisteredOrganization,
                [bool]$Passthru    
            )

            $VerbosePreference = $using:verbosepreference
            $WhatIfPreference = $using:WhatifPreference

            $path = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
            Write-Verbose "[$($env:COMPUTERNAME)] Using registry path $path"
            $set = $False

            if ($RegisteredUser) {
                Write-Verbose "[$($env:COMPUTERNAME)] Setting Registered Owner to $RegisteredUser"
                if ($pscmdlet.ShouldProcess($env:COMPUTERNAME, "Set registered user to $RegisteredUser")) {
                    Set-ItemProperty -Path $path -Name 'RegisteredOwner' -Value $RegisteredUser
                    $set = $True
                }
            }

            if ($RegisteredOrganization) {
                Write-Verbose "[$($env:COMPUTERNAME)] Setting Registered Organization to $RegisteredOrganization"
                if ($pscmdlet.ShouldProcess($env:COMPUTERNAME, "Set registered organization to $RegisteredOrganization")) {
                    Set-ItemProperty -Path $path -Name 'RegisteredOrganization' -Value $RegisteredOrganization
                    $set = $True
                }
            }

            if ($set -AND $passthru) {
                $registry = Get-ItemProperty $path
                [pscustomobject]@{
                    PSTypeName   = 'PSRegisteredUser'
                    Computername = $env:COMPUTERNAME
                    User         = $registry.RegisteredOwner
                    Organization = $registry.RegisteredOrganization
                    Date         = Get-Date
                }
            }
        }

        $icmParams = @{
            Scriptblock      = $scriptblock
            ArgumentList     = @($RegisteredUser, $RegisteredOrganization, ($Passthru -as [bool]))
            HideComputername = $True
        }
        if ($Credential) {
            Write-Verbose "Using credential for $($credential.username)"
            $icmParams.Add('Credential', $credential)
        }

    } 
    
    process {
        $icmParams.Computername = $Computername
        Invoke-Command @icmParams | ForEach-Object { 
            [PSCustomObject]@{
                PSTypeName   = 'psRegisteredUser'
                Computername = $_.Computername
                User         = $_.User
                Organization = $_.Organization
                Date         = $_.Date
            } 
        }
    }
    
    end {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}

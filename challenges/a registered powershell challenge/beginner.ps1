function Get-RegisteredUser {
    [CmdletBinding()]
    param ()
    $path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $registry = Get-ItemProperty -Path $path

    [PSCustomObject]@{
        RegisteredUser         = $registry.RegisteredOwner
        RegisteredOrganization = $registry.RegisteredOrganization
        Computername           = $env:Computername
    }
}

function Set-RegisteredUser {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter()]
        [Alias('User')]
        [ValidateNotNullOrEmpty()]
        [string]$RegisteredUser,

        [Parameter()]
        [Alias('Org')]
        [ValidateNotNullOrEmpty()]
        [string]$RegisteredOrganization,

        [switch]$Passthru
    )
    
    $path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    
    $set = $False

    if ($RegisteredUser) {
        Write-Verbose "Setting Registered Owner to $RegisteredUser"
        Set-ItemProperty -Path $path -Name 'RegisteredOwner' -Value $RegisteredUser
        $set = $True
    }

    if ($RegisteredOrganization) {
        Write-Verbose "Setting Registered Organization to $RegisteredOrganization"
        Set-ItemProperty -Path $path -Name 'RegisteredOrganization' -Value $RegisteredOrganization
        $set = $True
    }

    if ($set -and $Passthru) {
        $registry = Get-ItemProperty $path
        [PSCustomObject]@{
            RegisteredUser         = $registry.RegisteredOwner
            RegisteredOrganization = $registry.registeredOrganization
            Computername           = $env:Computername
        }
    }
}

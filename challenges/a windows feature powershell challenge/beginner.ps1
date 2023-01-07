function Set-WindowsOptionalFeature {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$FeatureName,
        
        [Parameter(Mandatory)]
        [ValidateSet('Enable', 'Disable')]
        [string]$Status
    )   
    process {
        if ((Get-WindowsOptionalFeature -FeatureName $FeatureName -Online).State -match "^$($Status)") {
            return "The feature is already $($Status)d."
        }
        if ($Status -eq 'Enable') {
            Enable-WindowsOptionalFeature -FeatureName $FeatureName -Online
        }
        elseif ($Status -eq 'Disable') {
            Disable-WindowsOptionalFeature -FeatureName $FeatureName -Online
        }
    }
}
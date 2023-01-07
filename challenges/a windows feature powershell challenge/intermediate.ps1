function Set-WindowsOptionalFeature {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [string[]]$FeatureName,
        
    
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1)]
        [ValidateSet('Enable', 'Disable')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName, Position = 2)]
        [ValidateSet('Errors', 'Warnings', 'WarningsInfo')]
        [string]$Loglevel
    )   
    process {
        try {
            foreach ($f in $FeatureName) {
                if ((Get-WindowsOptionalFeature -FeatureName $f -Online).State -match "^$($Status)") {
                    Write-Warning "The feature `($($f)`) is already $($Status)d."
                }
                else {
                    if ($Status -eq 'Enable') {
                        Enable-WindowsOptionalFeature -FeatureName $f -Online -All -LogLevel $Loglevel
                    }
                    else {
                        Disable-WindowsOptionalFeature -FeatureName $f -Online -LogLevel $Loglevel
                    }
                }
            }
        }
        catch {
            Write-Error $_
        }
    }
}

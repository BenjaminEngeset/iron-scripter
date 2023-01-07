function Set-WindowsOptionalFeature {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [string[]]$FeatureName,
        
    
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1)]
        [ValidateSet('Enable', 'Disable')]
        [string]$Status,

        [Parameter(ValueFromPipelineByPropertyName, Position = 2)]
        [ValidateSet('Errors', 'Warnings', 'WarningsInfo')]
        [string]$LogLevel

    )   
    process {
        try {
            $featuresToModify = $FeatureName | Where-Object {
                (Get-WindowsOptionalFeature -FeatureName $_ -Online).State -notmatch "^$Status"
            }
            $logLevelParam = @{}
            if ($LogLevel) {
                $logLevelParam['LogLevel'] = $LogLevel
            }
            if ($PSCmdlet.ShouldProcess($featuresToModify, $Status)) {
                if ($featuresToModify -and $Status -eq 'Enable') {
                    Enable-WindowsOptionalFeature -FeatureName $featuresToModify -All -Online @logLevelParam
                }
                elseif ($featuresToModify -and $Status) {
                    Disable-WindowsOptionalFeature -FeatureName $featuresToModify -Online @logLevelParam
                }
            }
        }
        catch {
            Write-Error $_
        }
    }
}
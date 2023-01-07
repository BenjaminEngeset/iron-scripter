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
        [string]$LogLevel

    )   
    process {
        try {
            $featuresToModify = foreach ($f in $FeatureName) {
                if ((Get-WindowsOptionalFeature -FeatureName $f -Online).State -match "^$Status") {
                    Write-Verbose "The feature ($f) is already ${Status}d."
                }
                else {
                    $f
                }
            }
            $logLevelParam = @{}
            if ($LogLevel) {
                $logLevelParam['LogLevel'] = $LogLevel
            }
            if ($featuresToModify -and $Status -eq 'Enable') {
                Enable-WindowsOptionalFeature -FeatureName $featuresToModify -All -Online @logLevelParam
            }
            elseif ($featuresToModify -and $Status) {
                Disable-WindowsOptionalFeature -FeatureName $featuresToModify -Online @logLevelParam
            }
        }
        catch {
            Write-Error $_
        }
    }
}
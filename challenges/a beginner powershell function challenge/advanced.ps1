function ConvertTo-Celsius {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [decimal[]]$Fahrenheit,

        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [ValidateRange(0, 10)]
        [int]$Precision = 1 
    )
    process {
        try {
            foreach ($temperature in $Fahrenheit) {
                if ($temperature -ge -459.67) {
                    [PSCustomObject]@{
                        Farenheit = $temperature
                        Celsius   = [math]::Round(($temperature - 32) / 1.8, $Precision)
                    }
                }
                else {
                    '{0} {1}F is below absolute zero. Please try again.' -f $temperature, [char]176 | Write-Warning
                }
            }
        }
        catch {
            Write-Error $_
        }
    }
}

function ConvertTo-Fahrenheit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [decimal[]]$Celsius,

        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [ValidateRange(0, 10)]
        [int]$Precision = 1
    )
    process {
        try {
            
            foreach ($temperature in $Celsius) {
                if ($temperature -ge -273.15) {
                    [PSCustomObject]@{
                        Celsius   = $temperature
                        Farenheit = [math]::Round(($temperature * 1.8) + 32, $Precision)
                    }
                }
                else {
                    '{0} {1}C is below absolute zero. Please try again.' -f $temperature, [char]176 | Write-Warning
                }
            }
        }
        catch {
            Write-Error $_
        }
    }
}
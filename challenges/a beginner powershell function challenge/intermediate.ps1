function ConvertTo-Celsius {
    param ($Fahrenheit)
    process {
        [PSCustomObject]@{
            Farenheit = $Fahrenheit
            Celsius   = ($Fahrenheit - 32) / 1.8
        }
    }
}

function ConvertTo-Fahrenheit {
    param ($Celsius)
    process {
        [PSCustomObject]@{
            Celsius   = $Celsius
            Farenheit = ($Celsius * 1.8) + 32
        }
    }
}
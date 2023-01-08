function ConvertTo-Celsius {
    param ($Fahrenheit)
    ($Fahrenheit - 32) / 1.8
}

function ConvertTo-Fahrenheit {
    param ($Celsius)
    ($Celsius * 1.8) + 32 
}
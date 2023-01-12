# Possible solution 1
$string = 'PowerShell'

$arrayCharacters = $string.ToCharArray()

[array]::Reverse($arrayCharacters)

$reversedString1 = $arraycharacters -join ''


# Possible solution 2
$string = 'PowerShell'

$reversedString2[-1..-($string.length)] -join ''
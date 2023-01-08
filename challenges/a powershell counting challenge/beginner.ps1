1..100 | Where-Object { -not ($_%2) } | Measure-Object -Sum

$even = 0
foreach ($n in (1..100)) {
    if ($n/2 -is [int]) {
        $even += $n
    }
}
$even

$even = 0
for ($i = 2; $i -le 100; $i+=2) {
    $even += $i
}
$even
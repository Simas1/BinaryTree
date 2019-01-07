$arr_tree = @(
@(215),
@(192,124),
@(117,269,442),
@(218,836,347,235),
@(320,805,522,417,345),
@(229,601,728,835,133,124),
@(248,202,277,433,207,263,257),
@(359,464,504,528,516,716,871,182),
@(461,441,426,656,863,560,380,171,923),
@(381,348,573,533,448,632,387,176,975,449),
@(223,711,445,645,245,543,931,532,937,541,444),
@(330,131,333,928,376,733,017,778,839,168,197,197),
@(131,171,522,137,217,224,291,413,528,520,227,229,928),
@(223,626,034,683,839,052,627,310,713,999,629,817,410,121),
@(924,622,911,233,325,139,721,218,253,223,107,233,230,124,233)
)

function Even-Odd ($Number) {
    $result = $Number % 2
    if ($result -eq 0) {
        return 'even'
    } else {
        return 'odd'
    } 
}

function Toggle-EvenOdd ($Value) {
    if ($Value -eq 'even') {
        return 'odd'
    } else {
        return 'even'
    }
}

function Get-Numbers ($Col = 0,$Row = 0, $Toggle = @('even', 'odd'), $Sequence = @()) {
    $row_max = $arr_tree.Count-1
    $count = 0
    foreach ($item in $arr_tree[$Row][$Col..($Col+1)]) {
        $polarity = Even-Odd -Number $item
        if ($Toggle -contains $polarity) {
            #Write-Host "$(' '*$Col)$item  - Row:$($Row) Col:$($Col+$count) - $polarity -Seq:$($Sequence -join ';')"
            $obj = '' | Select-Object Number,Row,Col
            $obj.Number = $item
            $obj.Row = $Row
            $obj.Col = $Col+$count

            if ($row_max -eq $Row) {
                $validCombinations.Add($Sequence + $obj)
            }
            if ($row_max -ge ($Row+1)) {
                Get-Numbers -Col ($Col+$count) -Row ($Row+1) -Toggle ([array](Toggle-EvenOdd -Value $polarity)) -Sequence ($Sequence + $obj)
            }
        }
        $count++
    }
}

function Print-Tree ($Combination) {
    for ($r=0; $r -le $arr_tree.Count-1; $r++) {
        for ($c=0; $c -le $arr_tree[$r].Count-1; $c++) {
            if ($Combination.Col[$r] -eq $c) {
                Write-Host "$($arr_tree[$r][$c]) " -ForegroundColor Red -NoNewline
            } else {
                Write-Host "$($arr_tree[$r][$c]) " -ForegroundColor White -NoNewline
            }
        }
        Write-Host ''
    }
}

$validCombinations = New-Object System.Collections.Generic.List[System.Object]
Get-Numbers
Write-Host "Found valid path(s): " -ForegroundColor Gray -NoNewline
Write-Host $validCombinations.Count -ForegroundColor Green

$calculate = foreach ($combination in $validCombinations) {
    $obj = '' | Select-Object Number,Row,Col,MaxSum
    $obj.Number = $combination.Number
    $obj.Row = $combination.Row
    $obj.Col = $combination.Col

    $sum = $obj.Number -join '+'
    $ret = Invoke-Expression $sum
    $obj.MaxSum = $ret
    $obj
}
$max = ($calculate | Group-Object MaxSum | Sort-Object Name -Descending | Select-Object -First 1).Group
Write-Host "Max Sum " -ForegroundColor Gray -NoNewline
Write-Host $max.MaxSum -ForegroundColor Green
Write-Host "Max Path " -ForegroundColor Gray -NoNewline
Write-Host "$($max.Number -join '+')" -ForegroundColor Green
Print-Tree -Combination $max
Write-Host ''
Write-Host "Show ALL paths: " -ForegroundColor Yellow
foreach ($variant in $calculate) {
    Print-Tree -Combination $variant
    Write-Host ''
}


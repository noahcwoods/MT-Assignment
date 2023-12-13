#vars
$inputValue = $Null
$initalArr = @()
$numsArr = @()
$charArr = @()
$formatType = $Null
$sortType = $Null
$outputValue = $Null

#Grab data from txt file
$inputValue = Get-Content $args[0]

#add to array
$initialArr = $inputValue -split ','
for (($i = 0); $i -lt $initialArr.Length; $i++){
    
    if ($initialArr[$i] -match '^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)$'){
        $numsArr += [long][decimal]$initialArr[$i]
        $initialArr[$i] = $Null
    }elseif ($initialArr[$i] -match '^-?\d*\.?\d*$'){
        if ($initialArr[$i] -match '^-?\d*\.\d*$'){
            $numsArr += [float]$initialArr[$i]
        }else{
            $numsArr += [long]$initialArr[$i]
            $initialArr[$i] = $Null
        }
    }else{
        $charArr += $initialArr[$i]
    }
}

#$charArr

#get format type
if ($args[1].ToString().ToLower() -eq 'alpha' -or $args[1].ToString().ToLower() -eq 'numeric' -or $args[1].ToString().ToLower() -eq 'both'){
    $formatType = $args[1]
}else{
    Write-Output "Invalid argument provided for the format type"
    exit
}

#get sorting type
if ($args[2] -eq 'ascending' -or $args[2] -eq 'descending'){
    if ($args[2] -eq 'ascending'){
        $sortType = $true
    }else{
        $sortType = $false
    }
}else{
    Write-Output "Invalid argument provided for the sort type"
    exit
}

#Format outputValue according to user
if ($formatType -eq 'both'){
    if ($sortType){
        #setup ascending sorting and output
        $charArr = $charArr | Sort-Object
        $numsArr = $numsArr | Sort-Object
        [string]$outputValue = ($numsArr -join ", ") + ", " + ($charArr -join ", ")
    }else{
        #setup descending sorting and output
        $numsArr = $numsArr | Sort-Object -Descending
        $charArr = $charArr | Sort-Object -Descending
        [string]$outputValue = ($numsArr -join ", ") + ", " + ($charArr -join ", ")
    }
}elseif ($formatType -eq 'alpha'){
    if ($sortType){
        #setup ascending sorting and output
        $charArr = $charArr | Sort-Object
        [string]$outputValue = $charArr -join ", "
    }else{
        #setup descending sorting and output
        $charArr = $charArr | Sort-Object -Descending
        [string]$outputValue = $charArr -join ", "
    }
}else{
    if ($sortType){
        #setup ascending sorting and output
        $numsArr = $numsArr | Sort-Object
        [string]$outputValue = $numsArr -join ", "
    }else{
        #setup descending sorting and output
        $numsArr = $numsArr | Sort-Object -Descending
        [string]$outputValue = $numsArr -join ", "
    }
}

$outputValue
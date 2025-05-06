function Import-TextFileforAmiga {
    param (
        $ImportFile,
        $SystemType
    )
    $DataRevised = New-Object System.Collections.Generic.List[System.Object]
    if ($SystemType -eq 'PC'){
        $Data=Get-Content -path $ImportFile -Encoding ascii ## Powershell 5 compatibility
        $Data = $Data -split "`n"
    }
    if ($SystemType -eq 'Amiga'){
        $Data=[System.IO.File]::ReadAllText($ImportFile,[System.Text.Encoding]::GetEncoding('iso-8859-1')) #-replace "`r`n", "`n"
        $Data = $Data -split "`n" 
    }
    foreach ($Line in $Data){
        $DataRevised.Add(($line -replace "`r`n", "`n"))
    }
    return $DataRevised
}
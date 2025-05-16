function Test-64bit {
    param (
        
    )
    if ($Script:Settings.Architecture.Substring(0,2) -ne '64'){
        return $false

    }
    else {
        return $true
    }
}
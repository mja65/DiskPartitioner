function Test-64bit {
    param (
        
    )
    if ($Script:Settings.Architecture -ne '64-bit'){
        return $false

    }
    else {
        return $true
    }
}
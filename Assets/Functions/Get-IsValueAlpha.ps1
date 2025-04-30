function Get-IsValueAlpha {
    param (
        $ValueToTest
    )
    # $ValueToTest = "Alpha,numeric123"
    if ($ValueToTest -match "^[a-zA-Z]+$") {
        return $true
    } 
    else {
        return $false
    }
}



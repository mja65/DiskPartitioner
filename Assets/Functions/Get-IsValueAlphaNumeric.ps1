function Get-IsValueAlphaNumeric {
    param (
        $ValueToTest
    )
    # $ValueToTest = "Alpha,numeric123"
    if ($ValueToTest -match "^[a-zA-Z0-9]+$") {
        return $true
    } 
    else {
        return $false
    }
}







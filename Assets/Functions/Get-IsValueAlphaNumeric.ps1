function Get-IsValueAlphaNumeric {
    param (
        $ValueToTest,
        [Switch]$DosType
    )
    # $ValueToTest = "Alpha,numeric123"

    # $DosType = $true
    # $ValueToTest = 'PFS\3'

    if ($DosType){
        $MatchString = "^[a-zA-Z0-9_\\]+$"        
    }
    else {
        $MatchString = "^[a-zA-Z0-9_]+$"
    }

    if ($ValueToTest -match $MatchString ) {
        return $true
    } 
    else {
        return $false
    }

}







function Initialize-MBR {
    param (
        $Path
    
    )
    $Command = @()
    $Command += "mbr init $Path"

    return $Command

}
function Initialize-RDB {
    param (
        $Path
    
    )
    $Command = @()
    $Command += "rdb init $Path"

    return $Command

}
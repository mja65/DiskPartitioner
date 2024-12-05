function Add-RDBPartitiontoDisk {
    param (
        $Path,
        $Name,
        $DosType,
        $SizeBytes
    
    )
    
    $Command = @()
    $Command += "rdb part add $Path $Name $DosType $SizeBytes`B"

    return $Command

}
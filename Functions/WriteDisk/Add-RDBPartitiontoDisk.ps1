function Add-RDBPartitiontoDisk {
    param (
        $Path,
        $Name,
        $DosType,
        $SizeBytes
    
    )

    $Command = @()
    $Command += "rdb part add $Path $Name $($DosType.replace('\','')) $SizeBytes"

    return $Command

}
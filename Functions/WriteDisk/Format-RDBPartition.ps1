function Format-RDBPartition {
    param (
        $Path,
        $PartitionNumber,
        $Name   
    )
    
    $Command = @()
    $Command += "rdb part format $Path $PartitionNumber $Name"

    return $Command

}
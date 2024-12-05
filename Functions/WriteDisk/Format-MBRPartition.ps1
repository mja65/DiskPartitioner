function Format-MBRPartition {
    param (
        $Path,
        $PartitionNumber,
        $Name   
    )
    
    $Command = @()
    $Command += "mbr part format $Path $PartitionNumber $Name"

    return $Command

}
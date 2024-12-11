function Copy-MBRPartitiontoDisk {
    param (
        $SourcePath,
        $SourcePartitionNumber,
        $DestinationPath,
        $DestinationPartitionNumber,
        $SizeBytes
    )
    
    $Command = @()
    $Command += "mbr part clone $SourcePath $SourcePartitionNumber $DestinationPath $DestinationPartitionNumber"

    return $Command
}

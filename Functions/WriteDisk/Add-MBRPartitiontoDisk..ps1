function Add-MBRPartitiontoDisk {
    param (
        $Path,
        [Switch]$FAT32,
        [Switch]$ID76,
        $SizeBytes
    
    )
    
    if ($FAT32){
        $PartitionType = 'FAT32'
    }
    elseif ($ID76){
        $PartitionType = '0x76'
    }

    $Command = @()
    $Command += "mbr part add $Path $PartitionType $SizeBytes`B"

    return $Command

}
function Add-MBRPartitiontoDisk {
    param (
        $DiskNumber,
        [Switch]$FAT32,
        [Switch]$ID76,
        $PartitionNumber,
        $OffsetBytes,
        $SizeBytes,
        $VolumeName,
        $ImportedPartition
        )
    
    # if ($FAT32){
    #     $PartitionType = 'FAT32'
    # }
    # elseif ($ID76){
    #     $PartitionType = '0x76'
    # }

    # if ($ActiveFlag){
    #     $ActiveFlagtoUse = '-a'
    # }
    # $Command = @()
    # $Command += "mbr part add $Path $PartitionType $SizeBytes $ActiveFlagtoUse"

    # return $Command


    if (($ImportedPartition -eq $true) -or ($ID76)){

        if ($OffsetBytes){
            Write-InformationMessage -Message "Creating partition of type FAT32 on Disk number: $DiskNumber of size: $SizeBytes with offset of: $Offset"
            $null = New-Partition -DiskNumber $DiskNumber -Size $SizeBytes -MbrType FAT32 -Offset $OffsetBytes
        }
        else {
            Write-InformationMessage -Message "Creating partition of type FAT32 on Disk number: $DiskNumber of size: $SizeBytes"
            $null = New-Partition -DiskNumber $DiskNumber -Size $SizeBytes -MbrType FAT32 
        }
        
        if ($ID76){
            Write-InformationMessage -Message "Changing MBR type to 0x76"
            $null = Set-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionNumber -MbrType 0x76
        }
    }
    elseif ($FAT32){
        if ($OffsetBytes){
            Write-InformationMessage -Message "Creating partition of type FAT32 on Disk number: $DiskNumber of size: $SizeBytes with offset of: $Offset and formatting with name: $VolumeName"
            $null = New-Partition -DiskNumber $DiskNumber -Size $SizeBytes -MbrType FAT32 -Offset $OffsetBytes | format-volume -filesystem FAT32 -newfilesystemlabel $VolumeName
        }
        else {
            Write-InformationMessage -Message "Creating partition of type FAT32 on Disk number: $DiskNumber of size: $SizeBytes and formatting with name: $VolumeName"
            $null = New-Partition -DiskNumber $DiskNumber -Size $SizeBytes -MbrType FAT32 | format-volume -filesystem FAT32 -newfilesystemlabel $VolumeName
        }
    }

    
    


}




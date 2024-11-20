function Set-MinimumPartitionSizes {
    param (
        $SizeofDiskBytes,
        $FAT32Divider,
        $Fat32Minimum,
        $ID76Minimum,
        $PFS3Minimum,
        $PFS3Maximum, 
        $SystemMinimum,
        $Fat32DefaultMaximum,
        $WorkbenchDefaultMaximum, 
        $WorkbenchDivider,
        $DefaultAddFAT32Size,
        $DefaultAddID76Size,
        $DefaultAddPFS3Size
    )

    # $FAT32Divider = 15
    # $Fat32DefaultMaximum = 1024*1024*1024
    # $WorkbenchDefaultMaximum = 1024*1024*1024
    # $WorkbenchDivider = 15
    # $Fat32Minimum = 35840*1024
    # $PFS3Maximum = 101*1024*1024*1024
    # $SystemMinimum = 100*1024*1024
    # $PFS3Minimum = 10*1024*1024*1024


    $DiskMinimumSizesBytes = [PSCustomObject]@{
        Fat32Minimum = $Fat32Minimum
        ID76Minimum = $ID76Minimum
        PFS3Maximum = $PFS3Maximum
        SystemMinimum = $SystemMinimum
        PFS3Minimum = $PFS3Minimum
        FAT32Default = $null
        WorkbenchDefault = $null
        DefaultAddFAT32Size = $DefaultAddFAT32Size
        DefaultAddID76Size = $DefaultAddID76Size
        DefaultAddPFS3Size = $DefaultAddPFS3Size
    }


    if ($SizeofDiskBytes/$FAT32Divider -ge $Fat32DefaultMaximum){
        $DiskMinimumSizesBytes.FAT32Default =  $Fat32DefaultMaximum
    }
    else {
        $DiskMinimumSizesBytes.FAT32Default =  $SizeofDiskBytes/$FAT32Divider
    }

    if ($SizeofDiskBytes/$WorkbenchDivider -ge $WorkbenchDefaultMaximum){
        $DiskMinimumSizesBytes.WorkbenchDefault =  $WorkbenchDefaultMaximum
    }
    else {
        $DiskMinimumSizesBytes.WorkbenchDefault =  $SizeofDiskBytes/$WorkbenchDivider 
    }

    return $DiskMinimumSizesBytes
}

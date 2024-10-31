function Get-MinimumPartitionSizes {
    param (
        $SizeofDiskBytes
    )
    
    $DiskMinimumSizesBytes = [PSCustomObject]@{
        Fat32Minimum = 35840*1024
        PFS3Maximum = 101*1024*1024*1024
        SystemMinimum = 100*1024*1024
        PFS3Minimum = 10*1024*1024*1024
        FAT32Default = $null
        WorkbenchDefault = $null
    }

    $FAT32Divider = 15
    $Fat32DefaultMaximum = 1024*1024*1024
    $WorkbenchDefaultMaximum = 1024*1024*1024
    $WorkbenchDivider = 15

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
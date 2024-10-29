function Add-AmigaPartitiontoDisk {
    param (
        $DiskName,
        $SizePixels
    )
    
    $DiskName = 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk'
    $SizePixels = 100

    $NewPartition = New-GUIPartition -PartitionType 'Amiga' -SizePixels $SizePixels -LeftMargin $LeftMargin  -TopMargin 0 -RightMargin 0 -BottomMargin 0

}

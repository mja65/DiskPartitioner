function Add-AmigaPartitiontoDisk {
    param (
        $DiskName,
        $SizePixels,
        $LeftMargin
    )
    
    #$DiskName = 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk'
    #$SizePixels = 100
    #$LeftMargin = 0

    $PartitionNumber = (Get-Variable -Name $DiskName).Value.NextPartitionNumber

    Set-Variable -name ($DiskName+'_Partition_'+$PartitionNumber) -Scope script -value (New-GUIPartition -PartitionType 'Amiga' -SizePixels $SizePixels -LeftMargin $LeftMargin  -TopMargin 0 -RightMargin 0 -BottomMargin 0)

    #$WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk.AddChild(

    (Get-Variable -Name $DiskName).Value.AddChild(((Get-Variable -name ($DiskName+'_Partition_'+$PartitionNumber)).value))

    (Get-Variable -Name $DiskName).Value.NextPartitionNumber += 1

}


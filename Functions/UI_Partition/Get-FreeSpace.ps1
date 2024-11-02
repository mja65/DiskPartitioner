function Get-FreeSpace {
    param (
        $Prefix,
        $PartitionType,
        $AmigaDiskName
    )
    
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $PartitionType = 'MBR'
    # $PartitionType = 'Amiga'
    # $AmigaDiskName = 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk'

    if ($PartitionType -eq 'MBR'){
        $FreeSpace = $Script:WPF_UI_DiskPartition_Disk_MBR.RightDiskBoundary - $Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary
    }
    elseif ($PartitionType -eq 'Amiga') {
        $FreeSpace = $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk.RightDiskBoundary - $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk.LeftDiskBoundary
    }

    $AllPartitions = (Get-AllGUIPartitionBoundaries -Prefix $Prefix  -PartitionType $PartitionType)
    if ($AllPartitions){
        $LastPartitionName = $AllPartitions[$AllPartitions.Count-1].PartitionName
        $FreeSpace = (Get-GUIPartitionBoundaries -Prefix $Prefix -PartitionType $PartitionType -ObjecttoCheck ((Get-Variable -Name $LastPartitionName).Value)).RightBoundary-(Get-GUIPartitionBoundaries -Prefix $Prefix -PartitionType $PartitionType -ObjecttoCheck ((Get-Variable -Name $LastPartitionName).Value)).RightEdgeofObject     
        return $FreeSpace
    }
    else{
        return $FreeSpace
    }
 

}


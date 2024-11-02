function Get-FreeSpace {
    param (
        $Prefix,
        $PartitionType
    )
    
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $PartitionType = 'MBR'

    if ($PartitionType -eq 'MBR'){
        $AllPartitions = (Get-AllGUIPartitionBoundaries -Prefix $Prefix  -PartitionType $PartitionType)
        if ($AllPartitions){
            $LastPartitionName = $AllPartitions[$AllPartitions.Count-1].PartitionName
            $FreeSpace = (Get-GUIPartitionBoundaries -Prefix $Prefix -PartitionType $PartitionType -ObjecttoCheck ((Get-Variable -Name $LastPartitionName).Value)).RightBoundary-(Get-GUIPartitionBoundaries -Prefix $Prefix -PartitionType $PartitionType -ObjecttoCheck ((Get-Variable -Name $LastPartitionName).Value)).RightEdgeofObject            
        }
        else{
            $FreeSpace = $Script:WPF_UI_DiskPartition_Disk_MBR.RightDiskBoundary - $Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary
        }
    }

    return $FreeSpace

}


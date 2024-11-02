function Get-NextGUIMBRPartition {
    param (
        $Prefix,
        $PartitionNametoCheck,
        $Side
    )
    
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $PartitionNametoCheck = $Script:GUIActions.SelectedMBRPartition
    # $PartitionNametoCheck = 'WPF_UI_DiskPartition_Partition_FAT32_1'
    # $PartitionNametoCheck = 'WPF_UI_DiskPartition_Partition_ID76_2'
    # $Side = 'Right'

    $PartitionstoCheck = Get-AllGUIPartitionBoundaries -Prefix $Prefix -PartitionType 'MBR'
    $TotalNumberofPartitions = $PartitionstoCheck.Count
    $LeftMostPartition = $PartitionstoCheck[0].PartitionName
    $RightMostPartition = $PartitionstoCheck[$TotalNumberofPartitions-1].PartitionName

    for ($i = 0; $i -lt $TotalNumberofPartitions; $i++) {
        if ($PartitionNametoCheck -eq $PartitionstoCheck[$i].PartitionName){
            $PartitionIndexLine = $i
        }
    }


    if ($Side -eq 'Left'){
        if ($PartitionNametoCheck -eq $LeftMostPartition){
            return $RightMostPartition
        } 
        else{
            return $PartitionstoCheck[$PartitionIndexLine-1].PartitionName
        }
    }
    elseif ($Side -eq 'Right'){
        if ($PartitionNametoCheck -eq $RightMostPartition){
            return $LeftMostPartition
        } 
        else {
            return $PartitionstoCheck[$PartitionIndexLine+1].PartitionName
        }
    }

}

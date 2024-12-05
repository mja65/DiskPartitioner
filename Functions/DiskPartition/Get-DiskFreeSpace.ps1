function Get-DiskFreeSpace {
    param (
        $Disk,
        $Position,
        $PartitionNameNextto
    )
    
    # $Disk = $WPF_DP_Disk_MBR
    # $Disk = $WPF_DP_Partition_ID76_2_AmigaDisk
    # $PartitionNameNextto = 'WPF_DP_Partition_ID76_1'
    # $Position = 'AtEnd'

    #$PartitionstoCheck = [System.Collections.Generic.List[PSCustomObject]]::New()
    if ($Disk.DiskType -eq 'MBR'){
        $PartitionstoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq $Disk.DiskType} 
    }
    elseif ($Disk.DiskType -eq 'Amiga'){
        $ID76Partition = $AmigaDiskName.Substring(0,$AmigaDiskName.IndexOf('_AmigaDisk'))  
        $PartitionstoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq $Disk.DiskType -and $_.PartitionName -match $ID76Partition} 
    }
           
    if ($Position -eq 'AtEnd'){
        if ($PartitionstoCheck){
            return $PartitionstoCheck[$PartitionstoCheck.Count-1].BytesAvailableRight
        }
        else{
            return $Disk.DiskSizeBytes
        }
    }
    else{
        $PartitiontoCheck = $PartitionstoCheck | Where-Object {$_.PartitionName -eq $PartitionNameNextto}
        if ($Position -eq 'Right'){
            return $PartitiontoCheck.BytesAvailableRight 
        }
        elseif ($Position -eq 'Left'){
            return $PartitiontoCheck.BytesAvailableLeft 
        }
    }



}
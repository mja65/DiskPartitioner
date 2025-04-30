function Get-AmigaDiskFreeSpace {
    param (
        $Disk,
        $Position,
        $PartitionNameNextto
    )
    
    # $Disk = $WPF_DP_Disk_GPTMBR
    # $Disk = $WPF_DP_Partition_ID76_2_AmigaDisk
    # $PartitionNameNextto = 'WPF_DP_Partition_ID76_1'
    # $Position = 'AtEnd'

    #$PartitionstoCheck = [System.Collections.Generic.List[PSCustomObject]]::New()
    if ($Disk.DiskType -eq 'MBR'){
        $PartitionstoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridGPTMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_GPTMBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq $Disk.DiskType} 
    }
    elseif ($Disk.DiskType -eq 'Amiga'){
        $ID76Partition = $AmigaDiskName.Substring(0,$AmigaDiskName.IndexOf('_AmigaDisk'))  
        $PartitionstoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridGPTMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_GPTMBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq $Disk.DiskType -and $_.PartitionName -match $ID76Partition} 
    }
           
    if ($Position -eq 'AtEnd'){
        if ($PartitionstoCheck){
            return $PartitionstoCheck[$PartitionstoCheck.Count-1].BytesAvailableRight
        }
        else{
            if ($Disk.DiskType -eq 'MBR'){
                return $Disk.DiskSizeBytes - 2097152
            }
            elseif ($Disk.DiskType -eq 'Amiga'){
                
            }
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



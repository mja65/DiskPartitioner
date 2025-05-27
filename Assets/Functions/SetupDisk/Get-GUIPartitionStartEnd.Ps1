function Get-GUIPartitionStartEnd {
    param (
        $PartitionType,
        $AmigaDiskName 

    )

    # $AmigaDiskName = 'WPF_DP_Partition_ID76_2_AmigaDisk'
    # $PartitionType = 'MBR'
    # $PartitionType = 'Amiga'

    $ValuetoReturn = [PSCustomObject]@{
        StartingPositionPixels = 0
        EndingPositionPixels = 0
        StartingPositionBytes = 0
        EndingPositionBytes = 0
    }

    if ($PartitionType -eq 'MBR'){
        $ListofPartitions  = $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries
    }
    elseif ($PartitionType -eq 'Amiga'){
        $ID76Partition = $AmigaDiskName.Substring(0,$AmigaDiskName.IndexOf('_AmigaDisk'))        
        $ListofPartitions  = $Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.Name -Match $ID76Partition } 
    }
       
    $Counter = 0
    if (-not $ListofPartitions){ # No Partitions at all
        return $ValuetoReturn 
    }
    else{
        Foreach ($Partition in $ListofPartitions){
            If ($Counter -eq 0){
                $ValuetoReturn.StartingPositionPixels = $Partition.Partition.Margin.Left
            }          
            $ValuetoReturn.EndingPositionPixels += (Get-GUIPartitionWidth -Partition $Partition.Value)
            $ValuetoReturn.EndingPositionBytes +=  $Partition.Partition.PartitionSizeBytes
            $Counter ++
        }
    }
    return $ValuetoReturn                  
}


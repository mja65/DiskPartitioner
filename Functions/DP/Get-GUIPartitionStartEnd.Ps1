function Get-GUIPartitionStartEnd {
    param (
        $PartitionType,
        $AmigaDiskName 

    )

    # $AmigaDiskName = 'WPF_DP_Partition_ID76_1_AmigaDisk'
    # $PartitionType = 'MBR'
    # $PartitionType = 'Amiga'

    $ValuetoReturn = [PSCustomObject]@{
        StartingPositionPixels = 0
        EndingPositionPixels = 0
        StartingPositionBytes = 0
        EndingPositionBytes = 0
    }

    if ($PartitionType -eq 'MBR'){
        $ListofPartitions  = Get-AllGUIPartitions -PartitionType $PartitionType
    }
    elseif ($PartitionType -eq 'Amiga'){
        $ListofPartitions  = Get-AllGUIPartitions -PartitionType $PartitionType | Where-Object {$_.Name -Match $AmigaDiskName } 
    }
    
    
    $Counter = 0
    if (-not $ListofPartitions){ # No Partitions at all
        Write-host "$PartitionType No partitions"
        return $ValuetoReturn 
    }
    else{
        Foreach ($Partition in $ListofPartitions){
            If ($Counter -eq 0){
                $ValuetoReturn.StartingPositionPixels = $Partition.Value.Margin.Left
            }          
            $ValuetoReturn.EndingPositionPixels += (Get-GUIPartitionWidth -Partition $Partition.Value)
            Write-Host $Partition.PartitionSizeBytes
            $ValuetoReturn.EndingPositionBytes +=  $Partition.Value.PartitionSizeBytes
            $Counter ++
        }
    }
    return $ValuetoReturn                  
}
# Get-GUIPartitionStartEnd -PartitionType 'MBR'

function Get-MBRPartitionStartEnd {
    param (
        $Prefix
        #$PartitionType 
    )
    #$Prefix = 'WPF_UI_DiskPartition_Partition_'
    #$PartitionType = 'FAT32'
    #$PartitionType = 'ID76'


    $ValuetoReturn = [PSCustomObject]@{
        StartingPosition = 0
        EndingPosition = 0
    }

#$WPF_UI_DiskPartition_Partition_FAT32_1.ActualWidth
#$WPF_UI_DiskPartition_Partition_ID76_1.ActualWidth

    #$PrefixtoUse = ($Prefix+$PartitionType)

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix -and $_.Value.PartitionTypeMBRorAmiga -eq 'MBR'} 

    $Counter = 0
    if (-not $ListofVariables){ # No Partitions at all
        return $ValuetoReturn 
    }
    else{
        Foreach ($Variable in $ListofVariables){
            If ($Counter -eq 0){
                $ValuetoReturn.StartingPosition = $Variable.Value.Margin.Left
            }          
            $ValuetoReturn.EndingPosition += (Get-MBRPartitionWidth -MBRPartition $Variable.Value)
            $Counter ++
        }
        return $ValuetoReturn                  
    }
}



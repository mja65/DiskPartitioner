function Get-GUIPartitionStartEnd {
    param (
        $Prefix,
        $PartitionType 
    )
    #$Prefix = 'WPF_UI_DiskPartition_Partition_'

    $ValuetoReturn = [PSCustomObject]@{
        StartingPosition = 0
        EndingPosition = 0
    }

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix -and $_.Value.PartitionTypeMBRorAmiga -eq $PartitionType} 

    $Counter = 0
    if (-not $ListofVariables){ # No Partitions at all
        return $ValuetoReturn 
    }
    else{
        Foreach ($Variable in $ListofVariables){
            If ($Counter -eq 0){
                $ValuetoReturn.StartingPosition = $Variable.Value.Margin.Left
            }          
            $ValuetoReturn.EndingPosition += (Get-GUIPartitionWidth -Partition $Variable.Value)
            $Counter ++
        }
        return $ValuetoReturn                  
    }
}



function Get-GUIPartitionBoundaries {
    param (
        $Prefix,
        $ObjecttoCheck,
        $PartitionType
    )
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $ObjecttoCheck = $WPF_UI_DiskPartition_Partition_ID76_1
    # $ObjecttoCheck = $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk_Partition_2
    # $PartitionType = 'Amiga'
    
    $LeftEdgeofObject = $ObjecttoCheck.Margin.Left
    $RightEdgeofObject = $LeftEdgeofObject + (Get-GUIPartitionWidth -Partition $ObjecttoCheck)
    
    if ($PartitionType -eq 'MBR'){
        $ValuetoReturn = [PSCustomObject]@{
            LeftEdgeofObject = $LeftEdgeofObject
            RightEdgeofObject = $RightEdgeofObject 
            LeftBoundary = $Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary
            RightBoundary = $Script:WPF_UI_DiskPartition_Disk_MBR.RightDiskBoundary
        }
    }
    elseif ($PartitionType -eq 'Amiga'){
        $ValuetoReturn = [PSCustomObject]@{
            LeftEdgeofObject = $LeftEdgeofObject
            RightEdgeofObject = $RightEdgeofObject 
            LeftBoundary = $Script:WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk.LeftDiskBoundary
            RightBoundary = $Script:WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk.RightDiskBoundary
        }
    }

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix -and $_.Value.PartitionTypeMBRorAmiga -eq $PartitionType} 
    foreach ($Variable in $ListofVariables){
        $LeftEdgeofObjecttoCheck = ($Variable.Value.Margin.Left)
        $RightEdgeofObjecttoCheck = ($LeftEdgeofObjecttoCheck + (Get-GUIPartitionWidth -Partition $Variable.Value))
        if ($LeftEdgeofObjecttoCheck -ne $LeftEdgeofObject){
            if (($LeftEdgeofObjecttoCheck -ge $RightEdgeofObject) -and ($LeftEdgeofObjecttoCheck -lt $ValuetoReturn.RightBoundary)){
                $ValuetoReturn.RightBoundary = $LeftEdgeofObjecttoCheck
            }
            if (($RightEdgeofObjecttoCheck -le $LeftEdgeofObject) -and ($RightEdgeofObjecttoCheck -gt $ValuetoReturn.LeftBoundary)) {
                $ValuetoReturn.LeftBoundary = $RightEdgeofObjecttoCheck
            }
        }  
    }

   return $ValuetoReturn

}

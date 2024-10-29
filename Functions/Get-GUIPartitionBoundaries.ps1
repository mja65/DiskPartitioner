function Get-GUIPartitionBoundaries {
    param (
        $Prefix,
        $ObjecttoCheck
    )
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $ObjecttoCheck = $WPF_UI_DiskPartition_Partition_ID76_2
    
    $LeftEdgeofObject = $ObjecttoCheck.Margin.Left
    $RightEdgeofObject = $LeftEdgeofObject + (Get-MBRPartitionWidth -MBRPartition $ObjecttoCheck)
    
    $ValuetoReturn = [PSCustomObject]@{
        LeftEdgeofObject = $LeftEdgeofObject
        RightEdgeofObject = $RightEdgeofObject 
        LeftBoundary = $Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary
        RightBoundary = $Script:WPF_UI_DiskPartition_Disk_MBR.RightDiskBoundary
    }

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix -and $_.Value.PartitionTypeMBRorAmiga -eq 'MBR'} 
    foreach ($Variable in $ListofVariables){
        $LeftEdgeofObjecttoCheck = ($Variable.Value.Margin.Left)
        $RightEdgeofObjecttoCheck = ($LeftEdgeofObjecttoCheck + (Get-MBRPartitionWidth -MBRPartition $Variable.Value))
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

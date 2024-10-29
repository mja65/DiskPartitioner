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

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix} | Sort-Object -Property 'Name'
    #Write-host "Left Edge of current object is $LeftEdgeofObject"
    #Write-host "Right Edge of current object is $RightEdgeofObject"
    foreach ($Variable in $ListofVariables){
        $LeftEdgeofObjecttoCheck = ($Variable.Value.Margin.Left)
        $RightEdgeofObjecttoCheck = ($LeftEdgeofObjecttoCheck + (Get-MBRPartitionWidth -MBRPartition $Variable.Value))
        if ($LeftEdgeofObjecttoCheck -ne $LeftEdgeofObject){
            #Write-host "Checking $($Variable.Name)"
            if (($LeftEdgeofObjecttoCheck -ge $RightEdgeofObject) -and ($LeftEdgeofObjecttoCheck -lt $ValuetoReturn.RightBoundary)){
            #    Write-host "Left Edge of checked object is: $LeftEdgeofObjecttoCheck"
                $ValuetoReturn.RightBoundary = $LeftEdgeofObjecttoCheck
            }
            if (($RightEdgeofObjecttoCheck -le $LeftEdgeofObject) -and ($RightEdgeofObjecttoCheck -gt $ValuetoReturn.LeftBoundary)) {
            #    Write-host "Right Edge of checked object is: $RightEdgeofObjecttoCheck"
                $ValuetoReturn.LeftBoundary = $RightEdgeofObjecttoCheck
            }
        }
    }

   return $ValuetoReturn

}

#Get-GUIPartitionBoundaries -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck $WPF_UI_DiskPartition_Partition_ID76_3
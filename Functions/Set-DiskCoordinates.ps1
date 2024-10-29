function Set-DiskCoordinates {
    param (
        $Prefix,
        $PartitionPrefix 
    )
    # $Prefix = 'WPF_UI_DiskPartition_'
    # $PartitionPrefix = 'Partition_'

    $Script:WPF_UI_DiskPartition_Disk_MBR | Add-Member -force -NotePropertyMembers @{
        LeftDiskBoundary = $null
        RightDiskBoundary = $null
        LeftPartitionBoundary = $null
        RightPartitionBoundary = $null
    }
         
    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix -and $_.Value.PartitionTypeMBRorAmiga -eq 'MBR'} 
    
    $LeftPartitionBoundary = $null
    $RightPartitionBoundary = $null

    foreach ($Variable in $ListofVariables){
        if ($null -eq $LeftPartitionBoundary){
            $LeftPartitionBoundary = (Get-Variable -name $Variable.Name -ValueOnly).Margin.Left
        }
        elseif ((Get-Variable -name $Variable.Name -ValueOnly).Margin.Left -le $LeftPartitionBoundary){
            $LeftPartitionBoundary = (Get-Variable -name $Variable.Name -ValueOnly).Margin.Left
        }
        if ($null -eq $RightPartitionBoundary){
            $RightPartitionBoundary = (Get-Variable -name $Variable.Name -ValueOnly).Margin.Left + (Get-MBRPartitionWidth -MBRPartition (Get-Variable -name $Variable.Name -ValueOnly))
        }
        elseif ((Get-Variable -name $Variable.Name -ValueOnly).Margin.Left + (Get-MBRPartitionWidth -MBRPartition (Get-Variable -name $Variable.Name -ValueOnly)) -gt $RightPartitionBoundary){
            $RightPartitionBoundary = (Get-Variable -name $Variable.Name -ValueOnly).Margin.Left + (Get-MBRPartitionWidth -MBRPartition (Get-Variable -name $Variable.Name -ValueOnly))
        }

    }

    $Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary = 0 
    $Script:WPF_UI_DiskPartition_Disk_MBR.RightDiskBoundary = $LeftDiskBoundary + (Get-Variable -name ($Prefix+'Disk_MBR') -ValueOnly).Children[0].Width
    $Script:WPF_UI_DiskPartition_Disk_MBR.LeftPartitionBoundary = $LeftPartitionBoundary 
    $Script:WPF_UI_DiskPartition_Disk_MBR.RightPartitionBoundary = $RightPartitionBoundary 

}

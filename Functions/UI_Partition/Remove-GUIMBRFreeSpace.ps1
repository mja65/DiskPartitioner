function Remove-GUIMBRFreeSpace {
    param (
        $Prefix
    )
     
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'

    $PartitionstoMove = Get-AllGUIPartitionBoundaries -Prefix $Prefix -PartitionType 'MBR'
    
    if ($PartitionstoMove[0].LeftMargin -ne $Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary){       
        (Get-Variable -Name $PartitionstoMove[0].PartitionName).Value.Margin = [System.Windows.Thickness]"$($Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary),0,0,0" 
    } 

    $PartitionstoMove = Get-AllGUIPartitionBoundaries -Prefix $Prefix -PartitionType 'MBR'

    $AccumulatedSpace = 0

    
    for ($i = 1; $i -lt $PartitionstoMove.Count; $i++) {
        $SpaceBetweenPartition = $PartitionstoMove[$i].LeftMargin - $PartitionstoMove[$i-1].RightMargin
        #Write-Host $SpaceBetweenPartition
        $AccumulatedSpace += $SpaceBetweenPartition
        if ($AccumulatedSpace -ne 0){
            $NewLeftMargin = $PartitionstoMove[$i].LeftMargin - $AccumulatedSpace
            #write-host $NewLeftMargin 
            (Get-Variable -Name $PartitionstoMove[$i].PartitionName).Value.Margin = [System.Windows.Thickness]"$NewLeftMargin,0,0,0" 
        }
    }
    
}
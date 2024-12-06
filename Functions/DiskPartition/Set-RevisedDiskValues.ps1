function Set-RevisedDiskValues {
    param (
        $SizeBytes
    )
    
    $PartitionsToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'MBR'}
    $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).size
    $NewSizeBytes = $SizeBytes
    if ( $NewSizeBytes -ge ($WPF_DP_Disk_MBR.DiskSizeBytes -$DiskFreeSpaceSize)){
        $WPF_DP_Disk_MBR.DiskSizeBytes = $NewSizeBytes
        $WPF_DP_Disk_MBR.BytestoPixelFactor = $WPF_DP_Disk_MBR.DiskSizeBytes/$WPF_DP_Disk_MBR.DiskSizePixels 

        Get-AllGUIPartitions -PartitionType 'MBR' | ForEach-Object {
            $LeftMargin = $_.value.StartingPositionBytes/$WPF_DP_Disk_MBR.BytestoPixelFactor
            $SizePixels = $_.value.PartitionSizeBytes/$WPF_DP_Disk_MBR.BytestoPixelFactor
            if ($SizePixels -gt 4){
                $SizePixels -= 4
            }
            $_.value.Margin = [System.Windows.Thickness]"$LeftMargin,0,0,0"
            $TotalColumns = $_.value.ColumnDefinitions.Count-1
            for ($i = 0; $i -le $TotalColumns; $i++) {
                if  ($_.value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                    $_.value.ColumnDefinitions[$i].Width = $SizePixels
                } 
            }               
        }
    }   
}
function Set-RevisedDiskValues {
    param (
        $SizeBytes
    )
    
    $PartitionsToCheck = $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries
    $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).size
    $NewSizeBytes = $SizeBytes
    if ( $NewSizeBytes -ge ($WPF_DP_Disk_GPTMBR.DiskSizeBytes -$DiskFreeSpaceSize)){
        $WPF_DP_Disk_GPTMBR.DiskSizeBytes = $NewSizeBytes
        $WPF_DP_Disk_GPTMBR.BytestoPixelFactor = ($WPF_DP_Disk_GPTMBR.DiskSizeBytes -$WPF_DP_Disk_GPTMBR.MMBROverheadBytes) /$WPF_DP_Disk_GPTMBR.DiskSizePixels 

        Get-AllGUIPartitions -PartitionType 'MBR' | ForEach-Object {
            $LeftMargin = $_.value.StartingPositionBytes/$WPF_DP_Disk_GPTMBR.BytestoPixelFactor
            $SizePixels = $_.value.PartitionSizeBytes/$WPF_DP_Disk_GPTMBR.BytestoPixelFactor
            if ($SizePixels -gt 4){
                $SizePixels -= 4
            }
            $_.value.Margin = [System.Windows.Thickness]"$LeftMargin,0,0,0"
            $_.value.ColumnDefinitions[1].Width = $SizePixels
         
        }
    }   

    $Script:GUICurrentStatus.AmigaPartitionsandBoundaries = Get-AllGUIPartitionBoundaries -Amiga
    $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries =  Get-AllGUIPartitionBoundaries -GPTMBR

}
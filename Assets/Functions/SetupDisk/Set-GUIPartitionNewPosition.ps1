function Set-GUIPartitionNewPosition {
    param (
        $PartitionName,
        $PartitionType,
        $AmountMovedPixels,
        $AmountMovedBytes
    )
    
  

    # $PartitionName = 'WPF_DP_Partition_MBR_3'
    # $PartitionName = 'WPF_DP_Partition_ID76_1_AmigaDisk_Partition_2'
    # $AmountMovedBytes = 10240000
    
    write-debug "Function Set-GUIPartitionNewPosition PartitionName:$PartitionName AmountMovedBytes:$AmountMovedBytes AmountMovedPixels:$AmountMovedPixels"

    
    if ((Get-Variable -name $PartitionName).Value.CanMove -eq $false) {
        return $false
    }
    else{
        $PartitionBoundary = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionName -eq $PartitionName}
    
        if ($PartitionType -eq 'MBR'){
            $BytestoPixelFactor = $WPF_DP_Disk_GPTMBR.BytestoPixelFactor
        }
        elseif ($PartitionType -eq 'Amiga'){
            $AmigaDiskName = $PartitionName.Substring(0,($PartitionName.IndexOf('_AmigaDisk_Partition_')+10))
            $BytestoPixelFactor = (Get-Variable -name $AmigaDiskName).Value.BytestoPixelFactor 
        }
    
        if ($AmountMovedPixels){
            if ($AmountMovedPixels -gt 0){
                if (($BytestoPixelFactor*$AmountMovedPixels) -gt $PartitionBoundary.BytesAvailableRight) {
                    $AmountMovedPixels = $PartitionBoundary.BytesAvailableRight/$BytestoPixelFactor
                    
                }
            }
            elseif ($AmountMovedPixels -lt 0){
                write-debug "Available bytes left is:$($PartitionBoundary.BytesAvailableLeft)"
                if (($BytestoPixelFactor*$AmountMovedPixels*-1) -gt $PartitionBoundary.BytesAvailableLeft) {
                    $AmountMovedPixels = ($PartitionBoundary.BytesAvailableLeft/$BytestoPixelFactor*-1)
                }
            }
            $AmountMovedBytes = $BytestoPixelFactor*$AmountMovedPixels

            if ($PartitionType -eq 'MBR'){
                $AmountMovedBytes = Get-MBRNearestSizeBytes -SizeBytes $AmountMovedBytes -RoundDown
            }
            elseif ($PartitionType -eq 'Amiga'){
                $AmountMovedBytes = Get-AmigaNearestSizeBytes -SizeBytes $AmountMovedBytes -RoundDown
            }

        }
        elseif ($AmountMovedBytes){
            if ($PartitionType -eq 'MBR'){
                $AmountMovedBytes = Get-MBRNearestSizeBytes -SizeBytes $AmountMovedBytes -RoundDown
            }
            elseif ($PartitionType -eq 'Amiga'){
                $AmountMovedBytes = Get-AmigaNearestSizeBytes -SizeBytes $AmountMovedBytes -RoundDown
            }
            $AmountMovedPixels = $AmountMovedBytes/$BytestoPixelFactor
            write-debug "$AmountMovedPixels"
        }
       
        $AmounttoSetLeft = (Get-Variable -Name $PartitionName).value.Margin.Left + $AmountMovedPixels
            
        (Get-Variable -Name $PartitionName).value.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"
        (Get-Variable -Name $PartitionName).value.StartingPositionBytes = (Get-Variable -Name $PartitionName).value.StartingPositionBytes + $AmountMovedBytes
        if ($PartitionType -eq 'MBR'){
            (Get-Variable -Name $PartitionName).value.StartingPositionSector = (Get-Variable -Name $PartitionName).value.StartingPositionBytes/$Script:Settings.MBRSectorSizeBytes
        }
        return $true
    }


}

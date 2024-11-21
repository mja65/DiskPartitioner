function Set-GUIPartitionNewSize {
    param (
        [Switch]$ResizeBytes,
        [Switch]$ResizePixels,
        $PartitionName,
        $ActiontoPerform,
        $PartitionType,
        $SizeBytes,
        $SizePixelstoChange
    )
    
    # $PartitionName = 'WPF_DP_Partition_FAT32_1'
    # $SizeBytes = 536870912
    # $ActiontoPerform = 'MBR_ResizeFromRight'
    # $PartitionType = 'MBR'
   
    if ($SizePixelstoChange -eq 0){
        # Write-host 'No change' 
        return $false
    }

    if ($ActiontoPerform -eq 'MBR_ResizeFromLeft' -or $ActiontoPerform -eq 'Amiga_ResizeFromLeft'){
        if ((Get-Variable -name $PartitionName).Value.CanResizeLeft -eq $false){
            # Write-Host "Cannot Resize left"
            return $false
        }
    }
    elseif ($ActiontoPerform -eq 'MBR_ResizeFromRight' -or $ActiontoPerform -eq 'Amiga_ResizeFromRight'){
        if ((Get-Variable -name $PartitionName).Value.CanResizeRight -eq $false){
            # Write-Host "Cannot Resize Right"
            return $false
        }
    }

    if ($PartitionType -eq 'MBR'){
        $BytestoPixelFactor = $WPF_DP_Disk_MBR.BytestoPixelFactor
    }
    elseif ($PartitionType -eq 'Amiga'){
        $AmigaDiskName = $PartitionName.Substring(0,($PartitionName.IndexOf('_AmigaDisk_Partition_')+10))
        $BytestoPixelFactor = (Get-Variable -name $AmigaDiskName).Value.BytestoPixelFactor 
    }

   
    if ($SizeBytes){
        #Write-host 'Resizing based on bytes'
        $NewSizePixels = $SizeBytes/$BytestoPixelFactor
        if (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight')) {
            $BytestoChange = $SizeBytes - (Get-Variable -name $PartitionName).Value.PartitionSizeBytes 
        }
        elseif (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
            $BytestoChange = (Get-Variable -name $PartitionName).Value.PartitionSizeBytes - $SizeBytes 
        }
    }
    elseif ($SizePixelstoChange){
        #Write-host 'Resizing based on Pixels'
        $BytestoChange = ($SizePixelstoChange*$BytestoPixelFactor)
        $PartitionToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionName -eq $PartitionName}
        
        if (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight')) {
            if ($BytestoChange -gt $PartitionToCheck.BytesAvailableRight){
                $BytestoChange = $PartitionToCheck.BytesAvailableRight
                $SizePixelstoChange = $BytestoChange/$BytestoPixelFactor 
            }
            $SizeBytes = ((Get-Variable -name $PartitionName).Value.PartitionSizeBytes) + $BytestoChange    
            $NewSizePixels = (Get-GUIPartitionWidth -Partition (Get-Variable -name $PartitionName).Value) + $SizePixelstoChange
            $MinimumSizeBytes = $null       
            if ($PartitionType -eq 'MBR'){
                if ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'FAT32'){
                    $MinimumSizeBytes = $SDCardMinimumsandMaximums.FAT32Minimum
                }
                elseif ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'ID76'){
                    $MinimumSizeBytes = $SDCardMinimumsandMaximums.ID76Minimum
                }
            }
            elseif ($PartitionType -eq 'Amiga'){
                $MinimumSizeBytes = $SDCardMinimumsandMaximums.PFS3Minimum
            }
            if ($SizeBytes -lt $MinimumSizeBytes){
                $SizeBytes = $MinimumSizeBytes
                $NewSizePixels = $SizeBytes/$BytestoPixelFactor
            }
            elseif  ($PartitionType -eq 'Amiga' -and $SizeBytes -gt $SDCardMinimumsandMaximums.PFS3Maximum){
                $SizeBytes =  $SDCardMinimumsandMaximums.PFS3Maximum
                $NewSizePixels = $SizeBytes/$BytestoPixelFactor
            }
        }
        elseif (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
            if ($BytestoChange*-1 -gt $PartitionToCheck.BytesAvailableLeft){
                $BytestoChange = $PartitionToCheck.BytesAvailableLeft*-1
                $SizePixelstoChange = ($BytestoChange/$BytestoPixelFactor)*-1 
            }
            $NewSizePixels = (Get-GUIPartitionWidth -Partition (Get-Variable -name $PartitionName).Value) - $SizePixelstoChange
            $SizeBytes = ((Get-Variable -name $PartitionName).Value.PartitionSizeBytes) - $BytestoChange        
        } 
    }
    if ($NewSizePixels -gt 4){
        $NewSizePixels -= 4
    }
    else {
        $NewSizePixels = 0
    }
 
    if (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight') -or ($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
        (Get-Variable -name $PartitionName).Value.PartitionSizeBytes = $SizeBytes
        if (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
            $AmounttoSetLeft = (Get-Variable -Name $PartitionName).value.Margin.Left + $SizePixelstoChange
            (Get-Variable -Name $PartitionName).value.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"
            (Get-Variable -Name $PartitionName).value.StartingPositionBytes += $BytestoChange  
        }
        $TotalColumns = (Get-Variable -name $PartitionName).Value.ColumnDefinitions.Count-1
        for ($i = 0; $i -le $TotalColumns; $i++) {
            if  ((Get-Variable -name $PartitionName).Value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                (Get-Variable -name $PartitionName).Value.ColumnDefinitions[$i].Width = $NewSizePixels 
            } 
        }
    }

    return $true
  
}

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
    
    # $PartitionName = 'WPF_DP_Partition_ID76_1'
    # $SizeBytes = 536870912
    # $ActiontoPerform = 'MBR_ResizeFromRight'
    # $PartitionType = 'MBR'
   
     Write-host ""
     Write-host "Function Set-GUIPartitionNewSize SizeBytes:$SizeBytes SizePixelstoChange:$SizePixelstoChange ActiontoPerform:$ActiontoPerform"
    if (($ResizePixels) -and ($SizePixelstoChange -eq 0)){
        Write-host 'No change based on Pixels' 
        return $false
    }

    if ($ActiontoPerform -eq 'MBR_ResizeFromLeft' -or $ActiontoPerform -eq 'Amiga_ResizeFromLeft'){
        if ((Get-Variable -name $PartitionName).Value.CanResizeLeft -eq $false){
            Write-Host "Cannot Resize left"
            return $false
        }
    }
    elseif ($ActiontoPerform -eq 'MBR_ResizeFromRight' -or $ActiontoPerform -eq 'Amiga_ResizeFromRight'){
        if ((Get-Variable -name $PartitionName).Value.CanResizeRight -eq $false){
            Write-Host "Cannot Resize Right"
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

    $PartitionToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionName -eq $PartitionName}

    if (($ResizeBytes) -and ($SizeBytes -eq $PartitionToCheck.PartitionSizeBytes)){
        Write-host 'No change based on bytes' 
        return $false
    }

    $MinimumSizeBytes = $null       
    if ($PartitionType -eq 'MBR'){
        if ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'FAT32'){
            $MinimumSizeBytes = $SDCardMinimumsandMaximums.FAT32Minimum
        }
        elseif ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'ID76'){
            $AmigaPartitionstoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionName -match $PartitionName -and $_.PartitionType -eq 'Amiga'}
            $TotalSpaceofAmigaPartitions = 0
            for ($i = 0; $i -lt $AmigaPartitionstoCheck.Count; $i++) {
                $TotalSpaceofAmigaPartitions += $AmigaPartitionstoCheck[$i].PartitionSizeBytes
            }
            if ($TotalSpaceofAmigaPartitions -gt $SDCardMinimumsandMaximums.ID76Minimum){
                $MinimumSizeBytes = $TotalSpaceofAmigaPartitions 
            }
            else{
                $MinimumSizeBytes = $SDCardMinimumsandMaximums.ID76Minimum
            }
        }
    }
    elseif ($PartitionType -eq 'Amiga'){
        $MinimumSizeBytes = $SDCardMinimumsandMaximums.PFS3Minimum
    }

    # Write-Host "Minimum Size bytes is $MinimumSizeBytes"

    if ($SizeBytes){                
       # Write-host 'Resizing based on bytes'
        
        if ($SizeBytes -lt $MinimumSizeBytes){
            return $false
        }       
        if (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight')) {
            $BytestoChange = $SizeBytes - $PartitionToCheck.PartitionSizeBytes
            if ($BytestoChange -gt $PartitionToCheck.BytesAvailableRight){
                return $false
            }
        }
        elseif (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
            $BytestoChange = $PartitionToCheck.PartitionSizeBytes - $SizeBytes 
            if ($BytestoChange -gt $PartitionToCheck.BytesAvailableLeft){
                return $false
            }
        }
        
        $NewSizePixels = $SizeBytes/$BytestoPixelFactor
    }

    elseif ($SizePixelstoChange){
        # Write-host "Resizing based on Pixels"

        if (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight')) {

        }
        elseif (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
            $SizePixelstoChange = $SizePixelstoChange * -1
        }
        
        $BytestoChange = ($SizePixelstoChange * $BytestoPixelFactor)
                
        if (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight')) {
            if ($BytestoChange -gt $PartitionToCheck.BytesAvailableRight){
                $BytestoChange = $PartitionToCheck.BytesAvailableRight
            }
        }
        elseif (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
            if ($BytestoChange -gt $PartitionToCheck.BytesAvailableLeft){
                $BytestoChange = $PartitionToCheck.BytesAvailableLeft
                
            }
        }
        if (($PartitionToCheck.PartitionSizeBytes + $BytestoChange) -lt $MinimumSizeBytes){
            $BytestoChange = $MinimumSizeBytes - $PartitionToCheck.PartitionSizeBytes
        }
        
        $SizePixelstoChange = $BytestoChange / $BytestoPixelFactor
        # Write-host "Action is $ActiontoPerform. Resizing based on Pixels: $SizePixelstoChange. Bytes to change is: $BytestoChange"
        
        $SizeBytes = $PartitionToCheck.PartitionSizeBytes + $BytestoChange

        if  ($PartitionType -eq 'Amiga' -and $SizeBytes -gt $SDCardMinimumsandMaximums.PFS3Maximum){
            $SizeBytes =  $SDCardMinimumsandMaximums.PFS3Maximum
        }

        $NewSizePixels = $SizeBytes/$BytestoPixelFactor     

        if ($NewSizePixels -gt 4){
            $NewSizePixels -= 4
        }
        else {
            $NewSizePixels = 0
        }

    }
    
    # Write-Host "New Size of Partition is $SizeBytes"

    (Get-Variable -name $PartitionName).Value.PartitionSizeBytes = $SizeBytes
    
    if ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'ID76'){            
        (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizeBytes = $SizeBytes
        (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.BytestoPixelFactor = (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizeBytes / (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizePixels
        $AmigaPartitionstoChange = Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $PartitionName} | Sort-Object $_.Margin.Left
        
        $Counter = 1
        $LastPartitionEndPixels = 0
        foreach ($AmigaPartition in $AmigaPartitionstoChange) {
            if ($Counter -eq 1){
                $AmounttoSetLeft = $AmigaPartition.Value.StartingPositionBytes / (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.BytestoPixelFactor
            }
            else {
                $AmounttoSetLeft = $LastPartitionEndPixels
            }
            $AmigaPartition.Value.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"                
            $AmigaSizePixels = $AmigaPartition.Value.PartitionSizeBytes  / (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.BytestoPixelFactor
            if ($AmigaSizePixels -gt 4){
                $AmigaSizePixels -= 4
            }

            $TotalColumns = $AmigaPartition.Value.ColumnDefinitions.Count-1
            for ($i = 0; $i -le $TotalColumns; $i++) {
                if  ($AmigaPartition.Value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                    $AmigaPartition.Value.ColumnDefinitions[$i].Width = $AmigaSizePixels
                } 
            }

            $LastPartitionEndPixels += ($AmigaSizePixels + 4)
           # Write-Host "Last Partition EndPixels for partition $($AmigaPartition.Name) is: $LastPartitionEndPixels "
            $Counter ++
        }
       
    }

    if (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
        # Write-host "Resizing from Left. Old Starting Position Bytes is $($PartitionToCheck.StartingPositionBytes). Bytes to change is $BytestoChange. Old Left Margin is: $($PartitionToCheck.LeftMargin). Pixels to change is $($SizePixelstoChange)"
        (Get-Variable -Name $PartitionName).value.StartingPositionBytes -= $BytestoChange  
       # Write-host "New Starting Position bytes is: $((Get-Variable -Name $PartitionName).value.StartingPositionBytes)"
        $AmounttoSetLeft = $PartitionToCheck.LeftMargin  - $SizePixelstoChange
        (Get-Variable -Name $PartitionName).value.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"
    }
    
        $TotalColumns = (Get-Variable -name $PartitionName).Value.ColumnDefinitions.Count-1
        for ($i = 0; $i -le $TotalColumns; $i++) {
            if  ((Get-Variable -name $PartitionName).Value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                (Get-Variable -name $PartitionName).Value.ColumnDefinitions[$i].Width = $NewSizePixels 
            } 
        }
    

    return $true
    
}
# elseif ($PartitionToCheck.PartitionSizeBytes - $BytestoChange -lt $SDCardMinimumsandMaximums.FAT32Minimum){
#     $BytestoChange = $PartitionToCheck.PartitionSizeBytes -$SDCardMinimumsandMaximums.FAT32Minimum
#     $SizePixelstoChange = ($BytestoChange/$BytestoPixelFactor)*-1 
# }
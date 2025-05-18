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
    
    # $PartitionName = 'WPF_DP_Partition_MBR_2'
    # $PartitionName = 'WPF_DP_Partition_MBR_2_AmigaDisk_Partition_2'
    # $SizeBytes = 536870912
    # $ActiontoPerform = 'MBR_ResizeFromRight'
    # $PartitionType = 'MBR'
   
    write-debug "Function Set-GUIPartitionNewSize Partition:$PartitionName PartitionType:$PartitionType SizeBytes:$SizeBytes SizePixelstoChange:$SizePixelstoChange ActiontoPerform:$ActiontoPerform"
    if (($ResizePixels) -and ($SizePixelstoChange -eq 0)){
        write-debug 'No change based on Pixels' 
        return $false
    }

    if ($ActiontoPerform -eq 'MBR_ResizeFromLeft' -or $ActiontoPerform -eq 'Amiga_ResizeFromLeft'){
        if ((Get-Variable -name $PartitionName).Value.CanResizeLeft -eq $false){
            write-debug "Cannot Resize left"
            return $false
        }
    }
    elseif ($ActiontoPerform -eq 'MBR_ResizeFromRight' -or $ActiontoPerform -eq 'Amiga_ResizeFromRight'){
        if ((Get-Variable -name $PartitionName).Value.CanResizeRight -eq $false){
            write-debug "Cannot Resize Right"
            return $false
        }
    }

    if ($PartitionType -eq 'MBR'){
        $BytestoPixelFactor = $WPF_DP_Disk_GPTMBR.BytestoPixelFactor
    }
    elseif ($PartitionType -eq 'Amiga'){
        $AmigaDiskName = $PartitionName.Substring(0,($PartitionName.IndexOf('_AmigaDisk_Partition_')+10))
        $BytestoPixelFactor = (Get-Variable -name $AmigaDiskName).Value.BytestoPixelFactor 
    }

    $PartitionToCheck = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionName -eq $PartitionName}

    if (($ResizeBytes) -and ($SizeBytes -eq $PartitionToCheck.PartitionSizeBytes)){
        write-debug 'No change based on bytes' 
        return $false
    }

    $MinimumSizeBytes = $null       
    if ($PartitionType -eq 'MBR'){
        if ((Get-Variable -name $PartitionName).Value.PartitionSubType -eq 'FAT32'){
            $MinimumSizeBytes = $SDCardMinimumsandMaximums.MBRMinimum
        }
        elseif ((Get-Variable -name $PartitionName).Value.PartitionSubType -eq 'ID76'){
            $AmigaPartitionstoCheck = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionName -match $PartitionName -and $_.PartitionType -eq 'Amiga'}
            $AmigatoGPTMBROverhead = (Get-Variable -name ($PartitionName+'_AmigaDisk')).value.DiskSizeAmigatoGPTMBROverhead
            $TotalSpaceofAmigaPartitions = $AmigatoGPTMBROverhead
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
        if ($SDCardMinimumsandMaximums.PFS3Minimum -gt (Get-Variable -name $PartitionName).Value.ImportedFilesSpaceBytes){
            $MinimumSizeBytes = $SDCardMinimumsandMaximums.PFS3Minimum
        }
        else {
            $MinimumSizeBytes = (Get-Variable -name $PartitionName).Value.ImportedFilesSpaceBytes
        }
    }

    write-debug "Minimum Size bytes is $MinimumSizeBytes"

    if ($SizeBytes){                
       write-debug 'Resizing based on bytes'
       
       if ($PartitionType -eq 'MBR'){
           $SizeBytes = Get-MBRNearestSizeBytes -RoundDown -SizeBytes $SizeBytes 
       }
       elseif ($PartitionType -eq 'Amiga'){
        $SizeBytes = Get-AmigaNearestSizeBytes -RoundDown -SizeBytes $SizeBytes
       }

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
        write-debug "Resizing based on Pixels"

        if (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight')) {

        }
        elseif (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
            $SizePixelstoChange = $SizePixelstoChange * -1
        }
        
        if ($PartitionType -eq 'MBR'){
            $BytestoChange = Get-MBRNearestSizeBytes -SizeBytes ($SizePixelstoChange * $BytestoPixelFactor) -RoundDown
        }
        elseif ($PartitionType -eq 'Amiga'){
            $BytestoChange = Get-AmigaNearestSizeBytes -SizeBytes ($SizePixelstoChange * $BytestoPixelFactor) -RoundDown
        }
                        
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
        write-debug "Action is $ActiontoPerform. Resizing based on Pixels: $SizePixelstoChange. Bytes to change is: $BytestoChange"
        
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
    
    write-debug "New Size of Partition is $SizeBytes"

    (Get-Variable -name $PartitionName).Value.PartitionSizeBytes = $SizeBytes
    
   # $WPF_DP_Partition_MBR_2.PartitionSizeBytes
   # $WPF_DP_Partition_MBR_2_AmigaDisk.DiskSizeBytes

   #$PartitionName = 'WPF_DP_Partition_MBR_2'

    if ((Get-Variable -name $PartitionName).Value.PartitionSubType -eq 'ID76'){      
        write-debug "Old Size was: $((Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizeBytes)"     
        (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizeBytes = Get-AmigaDiskSize -AmigaDisk (Get-Variable -name ($PartitionName+'_AmigaDisk')).value
        write-debug "New size is: $((Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizeBytes)"    
        (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.BytestoPixelFactor = (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizeBytes / (Get-Variable -name ($PartitionName+'_AmigaDisk')).Value.DiskSizePixels
        $AmigaPartitionstoChange = Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $PartitionName} | Sort-Object {[int64]$_.value.StartingPositionBytes} 
              
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
           write-debug "Last Partition EndPixels for partition $($AmigaPartition.Name) is: $LastPartitionEndPixels "
            $Counter ++
        }
       
    }

    if (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')){
        write-debug "Resizing from Left. Old Starting Position Bytes is $($PartitionToCheck.StartingPositionBytes). Bytes to change is $BytestoChange. Old Left Margin is: $($PartitionToCheck.LeftMargin). Pixels to change is $($SizePixelstoChange)"
        (Get-Variable -Name $PartitionName).value.StartingPositionBytes -= $BytestoChange  
       write-debug "New Starting Position bytes is: $((Get-Variable -Name $PartitionName).value.StartingPositionBytes)"
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
$WPF_DP_Button_AddNewAmigaPartition.add_click({
    
    # $AmigaDiskName = 'WPF_DP_Partition_MBR_2_AmigaDisk'
    
    if ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'     
        $AmigaDiskName = "$($Script:GUICurrentStatus.SelectedGPTMBRPartition)_AmigaDisk"
    }
    elseif ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType = 'Left'   
        $AmigaDiskName = ($Script:GUICurrentStatus.SelectedAmigaPartition.Substring(0,($Script:GUICurrentStatus.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10))) 
    }
    elseif ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType = 'Right'  
        $AmigaDiskName = ($Script:GUICurrentStatus.SelectedAmigaPartition.Substring(0,($Script:GUICurrentStatus.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10))) 
    }
    
    if (($AddType -ne 'AtEnd') -and (-not $Script:GUICurrentStatus.SelectedAmigaPartition)){
        $null = Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'You must select a partition!' -BoxTypeError -ButtonType_OK
        return
    } 

    $CurrentNumberofPartitionsonAmigaDisk = (Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $AmigaDiskName}).Count

    if ($CurrentNumberofPartitionsonAmigaDisk -eq $Script:Settings.AmigaPartitionsperDiskMaximum){
        $null = Show-WarningorError -Msg_Header "Exceeded maximum number of partitions" -Msg_Body "You have $($Script:Settings.AmigaPartitionsperDiskMaximum) partitions on this disk! No more partitions can be added." -BoxTypeError -ButtonType_OK
        return
    }

    if (-not ($CurrentNumberofPartitionsonAmigaDisk)){
        $CanAddPartition = $true
        $EmptyAmigaDisk = $true
    }
    else {
        $CanAddPartition = (Get-Variable -Name $AmigaDiskName).value.CanAddPartition
        $EmptyAmigaDisk = $false
        If (($AddType -eq "AtEnd") -and (-not ($Script:GUICurrentStatus.SelectedAmigaPartition))){
            $PartitionNexttotouse = (Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName}).PartitionName | Select-Object -Last 1
        }
        else {
            $PartitionNexttotouse = $Script:GUICurrentStatus.SelectedAmigaPartition
        }
    }
    
    if ($CanAddPartition -eq $false) {
        $null = Show-WarningorError -Msg_Header 'Imported Partition Selected' -Msg_Body 'You cannot add partitions to an imported partition!' -BoxTypeError -ButtonType_OK
        return        
    }

    write-debug "Addtype is: $Addtype DiskName is: $AmigaDiskName Allows addition of partitions: $CanAddPartition" 
    
      if ($EmptyAmigaDisk -eq $true){
        $AvailableFreeSpace = (Get-Variable -name $AmigaDiskName).value.DiskSizeBytes
    }
    else {
        $AvailableFreeSpace = (Get-AmigaDiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $PartitionNexttotouse)
        write-debug "Available free space is: $AvailableFreeSpace "
    }
    if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
        $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
    }
    else {
        if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size){
            $SpacetoUse = $Script:SDCardMinimumsandMaximums.PFS3Minimum
        }
        else {
            $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size
    
        }
        $WorkDefaultValues = Get-InputCSVs -Diskdefaults | Where-Object {$_.Type -eq "Amiga" -and $_.Disk -eq 'Work'}
        
        $DeviceandVolumeNametoUse = (Get-DeviceandVolumeNametoUse)

        Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType $AddType -DeviceName $DeviceandVolumeNametoUse.DeviceName -VolumeName $DeviceandVolumeNametoUse.VolumeName -PartitionNameNextto $PartitionNexttotouse -SizeBytes (Get-AmigaNearestSizeBytes -RoundDown -SizeBytes $SpacetoUse) -Buffers $WorkDefaultValues.Buffers -DosType $WorkDefaultValues.DosType -NoMount $WorkDefaultValues.NoMountFlag -Bootable $WorkDefaultValues.BootableFlag -Priority ([int]$WorkDefaultValues.Priority) -MaxTransfer $WorkDefaultValues.MaxTransfer -Mask $WorkDefaultValues.Mask

        Update-UI -DiskPartitionWindow
        #Set-AmigaDiskSizeOverhangPixels -AmigaDisk (Get-Variable -name $AmigaDiskName).Value
    }
    
})




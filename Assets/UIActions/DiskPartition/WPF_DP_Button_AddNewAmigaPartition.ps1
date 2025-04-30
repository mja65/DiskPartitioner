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

    $CanAddPartition = (Get-Variable -Name $AmigaDiskName).value.CanAddPartition
    Write-Host "Addtype is: $Addtype DiskName is: $AmigaDiskName Allows addition of partitions: $CanAddPartition" 
    
    if ($CanAddPartition -eq $false) {
        Write-host "Trigger"
        $null = Show-WarningorError -Msg_Header 'Imported Partition Selected' -Msg_Body 'You cannot add partitions to an imported partition!' -BoxTypeError -ButtonType_OK
        return
        
    }
 
    if (($AddType -ne 'AtEnd') -and (-not $Script:GUICurrentStatus.SelectedAmigaPartition)){
        $null = Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'You must select a partition!' -BoxTypeError -ButtonType_OK
        return
    }   

    $AvailableFreeSpace = (Get-AmigaDiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $Script:GUICurrentStatus.SelectedAmigaPartition)
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

        Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType $AddType -PartitionNameNextto $Script:GUICurrentStatus.SelectedAmigaPartition -SizeBytes (Get-AmigaNearestSizeBytes -RoundDown -SizeBytes $SpacetoUse) -Buffers $WorkDefaultValues.Buffers -DosType $WorkDefaultValues.DosType -NoMount $WorkDefaultValues.NoMountFlag -Bootable $WorkDefaultValues.BootableFlag -Priority ([int]$WorkDefaultValues.Priority) -MaxTransfer $WorkDefaultValues.MaxTransfer -Mask $WorkDefaultValues.Mask
    }
    
})




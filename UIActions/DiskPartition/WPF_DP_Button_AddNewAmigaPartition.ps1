$WPF_DP_Button_AddNewAmigaPartition.add_click({
           
    if ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'     
        $AmigaDiskName = "$($Script:GUIActions.SelectedMBRPartition)_AmigaDisk"
    }
    elseif ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType= 'Left'   
        $AmigaDiskName = ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10))) 
    }
    elseif ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType = 'Right'  
        $AmigaDiskName = ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10))) 
    }
    if ((-not $AddType -ne 'AtEnd') -and (-not $Script:GUIActions.SelectedAmigaPartition)){
        $null = Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'You must select a partition!' -BoxTypeError -ButtonType_OK
    }
    else{
        $AvailableFreeSpace = (Get-AmigaDiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition)
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
            Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType $AddType -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes (Get-AmigaNearestSizeBytes -RoundDown -SizeBytes $SpacetoUse) -Buffers '300' -DosType 'PFS\3' -Bootable $false -NoMount $false -Priority 99 -MaxTransfer '0xffffff' 
            $Script:GUIActions.WorkbenchFilesNeeded = (Confirm-DefaultOSFilesNeeded).WorkbenchFilesNeeded      
        }
    }
})




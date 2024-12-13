$WPF_DP_Button_AddNewFAT32Partition.add_click({
    if ($WPF_DP_AddNewFAT32Partition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'        
    }
    elseif ($WPF_DP_AddNewFAT32Partition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType= 'Left'   
    }
    elseif ($WPF_DP_AddNewFAT32Partition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType= 'Right'   
    }
    Write-Host  "$AddType $($Script:GUIActions.SelectedMBRPartition)"
    if (($AddType -ne 'AtEnd') -and (-not $Script:GUIActions.SelectedMBRPartition)){
        Write-Host "$($Script:GUIActions.SelectedMBRPartition)"
        $null = Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'You must select a partition!' -BoxTypeError -ButtonType_OK
    }
    else {
        $AvailableSpace = (Get-MBRDiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
        if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.FAT32Minimum){
            $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
        }
        else {
            if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size){
                $SpacetoUse = $Script:SDCardMinimumsandMaximums.FAT32Minimum
            }
            else {
                $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size
            }
            Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType $AddType -SizeBytes (Get-MBRNearestSizeBytes -RoundDown -SizeBytes $SpacetoUse) 
        }
    }
})

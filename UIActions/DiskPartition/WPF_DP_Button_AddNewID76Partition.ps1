$WPF_DP_Button_AddNewID76Partition.add_click({
    if ($WPF_DP_AddNewFAT32Partition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'   
    }
    elseif ($WPF_DP_AddNewFAT32Partition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType= 'Left'   
    }
    elseif ($WPF_DP_AddNewFAT32Partition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType= 'Right'  
    }

    if (($AddType -ne 'AtEnd') -and (-not $Script:GUIActions.SelectedMBRPartition)){
        $null = Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'You must select a partition!' -BoxTypeError -ButtonType_OK
    }
    else {
        $AvailableSpace = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
        if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.ID76Minimum){
            $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
        }
        else {
            if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddID76Size){
                $SpacetoUse = $Script:SDCardMinimumsandMaximums.ID76Minimum
            }
            else {
                $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddID76Size
            }
            Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType $AddType -SizeBytes $SpacetoUse 
        }
    }

})

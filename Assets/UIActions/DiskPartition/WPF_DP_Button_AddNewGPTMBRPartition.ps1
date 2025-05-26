$WPF_DP_Button_AddNewGPTMBRPartition.add_click({
        if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
    if ($WPF_DP_AddNewGPTMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'        
    }
    elseif ($WPF_DP_AddNewGPTMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType= 'Left'   
    }
    elseif ($WPF_DP_AddNewGPTMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType= 'Right'   
    }
    
    if ($WPF_DP_AddNewGPTMBRPartition_Type_DropDown.SelectedItem -eq 'FAT32'){
        $PartitionSubtypetouse = 'FAT32'
    }
    elseif ($WPF_DP_AddNewGPTMBRPartition_Type_DropDown.SelectedItem -eq '0x76 (Amiga Partition)'){
        $PartitionSubtypetouse = 'ID76'
    } 

    # Write-debug  "$AddType $($Script:GUICurrentStatus.SelectedGPTMBRPartition)"
    if (($AddType -ne 'AtEnd') -and (-not $Script:GUICurrentStatus.SelectedGPTMBRPartition)){
        # Write-debug "$($Script:GUICurrentStatus.SelectedGPTMBRPartition)"
        $null = Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'You must select a partition!' -BoxTypeError -ButtonType_OK
    }
    else {
        if ((Get-AllGUIPartitions -PartitionType 'MBR').count -eq $Script:Settings.MBRPartitionsMaximum){
            $null = Show-WarningorError -Msg_Header 'Maximum Number of Partitions' -Msg_Body 'You have reached the maximum number of primary partitions allowed. Cannot create partition!' -BoxTypeError -ButtonType_OK
        }
        else {
            if ($PartitionSubtypetouse -eq 'FAT32'){
                $MinimumRequiredSpace = $Script:SDCardMinimumsandMaximums.MBRMinimum
            }
            elseif ($PartitionSubtypetouse -eq 'ID76'){
                $MinimumRequiredSpace = $Script:SDCardMinimumsandMaximums.ID76Minimum
            }
            $AvailableSpace = (Get-MBRDiskFreeSpace -Disk $WPF_DP_Disk_GPTMBR -Position $AddType -PartitionNameNextto $Script:GUICurrentStatus.SelectedGPTMBRPartition)
            $AvailableSpace = (Get-MBRNearestSizeBytes -Rounddown $AvailableSpace)
            $MinimumRequiredSpace = (Get-MBRNearestSizeBytes -Roundup $MinimumRequiredSpace)
            if ($AvailableSpace -lt $MinimumRequiredSpace){
                $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
            }
            else {
                $SpacetoUse = Get-NewPartitionSize -DefaultScale 'GiB' -MaximumSizeBytes $AvailableSpace -MinimumSizeBytes $MinimumRequiredSpace
                if ($SpacetoUse){
                    # Write-debug "Adding Partition with subtype:$PartitionSubtypetouse Addtype:$AddType Size:$(Get-MBRNearestSizeBytes -RoundDown -SizeBytes $SpacetoUse)"
                    Add-GUIPartitiontoGPTMBRDisk -PartitionSubType $PartitionSubtypetouse -PartitionType 'MBR' -PartitionNameNextto $Script:GUICurrentStatus.SelectedGPTMBRPartition -AddType $AddType -SizeBytes (Get-MBRNearestSizeBytes -RoundDown -SizeBytes $SpacetoUse) 
                }
                else {
                    return
                }

            }
        }
    }
})


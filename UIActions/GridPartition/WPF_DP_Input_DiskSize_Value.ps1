$WPF_DP_Input_DiskSize_Value.add_LostFocus({
    if (-not $Script:GUIActions.DiskSizeSelected -eq $true){
        if ($WPF_DP_Input_DiskSize_Value.Text){
            $Script:GUIActions.DiskSizeSelected = $true
            $WPF_DP_GridAmiga.Visibility = 'Visible'
            $WPF_DP_GridMBR.Visibility = 'Visible'
            Add-InitialMBRDisk -DiskSizeBytes (Get-ConvertedSize -Size ($WPF_DP_Input_DiskSize_Value.Text) -ScaleFrom ($WPF_DP_Input_DiskSize_SizeScale_Dropdown.SelectedItem) -Scaleto 'B').Size
            $Script:SDCardMinimumsandMaximums = Set-MinimumPartitionSizes   -SizeofDiskBytes $WPF_DP_Disk_MBR.DiskSizeBytes `
                                                                            -FAT32Divider 15 `
                                                                            -Fat32Minimum (35840*1024) `
                                                                            -ID76Minimum (35840*1024) `
                                                                            -PFS3Minimum (10*1024*1024) `
                                                                            -PFS3Maximum (101*1024*1024*1024) `
                                                                            -SystemMinimum (100*1024*1024) `
                                                                            -Fat32DefaultMaximum (1024*1024*1024) `
                                                                            -WorkbenchDefaultMaximum  (1024*1024*1024) `
                                                                            -WorkbenchDivider 15 `
                                                                            -DefaultAddFAT32Size 1073741824 `
                                                                            -DefaultAddID76Size 1073741824 `
                                                                            -DefaultAddPFS3Size 1073741824 `
            
            if (Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'AtEnd' -DefaultPartition $true -SizeBytes $Script:SDCardMinimumsandMaximums.FAT32Default -eq $true){
            }
            if (Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'AtEnd'-DefaultPartition $true -SizeBytes ($WPF_DP_Disk_MBR.DiskSizeBytes - $Script:SDCardMinimumsandMaximums.FAT32Default) -eq $true){
            }
        }
        else{
            $WPF_DP_GridAmiga.Visibility = 'Hidden'
            $WPF_DP_GridMBR.Visibility = 'Hidden'
        }
    }
})

for ($i = 0; $i -lt $WPF_DP_DiskGrid_MBR.ContextMenu.Items.Count; $i++) {
    if ($WPF_DP_DiskGrid_MBR.ContextMenu.Items[$i].Name -eq 'DeletePartition'){
        $WPF_DP_DiskGrid_MBR.ContextMenu.Items[$i].add_click({
           # Write-Host 'Remove Partition'   
           if ((Remove-MBRGUIPartition -PartitionName $Script:GUIActions.SelectedMBRPartition) -eq $false){
                Write-host 'Cannot Remove Partition!'
           }         
        })
    }
}

for ($i = 0; $i -lt $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Count; $i++) {
    if ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items[$i].Name -eq 'DeleteAmigaPartition'){
        $WPF_DP_DiskGrid_Amiga.ContextMenu.Items[$i].add_click({
           Write-Host 'Remove Partition'   
           if ((Remove-AmigaGUIPartition -PartitionName $Script:GUIActions.SelectedAmigaPartition) -eq $false){
                Write-host 'Cannot Remove Partition!'
           }         
        })
    }
}

for ($i = 0; $i -lt $WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items.Count; $i++) {
    if ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT332PartitionLeft'){
        $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'       
            if ((Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'Left' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size) -eq 2){
                Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'Left' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.FAT32Minimum
            }
            $Script:GUIActions.ActionToPerform = $null        
        })
    }
    elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionRight'){
        $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Fat32 Add'
            if ((Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'Right' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size) -eq 2){
                Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'Right' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.FAT32Minimum
            }
            $Script:GUIActions.ActionToPerform = $null       
        })
    }
    elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionEnd'){
        $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'       
            if ((Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'AtEnd' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size) -eq 2){
                Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'AtEnd' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.FAT32Minimum
            }
            $Script:GUIActions.ActionToPerform = $null               
        })
    }
    elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionLeft'){
        $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'       
            if ((Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'Left' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddID76Size) -eq 2){
                Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'Left' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.ID76Minimum
            }
            $Script:GUIActions.ActionToPerform = $null                
        })
    }
    elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionRight'){
        $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'      
            if ((Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'Right' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddID76Size) -eq 2){
                Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'Right' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.ID76Minimum
            }  
            $Script:GUIActions.ActionToPerform = $null                
        })
    }
    elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionEnd'){
        $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'      
            if ((Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'AtEnd' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddID76Size) -eq 2){
                Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'AtEnd' -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition -SizeBytes $Script:SDCardMinimumsandMaximums.ID76Minimum
            }  
            $Script:GUIActions.ActionToPerform = $null            
        })
    }
}

for ($i = 0; $i -lt $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items.Count; $i++) {
    if ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionLeft'){
        $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'
            $AmigaDiskName = ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10)))    
            if ((Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType 'Left' -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size) -eq 2){
                Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType 'Left' -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $Script:SDCardMinimumsandMaximums.PFS3Minimum
            }
            $Script:GUIActions.ActionToPerform = $null            
        })
    }
    elseif ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionRight'){
        $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'
            $AmigaDiskName = ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10)))    
            if ((Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType 'Right' -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size) -eq 2){
                Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType 'Right' -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $Script:SDCardMinimumsandMaximums.PFS3Minimum
            }
            $Script:GUIActions.ActionToPerform = $null       
        })
    }
    elseif ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionEnd'){
        $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.items[$i].add_click({
            #Write-Host 'Create Partition'
            $AmigaDiskName = ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10)))    
            if ((Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType 'AtEnd' -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size) -eq 2){
                Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType 'AtEnd' -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $Script:SDCardMinimumsandMaximums.PFS3Minimum
            }
            $Script:GUIActions.ActionToPerform = $null        
        })
    }
}





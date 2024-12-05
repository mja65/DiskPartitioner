# for ($i = 0; $i -lt $WPF_DP_DiskGrid_MBR.ContextMenu.Items.Count; $i++) {
#     if ($WPF_DP_DiskGrid_MBR.ContextMenu.Items[$i].Name -eq 'DeletePartition'){
#         $WPF_DP_DiskGrid_MBR.ContextMenu.Items[$i].add_click({
#            # Write-Host 'Remove Partition'   
#            if ((Remove-MBRGUIPartition -PartitionName $Script:GUIActions.SelectedMBRPartition) -eq $false){
#                 Write-host 'Cannot Remove Partition!'
#            }         
#         })
#     }
# }

# for ($i = 0; $i -lt $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Count; $i++) {
#     if ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items[$i].Name -eq 'DeleteAmigaPartition'){
#         $WPF_DP_DiskGrid_Amiga.ContextMenu.Items[$i].add_click({
#            Write-Host 'Remove Partition'   
#            if ((Remove-AmigaGUIPartition -PartitionName $Script:GUIActions.SelectedAmigaPartition) -eq $false){
#                 Write-host 'Cannot Remove Partition!'
#            }         
#         })
#     }
# }

# for ($i = 0; $i -lt $WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items.Count; $i++) {
#     if ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionLeft'){
#         $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
#             $AddType= 'Left'  
#             #Write-Host 'Create Partition'       
#             $AvailableSpace = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
#             if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.FAT32Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.FAT32Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size
#                 }
#                 Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType $AddType -SizeBytes $SpacetoUse 
#             }
#             $Script:GUIActions.ActionToPerform = $null        
#         })
#     }
#     elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionRight'){
#         $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
#             $AddType= 'Right'  
#             #Write-Host 'Fat32 Add'
#             $AvailableSpace = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
#             if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.FAT32Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.FAT32Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size
#                 }
#                 Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType $AddType -SizeBytes $SpacetoUse 
#             }
#             $Script:GUIActions.ActionToPerform = $null       
#         })
#     }
#     elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionEnd'){
#         $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
#             $AddType = 'AtEnd'  
#             #Write-Host 'Create Partition'       
#             $AvailableSpace = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
#             if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.FAT32Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.FAT32Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddFAT32Size
#                 }
#                 Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType $AddType -SizeBytes $SpacetoUse 
#             }
#             $Script:GUIActions.ActionToPerform = $null               
#         })
#     }
#     elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionLeft'){
#         $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
#             $AddType= 'Left'  
#             #Write-Host 'Create Partition'       
#             $AvailableSpace = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
#             if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.ID76Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddID76Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.ID76Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddID76Size
#                 }
#                 Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType $AddType -SizeBytes $SpacetoUse 
#             }
#             $Script:GUIActions.ActionToPerform = $null                
#         })
#     }
#     elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionRight'){
#         $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
#             $AddType= 'Right'  
#             #Write-Host 'Create Partition'      
#             $AvailableSpace = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
#             if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.ID76Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddID76Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.ID76Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddID76Size
#                 }
#                 Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType $AddType -SizeBytes $SpacetoUse 
#             } 
#             $Script:GUIActions.ActionToPerform = $null                
#         })
#     }
#     elseif ($WPF_DP_DiskGrid_MBR.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionEnd'){
#         $WPF_DP_DiskGrid_MBR.ContextMenu.Items.items[$i].add_click({
#             $AddType = 'AtEnd'  
#             #Write-Host 'Create Partition'      
#             $AvailableSpace = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
#             if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.ID76Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddID76Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.ID76Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddID76Size
#                 }
#                 Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType $AddType -SizeBytes $SpacetoUse 
#             }
#             $Script:GUIActions.ActionToPerform = $null            
#         })
#     }
# }

# for ($i = 0; $i -lt $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items.Count; $i++) {
#     if ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionLeft'){
#         $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.items[$i].add_click({
#             $AddType= 'Left'  
#             #Write-Host 'Create Partition'
#             $AmigaDiskName = ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10)))    
#             $AvailableFreeSpace = (Get-DiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $PartitionNameNextto)
#             if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.PFS3Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size
        
#                 }
#                 Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType $AddType -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $SpacetoUse       
#             }
#             $Script:GUIActions.ActionToPerform = $null            
#         })
#     }
#     elseif ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionRight'){
#         $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.items[$i].add_click({
#             $AddType= 'Right'  
#             #Write-Host 'Create Partition'
#             $AmigaDiskName = ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10)))    
#             $AvailableFreeSpace = (Get-DiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $PartitionNameNextto)
#             if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.PFS3Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size
        
#                 }
#                 Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType $AddType -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $SpacetoUse       
#             }
#             $Script:GUIActions.ActionToPerform = $null       
#         })
#     }
#     elseif ($WPF_DP_DiskGrid_Amiga.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionEnd'){
#         $WPF_DP_DiskGrid_Amiga.ContextMenu.Items.items[$i].add_click({
#             $AddType = 'AtEnd'
#             #Write-Host 'Create Partition'
#             $AmigaDiskName = "$($Script:GUIActions.SelectedMBRPartition)_AmigaDisk" 
#             $AvailableFreeSpace = (Get-DiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $PartitionNameNextto)
#             if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
#                 $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#             }
#             else {
#                 if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size){
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.PFS3Minimum
#                 }
#                 else {
#                     $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size
        
#                 }
#                 Add-GUIPartitiontoAmigaDisk -AmigaDiskName $AmigaDiskName -AddType $AddType -PartitionNameNextto $Script:GUIActions.SelectedAmigaPartition -SizeBytes $SpacetoUse       
#             }
#             $Script:GUIActions.ActionToPerform = $null        
#         })
#     }
# }





$WPF_NewPartitionWindow_OK_Button.Add_Click({
    if ((Get-IsValueNumber -TexttoCheck $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text) -eq $false){
        $WPF_NewPartitionWindow_ErrorMessage_Label.Text = "Size of partition must be a number!"
    }
    elseif ((Get-IsValueNumber -TexttoCheck $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text) -eq $true){
        $WPF_NewPartitionWindow_ErrorMessage_Label.Text = ""
        $ValuetoCheck = (Get-ConvertedSize -Size $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text -ScaleFrom $WPF_NewPartitionWindow_Input_PartitionSize_SizeScale_Dropdown.Text -Scaleto 'B').size
        if (-not (($ValuetoCheck -le $Script:GUICurrentStatus.NewPartitionMaximumSizeBytes) -and $ValuetoCheck -ge ($Script:GUICurrentStatus.NewPartitionMinimumSizeBytes))){
            $WPF_NewPartitionWindow_ErrorMessage_Label.Text = "Size of partition must be less than maximum size and greater than the minimum size!"
        }
        else {
            $null = $WPF_NewPartitionWindow.Close()
        }
    }

})


#         
        
#         if ($Script:GUICurrentStatus.NewPartitionToAdd -eq 'GPTMBR'){
#             if ($WPF_DP_AddNewGPTMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
#                 $AddType = 'AtEnd'        
#             }
#             elseif ($WPF_DP_AddNewGPTMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
#                 $AddType= 'Left'   
#             }
#             elseif ($WPF_DP_AddNewGPTMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
#                 $AddType= 'Right'   
#             }
#             if ($WPF_DP_AddNewGPTMBRPartition_Type_DropDown.SelectedItem -eq 'FAT32'){
#                 $PartitionSubtypetouse = 'FAT32'
#             }
#             elseif ($WPF_DP_AddNewGPTMBRPartition_Type_DropDown.SelectedItem -eq '0x76 (Amiga Partition)'){
#                 $PartitionSubtypetouse = 'ID76'
#             } 
#             if ($PartitionSubtypetouse -eq 'FAT32'){
#                 $MinimumRequiredSpace = $Script:SDCardMinimumsandMaximums.MBRMinimum            
#             }
#             elseif ($PartitionSubtypetouse -eq 'ID76'){
#                 $MinimumRequiredSpace = $Script:SDCardMinimumsandMaximums.ID76Minimum                
#             }
            
#             $AvailableSpace = (Get-MBRDiskFreeSpace -Disk $WPF_DP_Disk_GPTMBR -Position $AddType -PartitionNameNextto $Script:GUICurrentStatus.SelectedGPTMBRPartition)

#             if ($ValuetoCheck -ge $MinimumRequiredSpace -and $ValuetoCheck -le $AvailableSpace){
#                 $null = $WPF_NewPartitionWindow.close()
#             }
#             else {
#                 $null = Show-WarningorError -Msg_Header 'Insufficient space' -Msg_Body 'Not enough space to create partition of that size! Either correct value or hit cancel' -BoxTypeError -ButtonType_OK
#             }
        
#         }
#         elseif ($Script:GUICurrentStatus.NewPartitionToAdd -eq 'Amiga'){
#             if ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'At end of disk'){
#                 $AddType = 'AtEnd'     
#                 $AmigaDiskName = "$($Script:GUICurrentStatus.SelectedGPTMBRPartition)_AmigaDisk"
#             }
#             elseif ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
#                 $AddType = 'Left'   
#                 $AmigaDiskName = ($Script:GUICurrentStatus.SelectedAmigaPartition.Substring(0,($Script:GUICurrentStatus.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10))) 
#             }
#             elseif ($WPF_DP_AddNewAmigaPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
#                 $AddType = 'Right'  
#                 $AmigaDiskName = ($Script:GUICurrentStatus.SelectedAmigaPartition.Substring(0,($Script:GUICurrentStatus.SelectedAmigaPartition.IndexOf('_AmigaDisk_Partition_')+10))) 
#             }
            
#              $CurrentNumberofPartitionsonAmigaDisk = (Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $AmigaDiskName}).Count

#              if ($CurrentNumberofPartitionsonAmigaDisk -eq $Script:Settings.AmigaPartitionsperDiskMaximum){
#                  $null = Show-WarningorError -Msg_Header "Exceeded maximum number of partitions" -Msg_Body "You have $($Script:Settings.AmigaPartitionsperDiskMaximum) partitions on this disk! No more partitions can be added." -BoxTypeError -ButtonType_OK
#                  return
#              }
         
#              if (-not ($CurrentNumberofPartitionsonAmigaDisk)){
#                  $CanAddPartition = $true
#                  $EmptyAmigaDisk = $true
#              }
#              else {
#                  $CanAddPartition = (Get-Variable -Name $AmigaDiskName).value.CanAddPartition
#                  $EmptyAmigaDisk = $false
#                  If (($AddType -eq "AtEnd") -and (-not ($Script:GUICurrentStatus.SelectedAmigaPartition))){
#                      $PartitionNexttotouse = (Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName}).PartitionName | Select-Object -Last 1
#                  }
#                  else {
#                      $PartitionNexttotouse = $Script:GUICurrentStatus.SelectedAmigaPartition
#                  }
#              }
             
#              if ($EmptyAmigaDisk -eq $true){
#                      $AvailableFreeSpace = (Get-Variable -name $AmigaDiskName).value.DiskSizeBytes
#                      write-debug "Available free space is: $AvailableFreeSpace "
#                  }
#     else {
#         $AvailableFreeSpace = (Get-AmigaDiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $PartitionNexttotouse)
#         write-debug "Available free space is: $AvailableFreeSpace "
#     }
#     if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
#         $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
#     }
#     else {
#         if ($AvailableFreeSpace -lt $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size){
#             $SpacetoUse = $Script:SDCardMinimumsandMaximums.PFS3Minimum
#         }
#         else {
#             $SpacetoUse = $Script:SDCardMinimumsandMaximums.DefaultAddPFS3Size
    
#         }             


#         }

            
        




















#         if $ValuetoCheck -lt 
#         Remove-Variable -Name 'WPF_NewPartitionWindow_*'
#         $Script:GUICurrentStatus.NewPartitionDefaultScale = $null
#             $Script:GUICurrentStatus.NewPartitionDefaultScale = $null
#     $Script:GUICurrentStatus.NewPartitiontoAddAmigaDiskName = $null
#     $Script:GUICurrentStatus.NewPartitionToAdd = $null
    
#         $null = $WPF_NewPartitionWindow.close()
#     }
#     else {
#         $Null = Show-WarningorError -BoxTypeWarning -ButtonType_OK -Msg_Header "Invalid entry" -Msg_Body "Please enter a valid value for the partition size or press cancel if you do not wish to add a partition."
#     }
# })

# $Script:SDCardMinimumsandMaximums
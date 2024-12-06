$WPF_DP_Input_DiskSize_Value | Add-Member -NotePropertyMembers @{
    InputEntry = $false
    InputEntryChanged = $false
    InputEntryInvalid = $false
}

$WPF_DP_Input_DiskSize_Value.add_GotFocus({
    Write-Host 'Got Focus - Diskvalue'
    $WPF_DP_Input_DiskSize_Value.InputEntry = $true
})

$WPF_DP_Input_DiskSize_Value.add_LostFocus({
    Write-Host 'Lost Focus'
    
    Update-GUIInputBox -InputBox $WPF_DP_Input_DiskSize_Value -SetDiskValues
    #Write-Host "InputEntryInvalid is: $($WPF_DP_Input_DiskSize_Value.InputEntryInvalid) Input_Entry is: $($WPF_DP_Input_DiskSize_Value.InputEntry)"   

})
   
$WPF_DP_Input_DiskSize_Value.add_TextChanged({
    if ($WPF_DP_Input_DiskSize_Value.InputEntry -eq $true){
        Write-Host 'Text Changed'
        $WPF_DP_Input_DiskSize_Value.InputEntryChanged = $true
        $WPF_DP_Input_DiskSize_Value.InputEntryInvalid = $null
    }
})

# $WPF_DP_Input_DiskSize_Value.add_LostFocus({
#     if (-not $Script:GUIActions.DiskSizeSelected -eq $true){
#         if ($WPF_DP_Input_DiskSize_Value.Text){
#             $Script:GUIActions.DiskSizeSelected = $true
#             #$WPF_DP_GridAmiga.Visibility = 'Visible'
#             $WPF_DP_GridMBR.Visibility = 'Visible'
#             Add-InitialMBRDisk -DiskSizeBytes (Get-ConvertedSize -Size ($WPF_DP_Input_DiskSize_Value.Text) -ScaleFrom ($WPF_DP_Input_DiskSize_SizeScale_Dropdown.SelectedItem) -Scaleto 'B').Size
#             $Script:SDCardMinimumsandMaximums = Set-MinimumPartitionSizes   -SizeofDiskBytes $WPF_DP_Disk_MBR.DiskSizeBytes `
#                                                                             -FAT32Divider 15 `
#                                                                             -Fat32Minimum (35840*1024) `
#                                                                             -ID76Minimum (35840*1024) `
#                                                                             -PFS3Minimum (10*1024*1024) `
#                                                                             -PFS3Maximum (101*1024*1024*1024) `
#                                                                             -SystemMinimum (100*1024*1024) `
#                                                                             -Fat32DefaultMaximum (1024*1024*1024) `
#                                                                             -WorkbenchDefaultMaximum  (1024*1024*1024) `
#                                                                             -WorkbenchDivider 15 `
#                                                                             -DefaultAddFAT32Size 1073741824 `
#                                                                             -DefaultAddID76Size 1073741824 `
#                                                                             -DefaultAddPFS3Size 1073741824 `
            
            
            
#             Add-GUIPartitiontoMBRDisk -PartitionType 'FAT32' -AddType 'Initial' -DefaultPartition $true -SizeBytes $Script:SDCardMinimumsandMaximums.FAT32Default
#             $RemainingSpace = ($WPF_DP_Disk_MBR.DiskSizeBytes - $Script:SDCardMinimumsandMaximums.FAT32Default)
            
#             Add-GUIPartitiontoMBRDisk -PartitionType 'ID76' -AddType 'Initial' -DefaultPartition $true -SizeBytes $RemainingSpace    

                
#         }
#         else{
#             $WPF_DP_GridAmiga.Visibility = 'Hidden'
#             $WPF_DP_GridMBR.Visibility = 'Hidden'
#         }
#         Update-UI -UpdateInputBoxes
#     }
#     else {
#         $PartitionsToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'MBR'}
#         $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).size
#         $NewSizeBytes = ((Get-ConvertedSize -Size ($WPF_DP_Input_DiskSize_Value.Text) -ScaleFrom ($WPF_DP_Input_DiskSize_SizeScale_Dropdown.SelectedItem) -Scaleto 'B').Size)
#         if ( $NewSizeBytes -ge ($WPF_DP_Disk_MBR.DiskSizeBytes -$DiskFreeSpaceSize)){
#             $WPF_DP_Disk_MBR.DiskSizeBytes = $NewSizeBytes
#             $WPF_DP_Disk_MBR.BytestoPixelFactor = $WPF_DP_Disk_MBR.DiskSizeBytes/$WPF_DP_Disk_MBR.DiskSizePixels 

#             Get-AllGUIPartitions -PartitionType 'MBR' | ForEach-Object {
#                 $LeftMargin = $_.value.StartingPositionBytes/$WPF_DP_Disk_MBR.BytestoPixelFactor
#                 $SizePixels = $_.value.PartitionSizeBytes/$WPF_DP_Disk_MBR.BytestoPixelFactor
#                 if ($SizePixels -gt 4){
#                     $SizePixels -= 4
#                 }
#                 $_.value.Margin = [System.Windows.Thickness]"$LeftMargin,0,0,0"
#                 $TotalColumns = $_.value.ColumnDefinitions.Count-1
#                 for ($i = 0; $i -le $TotalColumns; $i++) {
#                     if  ($_.value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
#                         $_.value.ColumnDefinitions[$i].Width = $SizePixels
#                     } 
#                 }               
#             }

#         } 

#     }
# })
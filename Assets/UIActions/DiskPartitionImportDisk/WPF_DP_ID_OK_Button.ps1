$WPF_DP_ID_OK_Button.Add_Click({
    
    if ($Script:GUICurrentStatus.ImportedImagePath){
        $PathtoPartition = $Script:GUICurrentStatus.ImportedImagePath

    }
    elseif ($Script:GUICurrentStatus.SelectedPhysicalDiskforImport){
        $PathtoPartition = $Script:GUICurrentStatus.SelectedPhysicalDiskforImport
    }

    if ($Script:GUICurrentStatus.ImportedPartitionType -eq 'MBR'){
        if ($WPF_DP_ID_MBR_DataGrid.SelectedItem){
            $PartitionNumber = $WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionNumber
            $PathforImport = "$PathtoPartition\MBR\$PartitionNumber" 

            $PartitionType = 'MBR'
            if ($WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionType -eq 'Amiga MBR Partition'){
                $PartitionSubType = 'ID76'
            }
            elseif ($WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionType -eq 'FAT32 Partition'){
                $PartitionSubType = 'FAT32'                
            }
            $PartitionName = "WPF_DP_Partition_MBR_$($WPF_DP_Disk_GPTMBR.NextPartitionMBRNumber)"
            $TotalPartitionSizeBytes = $WPF_DP_ID_MBR_DataGrid.SelectedItem.SizeBytes

            Write-host $PathforImport            
        } 
    }
    elseif ($Script:GUICurrentStatus.ImportedPartitionType -eq 'RDB'){
        $PathforImport = "$PathtoPartition\MBR\$PartitionNumber\RDB" 
        $PartitionType = 'MBR'
        $PartitionSubType = 'ID76'
        $PartitionName = "WPF_DP_Partition_MBR_$($WPF_DP_Disk_GPTMBR.NextPartitionMBRNumber)"
        
        $TotalPartitionSizeBytes = ($Script:GUICurrentStatus.RDBPartitionstoImportDataTable | Measure-Object -Property SizeBytes -Sum).Sum

        Write-host $PathforImport            

    }
    
    if (-not ($PathforImport)){
        $null = Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a partition for import' -BoxTypeError -ButtonType_OK
        return
    } 

    if (($Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes - $TotalPartitionSizeBytes) -lt 0){
        Show-WarningorError -Msg_Header 'Insufficient Space' -Msg_Body 'You have insufficient space to import the partition! Either cancel or select a smaller partition' -BoxTypeError -ButtonType_OK
        return
    }

    if ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'        
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType = 'Left'   
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType = 'Right'   
    }

    if ($Script:GUICurrentStatus.ImportedPartitionType -eq 'MBR'){
        Add-GUIPartitiontoGPTMBRDisk -ImportedPartitionMethod 'Direct' -PathtoImportedPartition $PathforImport -PartitionType $PartitionType -PartitionSubType $PartitionSubType -SizeBytes $TotalPartitionSizeBytes -AddType $AddType -ImportedPartition
        if ($PartitionSubType -eq 'ID76'){
            Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName -ImportedDisk
            $Script:GUICurrentStatus.RDBPartitionstoImportDataTable |ForEach-Object {
                $StartPoint_MaxTransfer = 0
                $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
                $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
                
                $StartPoint_DosType = $_.DosType.IndexOf('(')+1
                $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
                $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)

                $StartPoint_Mask = 0
                $Length_Mask  = $_.Mask.IndexOf(' ')
                $Mask  = $_.Mask.Substring($StartPoint_Mask,$Length_Mask)                
            
                Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.SizeBytes -AddType 'AtEnd' -ImportedPartition -ImportedPartitionMethod 'Derived'  -VolumeName $_.VolumeName -DeviceName $_.DeviceName -Buffers $_.Buffers -DosType $DosType -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority -Mask $mask
            }          
        }
    }
    elseif ($Script:GUICurrentStatus.ImportedPartitionType -eq 'RDB'){
        Add-GUIPartitiontoGPTMBRDisk -ImportedPartitionMethod 'Derived' -PathtoImportedPartition $PathforImport -PartitionType $PartitionType -PartitionSubType $PartitionSubType -SizeBytes $TotalPartitionSizeBytes -AddType $AddType -ImportedPartition
        Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName -ImportedDisk
        $Script:GUICurrentStatus.RDBPartitionstoImportDataTable |ForEach-Object {
            $StartPoint_MaxTransfer = 0
            $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
            $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
            
            $StartPoint_DosType = $_.DosType.IndexOf('(')+1
            $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
            $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)

            $StartPoint_Mask = $_.Mask.IndexOf('(')+1
            $Length_Mask  = $_.Mask.IndexOf(' ')
            $Mask  = $_.Mask.Substring($StartPoint_Mask,$Length_Mask)
        
            Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.SizeBytes -AddType 'AtEnd' -ImportedPartition -ImportedPartitionMethod 'Derived'  -VolumeName $_.VolumeName -DeviceName $_.DeviceName -Buffers $_.Buffers -DosType $DosType -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority -Mask $mask
        }   
    }

    $Script:GUICurrentStatus.ImportedImagePath = $null
    $Script:GUICurrentStatus.ImportedPartitionType = $null
    $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $null

    $WPF_SelectDiskWindow.Close()
})


    #             $ListofRDBPartitions = Get-HSTPartitionInfo -Path "$SourcePath$($WPF_DP_ID_MBR_DataGrid.SelectedItem.Number)" -RDBInfo
                
    #             $ListofRDBPartitions |ForEach-Object {               
                    
    #                 $StartPoint_MaxTransfer = 0
    #                 $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
    #                 $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
    #                 $MaxTransfer
    #             }
    #                 # $StartPoint_DosType = $_.DosType.IndexOf('(')+1
    #                 # $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
    #                 # $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)
    #                 if($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
    #                     Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -VolumeName $_.VolumeName -DeviceName $_.Name -Buffers $_.Buffers -DosType $_.Type -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority
    #                 }
    #                 elseif ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage'){
    #                 }
    #             }            
    # #         }








# if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk'){
#             }
#             elseif($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
#                 Add-GUIPartitiontoMBRDisk -ImportedMBRPartitionNumber ($WPF_DP_ID_MBR_DataGrid.SelectedItem.Number) -ImportedPartitionMethod 'Amiga' -PathtoImportedPartition "$SourcePath" -PartitionType $PartitionType -SizeBytes $WPF_DP_ID_MBR_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true
#             }
    
#             if ($PartitionType -eq 'ID76'){
#                 $ListofRDBPartitions = Get-HSTPartitionInfo -Path "$SourcePath$($WPF_DP_ID_MBR_DataGrid.SelectedItem.Number)" -RDBInfo
#                 Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName
#                 $ListofRDBPartitions |ForEach-Object {               
                    
#                     $StartPoint_MaxTransfer = 0
#                     $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
#                     $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
        
#                     # $StartPoint_DosType = $_.DosType.IndexOf('(')+1
#                     # $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
#                     # $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)
#                     if($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
#                         Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -VolumeName $_.VolumeName -DeviceName $_.Name -Buffers $_.Buffers -DosType $_.Type -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority
#                     }
#                     elseif ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage'){
#                         Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -DerivedImportedPartition $true -VolumeName $_.VolumeName -DeviceName $_.Name -Buffers $_.Buffers -DosType $_.Type -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority
#                     }
#                 }            
#     #         }















# elseif ($WPF_DP_ID_MBR_DataGrid.SelectedItem) { 
    
# }
# else{
# }

# else {
#     Write-Host 'Error!'
#     exit
# }
#     $Script:GUICurrentStatus.ImportedImagePath

#     if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
        
#         $Script:GUIActions.ImportPartitionWindowStatus = $null
#     }
#     elseif (($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRDisk') -and (-not ($Script:GUIActions.SelectedPhysicalDiskforImport))){
#             Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
#             $Script:GUIActions.ImportPartitionWindowStatus = $null
#     }
#     elseif (($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRImage') -and (-not ($Script:GUIActions.ImportedImagePath))){
#             Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
#             $Script:GUIActions.ImportPartitionWindowStatus = $null
#     }   
#     elseif (($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromAmigaImage') -and (-not ($Script:GUIActions.ImportedImagePath))){
#             Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
#             $Script:GUIActions.ImportPartitionWindowStatus = $null
#     }
#     elseif (-not ($WPF_DP_ID_MBR_DataGrid.SelectedItem)){
#         Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not selected a partition for import. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
#         $Script:GUIActions.ImportPartitionWindowStatus = $null
#     }
#     elseif (($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_DP_ID_MBR_DataGrid.SelectedItem.TotalBytes) -lt 0){
#         Show-WarningorError -Msg_Header'Insufficient Space' -Msg_Body 'You have insufficient space to import the partition! Either cancel or select a smaller partition' -BoxTypeError -ButtonType_OK
#         $Script:GUIActions.ImportPartitionWindowStatus = $null
#     }
#     else {
#         if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk'){
#             if ($WPF_DP_ID_MBR_DataGrid.SelectedItem){
#                 if ($WPF_DP_ID_MBR_DataGrid.SelectedItem.Type -match 'PiStorm RDB'){
#                     $PartitionType = 'ID76'
#                     $PartitionName = "WPF_DP_Partition_ID76_$($WPF_DP_Disk_MBR.NextPartitionID76Number)" 
#                 }
#                 elseif ($WPF_DP_ID_MBR_DataGrid.SelectedItem.Type -match 'FAT32'){
#                     $PartitionType = 'FAT32'
#                     $PartitionName = "WPF_DP_Partition_MBR_$($WPF_DP_Disk_GPTMBR.NextPartitionMBRNumber)"
#                 }
#             }
#             if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage'){
#                 $SourcePath = "$($Script:GUIActions.ImportedImagePath)\mbr\"
#             }
#             elseif ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk'){
#                 $SourcePath = "$($Script:GUIActions.SelectedPhysicalDiskforImport)\mbr\"
#             }
#         }
#         elseif($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
#             $PartitionType = 'ID76'
#             $PartitionName = "WPF_DP_Partition_ID76_$($WPF_DP_Disk_MBR.NextPartitionID76Number)"    
#             $SourcePath = "$($Script:GUIActions.ImportedImagePath)"
#         }
        
#         if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk'){
#             Add-GUIPartitiontoMBRDisk -ImportedMBRPartitionNumber ($WPF_DP_ID_MBR_DataGrid.SelectedItem.Number) -ImportedPartitionMethod 'ID76' -PathtoImportedPartition "$SourcePath$($WPF_DP_ID_MBR_DataGrid.SelectedItem.Number)" -PartitionType $PartitionType -SizeBytes $WPF_DP_ID_MBR_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true
#         }
#         elseif($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
#             Add-GUIPartitiontoMBRDisk -ImportedMBRPartitionNumber ($WPF_DP_ID_MBR_DataGrid.SelectedItem.Number) -ImportedPartitionMethod 'Amiga' -PathtoImportedPartition "$SourcePath" -PartitionType $PartitionType -SizeBytes $WPF_DP_ID_MBR_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true
#         }

#         if ($PartitionType -eq 'ID76'){
#             $ListofRDBPartitions = Get-HSTPartitionInfo -Path "$SourcePath$($WPF_DP_ID_MBR_DataGrid.SelectedItem.Number)" -RDBInfo
#             Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName
#             $ListofRDBPartitions |ForEach-Object {               
                
#                 $StartPoint_MaxTransfer = 0
#                 $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
#                 $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
    
#                 # $StartPoint_DosType = $_.DosType.IndexOf('(')+1
#                 # $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
#                 # $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)
#                 if($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
#                     Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -VolumeName $_.VolumeName -DeviceName $_.Name -Buffers $_.Buffers -DosType $_.Type -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority
#                 }
#                 elseif ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage'){
#                     Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -DerivedImportedPartition $true -VolumeName $_.VolumeName -DeviceName $_.Name -Buffers $_.Buffers -DosType $_.Type -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority
#                 }
#             }            
#         }
#         $Script:GUIActions.AvailableSpaceforImportedPartitionBytes = $null
#         $Script:GUIActions.SelectedPhysicalDiskforImport = $null
#         $Script:GUIActions.ImportPartitionWindowStatus = $null
#         $Script:GUIActions.ImportedImagePath = $null           
    
#         $WPF_SelectDiskWindow.Close()
#     }


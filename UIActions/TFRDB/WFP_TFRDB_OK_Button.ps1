$WPF_TFRDB_OK_Button.Add_Click({
    if ($WPF_TFRDB_RDB_DataGrid.SelectedItem){
        if ($Script:GUIActions.ImportedImagePath){
            $Script:GUIActions.TransferSourceType = 'Amiga'
            if ($WPF_TFRDB_MBR_DataGrid.SelectedItem){

            }
            else{
                $Script:GUIActions.TransferSourceLocation = "$($Script:GUIActions.ImportedImagePath)\rdb\$($WPF_TFRDB_RDB_DataGrid.SelectedItem.Name)"                
            }
            $Script:GUIActions.ImportedImagePath = $null
            $Script:GUIActions.SelectedPhysicalDisk = $null
        }
        elseif ($Script:GUIActions.SelectedPhysicalDisk){
            $Script:GUIActions.TransferSourceType = 'Amiga'
            $Script:GUIActions.TransferSourceLocation = $Script:GUIActions.SelectedPhysicalDisk
            $Script:GUIActions.SelectedPhysicalDisk = $null
            $Script:GUIActions.ImportedImagePath = $null
        }

        $WPF_SelectRDBSourceWindow.Close()
        

    }
    
})




#     if ($Script:GUIActions.ActionToPerform -eq 'ImportRDBPartition'){
#             Write-host "Importing RDB Partition"
            
#             Add-GUIPartitiontoAmigaDisk -AmigaDiskName "$($Script:GUIActions.SelectedMBRPartition)_AmigaDisk" -SizeBytes $WPF_TFRDB_RDB_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true PathtoImportedPartition "$($Script:GUIActions.SelectedPhysicalDisk)\mbr\$($WPF_TFRDB_MBR_DataGrid.SelectedItem.Number)\rdb\$($WPF_TFRDB_RDB_DataGrid.SelectedItem.Number)" 
            
#         }
#     }
#     elseif ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
#         if ($WPF_TFRDB_MBR_DataGrid.SelectedItem){
#             if ($WPF_TFRDB_MBR_DataGrid.SelectedItem.Type -match 'PiStorm RDB'){
#                 $PartitionType = 'ID76'
#             }
#             elseif ($WPF_TFRDB_MBR_DataGrid.SelectedItem.Type -match 'FAT32'){
#                 $PartitionType = 'FAT32'
#             }

#             $PartitionName = "WPF_DP_Partition_ID76_$($WPF_DP_Disk_MBR.NextPartitionID76Number)" 
#             Add-GUIPartitiontoMBRDisk -PathtoImportedPartition "$($Script:GUIActions.SelectedPhysicalDisk)\mbr\$($WPF_TFRDB_MBR_DataGrid.SelectedItem.Number)" -PartitionType $PartitionType -SizeBytes $WPF_TFRDB_MBR_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true
#             $ListofRDBPartitions = Get-HSTPartitionInfo -Path "$($Script:GUIActions.SelectedPhysicalDisk)\mbr\$($WPF_TFRDB_MBR_DataGrid.SelectedItem.Number)" -RDBInfo
#             Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName
#             $ListofRDBPartitions |ForEach-Object {               

#                 $StartPoint_MaxTransfer = 0
#                 $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
#                 $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )

#                 # $StartPoint_DosType = $_.DosType.IndexOf('(')+1
#                 # $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
#                 # $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)

#                 Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -DerivedImportedPartition $true -VolumeName 'Unknown' -DeviceName $_.Name -Buffers $_.Buffers -DosType $_.Type -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority
#             }
#         }
#     }
#     $Script:GUIActions.AvailableSpaceforImportedPartitionBytes = $null
#     $Script:GUIActions.SelectedPhysicalDisk = $null
#     $Script:GUIActions.ListofRemovableMedia = $null
#     $WPF_SelectDiskWindow.Close()


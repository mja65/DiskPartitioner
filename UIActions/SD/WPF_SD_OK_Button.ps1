$WPF_SD_OK_Button.Add_Click({
    if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
        Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
        $Script:GUIActions.ImportPartitionWindowStatus = $null
    }
    elseif (($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRDisk') -and (-not ($Script:GUIActions.SelectedPhysicalDiskforImport))){
            Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
            $Script:GUIActions.ImportPartitionWindowStatus = $null
    }
    elseif (($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRImage') -and (-not ($Script:GUIActions.ImportedImagePath))){
            Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
            $Script:GUIActions.ImportPartitionWindowStatus = $null
    }   
    elseif (($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromAmigaImage') -and (-not ($Script:GUIActions.ImportedImagePath))){
            Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
            $Script:GUIActions.ImportPartitionWindowStatus = $null
    }
    elseif (-not ($WPF_SD_MBR_DataGrid.SelectedItem)){
        Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not selected a partition for import. Either cancel or select a  partition for import' -BoxTypeError -ButtonType_OK
        $Script:GUIActions.ImportPartitionWindowStatus = $null
    }
    elseif (($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes) -lt 0){
        Show-WarningorError -Msg_Header'Insufficient Space' -Msg_Body 'You have insufficient space to import the partition! Either cancel or select a smaller partition' -BoxTypeError -ButtonType_OK
        $Script:GUIActions.ImportPartitionWindowStatus = $null
    }
    else {
        if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk'){
            if ($WPF_SD_MBR_DataGrid.SelectedItem){
                if ($WPF_SD_MBR_DataGrid.SelectedItem.Type -match 'PiStorm RDB'){
                    $PartitionType = 'ID76'
                    $PartitionName = "WPF_DP_Partition_ID76_$($WPF_DP_Disk_MBR.NextPartitionID76Number)" 
                }
                elseif ($WPF_SD_MBR_DataGrid.SelectedItem.Type -match 'FAT32'){
                    $PartitionType = 'FAT32'
                    $PartitionName = "WPF_DP_Partition_FAT32_$($WPF_DP_Disk_MBR.NextPartitionFAT32Number)"
                }
            }
            if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage'){
                $SourcePath = "$($Script:GUIActions.ImportedImagePath)\mbr\"
            }
            elseif ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk'){
                $SourcePath = "$($Script:GUIActions.SelectedPhysicalDiskforImport)\mbr\"
            }
        }
        elseif($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
            $PartitionType = 'ID76'
            $PartitionName = "WPF_DP_Partition_ID76_$($WPF_DP_Disk_MBR.NextPartitionID76Number)"    
            $SourcePath = "$($Script:GUIActions.ImportedImagePath)"
        }
        
        if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRImage' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromMBRDisk'){
            Add-GUIPartitiontoMBRDisk -ImportedMBRPartitionNumber ($WPF_SD_MBR_DataGrid.SelectedItem.Number) -ImportPartitionMethod 'ID76' -PathtoImportedPartition "$SourcePath$($WPF_SD_MBR_DataGrid.SelectedItem.Number)" -PartitionType $PartitionType -SizeBytes $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true
        }
        elseif($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionfromAmigaImage'){
            Add-GUIPartitiontoMBRDisk -ImportedMBRPartitionNumber ($WPF_SD_MBR_DataGrid.SelectedItem.Number) -ImportPartitionMethod 'Amiga' -PathtoImportedPartition "$SourcePath" -PartitionType $PartitionType -SizeBytes $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true
        }

        if ($PartitionType -eq 'ID76'){
            $ListofRDBPartitions = Get-HSTPartitionInfo -Path "$SourcePath$($WPF_SD_MBR_DataGrid.SelectedItem.Number)" -RDBInfo
            Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName
            $ListofRDBPartitions |ForEach-Object {               
                
                $StartPoint_MaxTransfer = 0
                $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
                $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
    
                # $StartPoint_DosType = $_.DosType.IndexOf('(')+1
                # $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
                # $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)
                Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -DerivedImportedPartition $true -VolumeName 'Unknown' -DeviceName $_.Name -Buffers $_.Buffers -DosType $_.Type -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority
            }            
        }
        $Script:GUIActions.AvailableSpaceforImportedPartitionBytes = $null
        $Script:GUIActions.SelectedPhysicalDiskforImport = $null
        $Script:GUIActions.ImportPartitionWindowStatus = $null
        $Script:GUIActions.ImportedImagePath = $null           
    
        $WPF_SelectDiskWindow.Close()
    }
})
